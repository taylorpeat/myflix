class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  attr_accessor :skip_content_validation

  validates_presence_of :content, unless: :skip_content_validation
  validates_presence_of :rating
  validates_numericality_of :rating, greater_than: 0, less_than_or_equal_to: 5, only_integer: true
end