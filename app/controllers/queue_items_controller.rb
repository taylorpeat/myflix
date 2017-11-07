class QueueItemsController < ApplicationController

  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    if QueueItem.create_queue_item_from_params(params, current_user).save
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
      QueueItem.update_attributes_from_params(params, current_user)
      current_user.normalize_queue_positions
    rescue
      flash[:error] = "The position could not be updated."
    end

    redirect_to my_queue_path
  end
end
