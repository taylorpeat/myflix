module ApplicationHelper

  def signed_in?
    !!session[:user_id]
  end

  def options_for_video_reviews(rating=nil)
    options_for_select([5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num] }, selected: rating)
  end

end
