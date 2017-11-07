class QueueItemsController < ApplicationController

  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    if new_queue_item(params).save
      redirect_to my_queue_path
    else
      flash[:error] = "New queue item could not be created."
      redirect_to my_queue_path
    end
  end

  def destroy
    queue_item = QueueItem.find(params[:id])

    if current_user.id == queue_item.user_id
      flash[:notice] = "#{queue_item.video_title} has been removed from the queue."
      queue_item.destroy
      current_user.normalize_queue_positions
    else
      flash[:error] = "Queue Item could not be destroyed"
    end

    redirect_to my_queue_path
  end

  def update
    begin
      update_queue_item_attributes
      current_user.normalize_queue_positions
    rescue
      flash[:error] = "The position could not be updated."
    end

    redirect_to my_queue_path
  end

  private
    
    def new_queue_item(params)
      QueueItem.new({ user: current_user, video_id: params[:video_id], position: new_queue_item_position })
    end

    def new_queue_item_position
      current_user.queue_items.count + 1
    end

    def update_queue_item_attributes
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
end
