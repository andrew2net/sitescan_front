class MainController < ApplicationController

  # Render layout.
  def index
  end

  # Render partial view template.
  def view
    render partial: params[:template]
  end

  # Render popular categories.
  def categories
    render json: SitescanCommon::Category.popular.map {|category| category.data}
  end

  # Render products in current category.
  def catalog
    category = SitescanCommon::Category.find_by path: params[:path]
    render json: category.catalog(filter_params)
  end

  # Render filter options for current category.
  def filter
    category = SitescanCommon::Category.find_by path: params[:path]
    render json: category.filter
  end

  private
  def filter_params
    params.permit :v, :r, :o, :b, :s
  end
end
