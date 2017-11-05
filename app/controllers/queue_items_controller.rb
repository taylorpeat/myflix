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

  private
    
    def new_queue_item(params)
      QueueItem.new({ user: current_user, video_id: params[:video_id], position: new_queue_item_position })
    end

    def new_queue_item_position
      current_user.queue_items.count + 1
    end
end
