class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  def rating
    review = user.reviews.where({ video_id: video.id }).first
    review.rating if review
  end

  def video_title
    video.title.titleize
  end
end