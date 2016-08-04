class MainController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

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

  def not_found
    render :index, status: 404
  end

end
