class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order 'position' }

  has_secure_password

  validates :email, uniqueness: true, presence: true
  validates :full_name, presence: true

  def update_queue_positions
    position = 1
    
    queue_items.each do |q_item|
      q_item.position = position
      q_item.save
      position += 1
    end
  end

end
