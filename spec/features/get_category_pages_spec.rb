require 'rails_helper'

RSpec.feature 'Visit category page', js:true, type: :feature do
  scenario 'Should show goods of the category' do
    create :category_with_products
    visit '/'
    expect(page).to have_content 'Electronics'
    find(:xpath, '//a[1]').click
    expect(page).to have_content 'Iphone 6s'
  end
end
