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
    if params[:path]
      category = category_by_path
      name = category.name
      breadcrumbs = category.breadcrumbs
      category_children = category.descendants.where depth: (category.depth + 1)
      result = category.catalog(filter_params)
    else
      name = ''
      breadcrumbs = []
      category_children = SitescanCommon::Category.roots
      result = SitescanCommon::Product.catalog_products filter_params
    end

    subcategories = result.aggs['categories_id']['buckets'].map do |c|
      cat = category_children.where(id: c['key']).first
      if cat
        {name: cat.name, path: cat.path, items: c['doc_count']}
      else
        false
      end
    end.select{|c| c}

    # It's need to find min price for each product.
    filtered_search_product_ids = SitescanCommon::ProductAttribute
      .filtered_search_product_ids filter_params

    prods = result.map { |p| p.catalog_hash(filtered_search_product_ids)}
    cat = {
      category: name,
      breadcrumbs: breadcrumbs,
      subcategories: subcategories,
      products: prods
    }
    render json: cat
  end

  def product
    product = SitescanCommon::Product.find_by path: params[:path]
    raise ActiveRecord::RecordNotFound unless product
    render json: product.product_data(filter_params[:p])
  end

  # Render filter options for current category.
  def filter
    if params[:path]
      category = category_by_path
      render json: category.filter
    else
      render json: SitescanCommon::AttributeClass.filter
    end
  end

  # Render constraints for filter attributes.
  def filter_constraints
    if params[:path]
      category = category_by_path
      render json: category.filter_constraints(filter_params)
    else
      render json: SitescanCommon::Category.constraints(filter_params) 
    end
  end

  def link_url
    search_result = SitescanCommon::SearchResult.find params[:id]
    redirect_to search_result.link
  end

  def suggest_products
    search_params = {fields: [:name]}
    category = category_by_path
    if category
      p_ids = SitescanCommon::Product.filtered_ids(
        {}, category.self_and_descendants.ids)
      search_params[:where] = {id: p_ids}
    end
    products = SitescanCommon::Product.search(params[:text], search_params)
      .map do |p|
      p.name
    end
    render json: products
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
    p[:p] = JSON.parse params[:p] if params[:p]
    p[:search] = params[:search] if params[:search]
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
    category = SitescanCommon::Category.find_by path: params[:path]
    raise ActiveRecord::RecordNotFound unless category
    category
  end
end
