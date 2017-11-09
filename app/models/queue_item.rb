class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :video_id
  validates_numericality_of :position, {only_integer: true}

  def rating
    review = user.reviews.find_by({ video: video })
    review.rating if review
  end

  def video_title
    video.title.titleize
  end

  def update_position(position)
    queue_item.update!({ position: position })
  end

  def update_review_rating(rating)
    binding.pry
    review = user.reviews.find_by({ video: video })
    review.update!({ rating: rating }) if review.rating != rating
  end

end