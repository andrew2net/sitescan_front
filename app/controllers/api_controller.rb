class ApiController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :data_not_found

  # Render popular categories.
  def categories
    render json: SitescanCommon::Category.popular.map {|category| category.data}
  end

  # Render products in current category.
  def catalog
    unless params[:path].blank?
      category = SitescanCommon::Category.find_by! path: params[:path]
      name = category.name
      description = category.description
      breadcrumbs = category.breadcrumbs
      category_children = category.descendants.where depth: (category.depth + 1)
      result = category.catalog(filter_params)
    else # All products.
      name = nil
      description = nil # If nil ja add default description.
      breadcrumbs = []
      category_children = SitescanCommon::Category.roots
      result = SitescanCommon::Product
        .catalog_products filter_params: filter_params
    end

    subcategories = result.aggs['categories_id']['buckets'].map do |c|
      cat = category_children.where(id: c['key']).first
      if cat
        {name: cat.name, path: cat.path, items: c['doc_count']}
      else
        false
      end
    end.select{|c| c}

    prods = result.map do |p|
      prod = SitescanCommon::Product.find p['_id']
      min_price = p['0'].min
      prod.catalog_hash.merge({ price: min_price })
    end
    cat = {
      category: name,
      description: description,
      breadcrumbs: breadcrumbs,
      subcategories: subcategories,
      products: prods,
      total_items: result.total_count
    }
    render json: cat
  end

  # Render product's page.
  def product
    product = SitescanCommon::Product.find_by! path: params[:path]
    render json: product.product_data(filter_params[:p])
  end

  # Render filter options for current category.
  def filter
    if params[:path]
      category = SitescanCommon::Category.find_by! path: params[:path]
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

  def brands
    @brands = SitescanCommon::Brand.joins :attribute_class_option
    render formats: :json
  end

  def data_not_found
    head :not_found
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
    p[:page] = params[:page]
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
    category
  end
end
