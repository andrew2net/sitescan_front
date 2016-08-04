class MainController < ApplicationController

  # Render layout.
  def index
  end

  def catalog
    SitescanCommon::Category.find_by! path: params[:category_path]
    render :index
  end

  def product
    SitescanCommon::Product.find_by! path: params[:product_path]
    render :index
  end

  # Render partial view template.
  def view
    render partial: params[:template]
  end
end
