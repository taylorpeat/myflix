class ReviewsController < ApplicationController

  before_filter :require_user

  def create
    review = Review.create(review_params)
    redirect_to video_path(review.video_id)
  end


  private

  def review_params
    params.require(:review).permit(:rating, :content, :video_id).merge({ user_id: current_user.id })
  end
end