class MainController < ApplicationController
  def index
  end

  def categories
    render json: Category.popular.map {|category| { name: category.name,img_src: category.image.url(:thumb)}}
  end

  def main
    render partial: 'main'
  end
end
