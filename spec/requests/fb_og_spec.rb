require 'rails_helper'

RSpec.describe 'Read FB Open Graph markers', type: :request do
  it 'read FB OG on home page' do
    # page.driver.add_headers 'User-Agent' => 'facebookexternalhit'
    Rails.cache.clear
    get 'http://localhost:3001/', nil,
      { 'HTTP_USER_AGENT' => 'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)' }
    # require 'pry'; binding.pry
    expect(response.body).to include 'All rights reserved'
    doc = Nokogiri::HTML response.body
    expect(doc.xpath('//meta[@property="og:type"]').size).to eq 1
    # expect(response).to have_xpath '//meta[@property="og:type"]'
  end
end

