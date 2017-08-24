class VideosController < ApplicationController
  
  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
    @video = Video.find(params['id'])
  end

  def search
    @videos = Video.search_by_title(params['query'])
  end
end