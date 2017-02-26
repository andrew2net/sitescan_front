require 'rails_helper'

RSpec.describe MainController, type: :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #view' do
    it 'should return success' do
      get :view, template: 'main'
      expect(response).to have_http_status :success
    end
  end

  describe 'GET #catalog' do
    it 'should return products in category' do
      create :category_with_products
      get :catalog, path: 'electronics'
      expect(response).to have_http_status :success
    end
  end
end
