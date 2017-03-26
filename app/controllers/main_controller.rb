class MainController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # Render layout.
  def index
    @bot = bot?
    respond_to do |format|
      format.html
      format.any { head :ok }
    end
  end

  def catalog
    # if params[:category_path]
    #   SitescanCommon::Category.find_by! path: params[:category_path]
    # end
    render :index
  end

  def product
    # SitescanCommon::Product.find_by! path: params[:product_path]
    render :index
  end

  # Render partial view template.
  def view
    render partial: params[:template]
  end

  def page_not_found
    render :index, status: :not_found
  end

  private
  def bot?
    params.key? :bot
  end
end
