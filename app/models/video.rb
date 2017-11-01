class Video < ActiveRecord::Base
  belongs_to :category
  has_many :queue_items
  has_many :reviews, -> { order("created_at DESC") }

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?

    where("title LIKE ?", "%#{search_term}%").order("created_at ASC")
  end

  def self.search_by_category(category_id)
    return [] if category_id.blank?
    where({ category_id: category_id })
  end

  def rating
    return nil if reviews.empty?
    (reviews.reduce(0) { |sum, r| r.rating.to_f + sum } / reviews.count).round(1)
  end
end