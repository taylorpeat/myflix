class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :content, :rating
  validates_numericality_of :rating, greater_than: 0, less_than_or_equal_to: 5, only_integer: true, allow_nil: true
end