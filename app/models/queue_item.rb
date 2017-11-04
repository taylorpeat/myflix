class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :position

  def rating
    review = user.reviews.where({ video_id: video.id }).first
    review.rating if review
  end

  def video_title
    video.title.titleize
  end

  def self.next_position
    QueueItem.all.pluck('position').max + 1
  end
end