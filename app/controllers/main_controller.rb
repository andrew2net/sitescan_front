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
    category = category_by_path
    render json: category.catalog(filter_params)
  end

  # Render filter options for current category.
  def filter
    category = category_by_path
    render json: category.filter
  end

  # Render constraints for filter attributes.
  def filter_constraints
    category = category_by_path
    render json: category.filter_constraints(filter_params)
  end

  private

  # Return hash of filter params.
  def filter_params
    p ={}
    params.permit :n, :r, :o, :b, :s
    if params[:n]
      p[:n] = symbolize JSON.parse params[:n]
    end
    p[:o] = params[:o].split(',').map{|e| e.to_i} if params[:o]
    p[:b] = params[:b].split(',').map{|e| e.to_i} if params[:b]
    p
  end

  # Convert attribute keys to integer and keys of values to symbol.
  def symbolize(obj)
    obj.reduce({}) do |memo, (key, val)|
      memo.tap do |m|
      m[key.to_i] = val.reduce({}){|hash, (k, v)| hash.tap{|h| h[k.to_sym] = v}}
    end
    end
  end

  # Find category by path.
  def category_by_path
    SitescanCommon::Category.find_by path: params[:path]
  end
end
