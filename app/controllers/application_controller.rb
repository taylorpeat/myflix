class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_user
    redirect_to sign_in_path unless current_user
  end
end
