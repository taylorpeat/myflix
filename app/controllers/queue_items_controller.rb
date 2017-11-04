class QueueItemsController < ApplicationController

  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    queue_item = QueueItem.new({ user: current_user, video_id: params[:video_id] })
    if queue_item.save
      redirect_to my_queue_path
    else
      flash[:error] = "New queue item could not be created."
      redirect_to my_queue_path
    end
  end
end
