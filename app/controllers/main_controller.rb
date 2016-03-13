class MainController < ApplicationController
  def index
  end

  def categories
    render json: SitescanCommon::Category.popular.map {|category| category.data}
  end

  def view
    render partial: params[:template]
  end

  def catalog
    category = SitescanCommon::Category.find_by path: params[:path]
    render json: category.catalog
  end
end
