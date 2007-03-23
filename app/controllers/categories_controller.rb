class CategoriesController < ApplicationController
  
  def index
    @categories = Category.find(:all, :order => 'position asc')
  end
        
end
