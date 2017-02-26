require 'rails_helper'

RSpec.describe 'main/index.html.slim', type: :view do
  context 'when got home page' do
    it 'should display year in the footer' do
      render
      expect(rendered).to have_content '2017'
    end
  end
end
