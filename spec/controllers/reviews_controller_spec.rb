require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'authenticated user' do    
      before do
        set_current_user
      end
      
      context 'valid input' do
        let(:video) { Fabricate(:video) }
        let(:review) { Fabricate.attributes_for(:review, video: video) }
        
        before do |b|
          post :create, review: review, video_id: video.id unless b.metadata[:skip_before]
        end
        
        it 'creates new review' do
          expect(Review.count).to eq(1)
        end

        it 'creates a review associated with the video' do
          expect(Review.first.video_id).to eq(video.id)
        end

        it 'refreshes page' do
          expect(response).to redirect_to(video_path(video.id))
        end

        it 'doesnt display an error message' do
          expect(flash[:error]).to be_blank
        end
      end

      context 'invalid input' do
        let(:video) { Fabricate(:video) }
        let(:invalid_review) { { rating: 1, content: '', video_id: video.id } }
        
        before do
          post :create, review: invalid_review, video_id: video.id
        end

        it "doesn't create review" do
          expect(Review.count).to eq(0)
        end

        it 'displays error message' do
          expect(flash[:error]).to be_present
        end

        it 'refreshes page' do
          expect(response).to redirect_to(video_path(video.id))
        end
      end
    end

    it_behaves_like "require_sign_in" do
      video = Fabricate(:video)
      review = Fabricate.attributes_for(:review, video: video)
      let(:action) { post :create, review: review, video_id: video.id }
    end

  end
end