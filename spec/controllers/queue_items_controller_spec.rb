require 'spec_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }

  describe "GET index" do
    context "With authenticated user" do
      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      let(:queue_items) do
        queue_item1 = Fabricate(:queue_item, video: video1, user: user, position: user.queue_items.count + 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: user, position: user.queue_items.count + 1 )
        [queue_item1, queue_item2]
      end

      before do
        set_current_user(user)
        get :index
      end

      it "sets @queue_items" do
        expect(assigns(:queue_items)).to match_array(queue_items)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    context "With authenticated user" do
      before do
        set_current_user(user)
      end

      context "With valid attributes" do      
        let(:video1) { Fabricate(:video) }
        before do
          post :create, video_id: video1.id
        end

        it "creates a new queue item" do
          expect(QueueItem.count).to eq(1)
        end
        
        it "creates a new queue item with the video relation" do
          expect(QueueItem.first.video).to eq(video1)
        end
        
        it "creates a new queue item with the user relation" do
          expect(QueueItem.first.user).to eq(user)
        end

        it "assigns new queue item last queue position" do
          video2 = Fabricate(:video)
          post :create, video_id: video2.id
          expect(QueueItem.last.position).to eq(2)
        end

        it "does not add video to the queue if it is already in the queue" do
          post :create, video_id: video1.id
          expect(QueueItem.count).to eq(1)
          expect(flash[:error]).not_to be_nil
        end

        it "redirects to my queue" do
          expect(response).to redirect_to my_queue_path
        end
      end

      context "Without valid attributes" do
        before do
          post :create
        end

        it "redirects to my queue" do
          expect(response).to redirect_to my_queue_path
        end

        it "displays flash error" do
          expect(flash[:error]).not_to be_nil
        end

        it "doesn't create a queue item" do
          expect(QueueItem.count).to eq(0)
        end
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end
  end

  describe "DELETE destroy" do
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let!(:queue_item1) { Fabricate(:queue_item, video: video1, user: user, position: user.queue_items.count + 1) }
    let!(:queue_item2) { Fabricate(:queue_item, video: video2, user: user, position: user.queue_items.count + 1) }

    context "With authenticated user" do
      before do
        set_current_user(user)
      end

      it "removes queue item" do
        delete :destroy, id: queue_item1.id
        expect(QueueItem.count).to eq(1)
      end
      
      it "doesn't remove queue item unless it belongs to current user", skip_before: true do
        user2 = Fabricate(:user)
        set_current_user(user2)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.count).to eq(2)
      end
      
      it "updates positions of remaining queue items" do
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq(1) 
      end

      it "displays notice item is removed" do
        delete :destroy, id: queue_item1.id
        expect(flash[:notice]).not_to be_nil
      end
      
      it "redirects to my queue page" do
        delete :destroy, id: queue_item1.id
        expect(response).to redirect_to my_queue_path
      end
      
      it "normalizes positions after deleting queue item" do
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: queue_item1.id }
    end
  end

  describe "POST update" do
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let!(:queue_item1) { Fabricate(:queue_item, video: video1, user: user, position: "1") }
    let!(:queue_item2) { Fabricate(:queue_item, video: video2, user: user, position: "2") }

    context "With authenticated user" do
      before do
        set_current_user(user)
      end
      
      it "updates position of queue item" do
        post :update, queue_items: [{ id: queue_item1.id, position: "2", rating: "" },
                                    { id: queue_item2.id, position: "1", rating: "" }]
        
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "updates other queue item positions" do
        post :update, queue_items: [{ id: queue_item1.id, position: "3", rating: "" },
                                    { id: queue_item2.id, position: "2", rating: "" }]

        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "doesn't update queue items not belonging to current user" do
        user2 = Fabricate(:user)
        video3 = Fabricate(:video)
        queue_item3 = Fabricate(:queue_item, video: video3, user: user2, position: "3")

        post :update, queue_items: [{ id: queue_item1.id, position: "3", rating: "" },
                                    { id: queue_item2.id, position: "2", rating: "" },
                                    { id: queue_item3.id, position: "1", rating: "" }]
        
        expect(queue_item3.reload.position).to eq(3)
      end

      it "displays error message when transaction fails" do
        post :update, queue_items: [{ id: queue_item1.id, position: "3", rating: "" },
                                    { id: queue_item2.id, position: "D", rating: "" }]

        expect(flash[:error]).not_to be_nil
      end

      it "updates review rating" do
        review1 = Fabricate(:review, video: video1, user: user, rating: "5")

        post :update, queue_items: [{ id: queue_item1.id, position: "1", rating: "1" },
                                    { id: queue_item2.id, position: "2", rating: "" }]
        
        expect(review1.reload.rating).to eq(1)
      end
      
      it "creates new review if user does not have one" do
        post :update, queue_items: [{ id: queue_item1.id, position: "1", rating: "1" },
                                    { id: queue_item2.id, position: "2", rating: "" }]
        
        expect(user.reviews.first.rating).to eq(1)
      end

      it "doesn't create a new review if rating is nil" do
        post :update, queue_items: [{ id: queue_item1.id, position: "1", rating: "" },
                                    { id: queue_item2.id, position: "2", rating: "" }]
        
        expect(user.reviews.count).to eq(0)
      end

      it "doesn't create new review if user does have one" do
        review1 = Fabricate(:review, video: video1, user: user, rating: "5")
        expect(user.reviews.count).to eq(1)

        post :update, queue_items: [{ id: queue_item1.id, position: "1", rating: "1" },
                                    { id: queue_item2.id, position: "2", rating: nil }]
        
        expect(user.reviews.count).to eq(1)
      end

      it "updates existing nil rating to new value" do
        review1 = Fabricate(:review, video: video1, user: user, rating: nil)

        post :update, queue_items: [{ id: queue_item1.id, position: "1", rating: "1" },
                                    { id: queue_item2.id, position: "2", rating: nil }]

        expect(review1.reload.rating).to eq(1)
      end

      it "doesn't accept updating a rating over 5" do
        review1 = Fabricate(:review, video: video1, user: user, rating: 4)

        post :update, queue_items: [{ id: queue_item1.id, position: "1", rating: "6" },
                                    { id: queue_item2.id, position: "2", rating: nil }]

        expect(review1.reload.rating).to eq (4)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) do
        post :update, queue_items: [{ id: queue_item1.id, position: "3", rating: queue_item1.rating },
                                    { id: queue_item2.id, position: "2", rating: queue_item2.rating }]
      end
    end
  end
end
