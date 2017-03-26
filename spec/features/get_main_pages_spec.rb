require 'rails_helper'

RSpec.feature 'Visit main page', js: true do
  scenario 'should show brands' do
    create :category_with_products
    visit '/'
    expect(page).to have_xpath '//a[@title="Apple"]'
    apple_link = find(:xpath, '//a[@title="Apple"]')
    # require 'pry'; binding.pry
    apple_link.click
    # find(:xpath, '//*[contains(@class, "catalog-product")]')
    # save_and_open_screenshot
    # expect(page).to have_content 'Iphone 6s'
  end
end
