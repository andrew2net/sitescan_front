require 'rails_helper'

RSpec.describe SitescanCommon::Category, type: :model do
  it "should create category" do
    create :category
    c = SitescanCommon::Category.first
    expect(c.name).to eq 'Electronics'
  end
end
