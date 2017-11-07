class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :video_id
  validates_numericality_of :position, {only_integer: true}

  def rating
    review = user.reviews.where({ video_id: video.id }).first
    review.rating if review
  end

  def video_title
    video.title.titleize
  end

  def self.create_queue_item_from_params(params, current_user)
    QueueItem.new({ user: current_user, video_id: params[:video_id], position: next_queue_item_position(current_user) })
  end

  def self.update_attributes_from_params(params, current_user)
    ActiveRecord::Base.transaction do
      queue_item_params = params[:queue_items]
      
      queue_item_params.each do |queue_item_attributes|
        queue_item = QueueItem.find(queue_item_attributes["id"])
        if queue_item.user == current_user
          queue_item.update!({ position: queue_item_attributes["position"] })
        end
      end
    end
  end

  private 

    def self.next_queue_item_position(current_user)
      current_user.queue_items.count + 1
    end

end