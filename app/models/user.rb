class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order 'position' }

  has_secure_password

  validates :email, uniqueness: true, presence: true
  validates :full_name, presence: true

  def normalize_queue_positions
    queue_items.each_with_index do |q_item, idx|
      q_item.position = idx + 1
      q_item.save
    end
  end

  def create_queue_item_from_params(params, current_user)
    QueueItem.new({ user: current_user, video_id: params[:video_id], position: next_queue_item_position(current_user) })
  end
  
  def next_queue_item_position
    queue_items.count + 1
  end

end
