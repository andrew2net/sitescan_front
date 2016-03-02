require 'rails_helper'

RSpec.feature 'Visit main page', js: true do
  scenario 'should show popular categories' do
    create :category
    visit '/'
    expect(page).to have_content 'Electronics'
  end
end
