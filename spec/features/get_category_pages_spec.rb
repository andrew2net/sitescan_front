require 'rails_helper'

RSpec.feature 'Visit category page', type: :feature do
  scenario 'Should show goods of the category' do
    create :product_with_categories
    visit '/catalog'
  end
end
