class Admin::VideosController < ApplicationController
  
  before_action :require_user, :require_admin

  def new
    @video = Video.new
  end

  private

  def require_admin
    redirect_to home_path, notice: "You must be an admin in to access that page." unless current_user && current_user.admin?
  end

end