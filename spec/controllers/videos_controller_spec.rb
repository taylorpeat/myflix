require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context 'authenticated user' do
      let(:video) { Fabricate(:video) }
      let(:reviews) do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        [review1, review2]
      end

      before do
        set_current_user
        get :show, id: video.id
      end
      
      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end

      it "sets @reviews" do
        expect(assigns(:reviews)).to match_array(reviews)
      end

      it 'displays reviews in reverse chronological order' do
        expect(assigns(:reviews)).to eq(reviews.reverse)
      end
    end

    it_behaves_like "require_sign_in" do
      video = Fabricate(:video)
      let(:action) { get :show, id: video.id }
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      set_current_user
      futurama = Fabricate(:video, title: "futurama")
      back_to_the_future = Fabricate(:video, title: "back to the future")
      superman = Fabricate(:video, title: "superman")
      post :search, query: 'futur'
      expect(assigns(:videos)).to eq([futurama, back_to_the_future])
    end
    
    it_behaves_like "require_sign_in" do
      let(:action) { post :search, query: 'futur' }
    end
  end
end 