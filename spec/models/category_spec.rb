require 'rails_helper'

RSpec.describe Category, type: :model do
  it "should create category" do
    create :category
    c = Category.first
    expect(c.name).to eq 'Electronics'
  end
end
