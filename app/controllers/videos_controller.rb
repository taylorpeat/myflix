class VideosController < ApplicationController
  
  before_filter :require_user

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
    @video = Video.find(params['id'])
    @reviews = @video.reviews
  end

  def search
    @videos = Video.search_by_title(params['query'])
    @search_term = params['query']
  end
end