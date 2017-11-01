class CategoriesController < ApplicationController

  def show
    @category = Category.find(params['id'])
    @videos = Video.search_by_category(params['id'])
  end

end