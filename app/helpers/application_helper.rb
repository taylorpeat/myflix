module ApplicationHelper

  def signed_in?
    !!session[:user_id]
  end

end
