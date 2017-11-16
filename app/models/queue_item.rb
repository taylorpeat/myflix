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
      review.rating = new_rating
      review.save
    else
      new_review = Review.create!({ rating: new_rating, video: video, user: user, content: 'a' })
    end
  end

  def review
    @review ||= user.reviews.find_by({ video: video })
  end

  def video_title
    video.title.titleize
  end

end