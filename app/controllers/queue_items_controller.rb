class QueueItemsController < ApplicationController

  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    if create_queue_item.save
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

    def create_queue_item
      QueueItem.new({ user: current_user, video_id: params[:video_id], position: current_user.next_queue_item_position })
    end

    def update_queue_item_attributes
      ActiveRecord::Base.transaction do
        queue_item_params = params[:queue_items]
        queue_item_params.each { |qi| update_individual_queue_item(qi) }
      end
    end

    def update_individual_queue_item(queue_item_attributes)
      queue_item = QueueItem.find(queue_item_attributes["id"])
      if queue_item.user == current_user
        binding.pry
        queue_item.update!({ position: queue_item_attributes["position"], rating: queue_item_attributes["rating"] })
      end
    end

end
