class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :video_id
  validates_numericality_of :position

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_attributes(rating: new_rating)
    else
      new_review = Review.new(rating: new_rating, video: video, user: user)
      new_review.skip_content_validation = true
      new_review.save
    end
  end

  def review
    @review ||= user.reviews.find_by({ video: video })
  end

  def video_title
    video.title.titleize
  end

end