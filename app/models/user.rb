class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order(:position) }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :followers, through: :following_relationships, class_name: "User", foreign_key: :follower_id
  has_many :leaders, through: :following_relationships, class_name: "User", foreign_key: :leader_id

  has_secure_password

  validates :email, uniqueness: true, presence: true
  validates :full_name, presence: true

  def normalize_queue_positions
    queue_items.each_with_index do |q_item, idx|
      q_item.position = idx + 1
      q_item.save
    end
  end
  
  def next_queue_item_position
    queue_items.count + 1
  end

  def queued_video?(video)
    !!queue_items.find_by(video_id: video.id)
  end

  def follows?(leader)
    !!self.following_relationships.find_by(leader_id: leader.id)
  end

  def can_follow?(leader)
    self != leader && !self.follows?(leader)
  end

  def generate_token
    self.update_columns(token: SecureRandom.urlsafe_base64)
  end

  def clear_token
    self.update_columns(token: nil)
  end

  def follow(another_user)
    self.following_relationships.create(leader_id: another_user.id)
  end
end
