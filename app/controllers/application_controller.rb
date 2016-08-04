class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from ActionController::RoutingError, with: :page_not_found
  rescue_from ActionController::UnknownController, with: :page_not_found

  private

  def page_not_found
    render 'main/index', status: :not_found
  end
end
