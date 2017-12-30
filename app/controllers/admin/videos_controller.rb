class Admin::VideosController < ApplicationController
  
  before_action :require_user, :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Your video, #{@video.title.titleize}, was successfully created."
      redirect_to new_admin_video_path
    else
      flash[:error] = "The video could not be created."
      render :new
    end
  end

  private

  def require_admin
    redirect_to home_path, notice: "You must be an admin in to access that page." unless current_user && current_user.admin?
  end

  def video_params
    params.require(:video).permit(:title, :description, :category_id)
  end
end