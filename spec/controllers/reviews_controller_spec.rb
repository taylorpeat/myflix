require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'authenticated user' do
      let(:video) { Fabricate(:video) }
      
      before do
        session[:user_id] = Fabricate(:user).id
      end
      
      context 'valid input' do
        let(:review) { Fabricate.attributes_for(:review, video: video) }
        before do
          post :create, review: review
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
      end
      context 'invalid input' do
        let(:invalid_review) { { rating: 1, content: '', video_id: video.id } }
        
        before do
          post :create, review: invalid_review
        end

        it "doesn't create review" do
          expect(Review.count).to eq(0)
        end
        it 'displays error message' do
          expect(response[:error]).to eq('The review was incomplete. Please resubmit.')
        end
        it 'refreshes page' do
        end
      end
    end
    context 'unauthenticated user' do
    end
  end
end