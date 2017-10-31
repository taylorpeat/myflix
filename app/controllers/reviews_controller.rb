class ReviewsController < ApplicationController

  before_filter :require_user

  def create
    review = Review.new(review_params)
    if review.save
      redirect_to video_path(review.video_id)
    else
      flash[:error] = "The review was incomplete. Please resubmit."
      redirect_to video_path(review.video_id)
    end
  end


  private

  def review_params
    params.require(:review).permit(:rating, :content).merge({ video_id: params[:video_id]}).merge({ user_id: current_user.id })
  end
end