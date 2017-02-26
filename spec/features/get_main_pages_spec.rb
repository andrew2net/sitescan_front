require 'rails_helper'

RSpec.feature 'Visit main page', js: true do
  scenario 'should show popular categories' do
    create :category_with_products
    visit '/'
    expect(page).to have_xpath '//a[@title="Apple"]'
    find(:xpath, '//a[@title="Apple"]').click
    expect(page).to have_content 'Iphone 6s'
  end
end
