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
      current_user.update_queue_positions
    else
      flash[:error] = "Queue Item could not be destroyed"
    end

    redirect_to my_queue_path
  end

  def update
    binding.pry
    redirect_to my_queue_path
  end

  private
    
    def new_queue_item(params)
      QueueItem.new({ user: current_user, video_id: params[:video_id], position: new_queue_item_position })
    end

    def new_queue_item_position
      current_user.queue_items.count + 1
    end
end
