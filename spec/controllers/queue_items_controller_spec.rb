require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }

    let(:queue_items) do
      queue_item1 = Fabricate(:queue_item, video: video1, user: user )
      queue_item2 = Fabricate(:queue_item, video: video2, user: user )
      [queue_item1, queue_item2]
    end

    context "With authenticated user" do
      before do
        session[:user_id] = user.id
        get :index
      end

      it "sets @queue_items" do
        expect(assigns(:queue_items)).to match_array(queue_items)
      end
    end

    context "With unauthenticated user" do
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
