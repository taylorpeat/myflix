class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.assign_attributes(rating: new_rating)
      review.skip_content_validation = true
      review.save
    else
      return if new_rating.blank?
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

  def category_name
    video.try(:category).try(:name).try(:titleize)
  end
end