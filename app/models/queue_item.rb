class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :video_id
  validates_numericality_of :position, {only_integer: true}

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    review.rating = new_rating
  end

  def review
    user.reviews.find_by({ video: video })
  end

  def video_title
    video.title.titleize
  end

end