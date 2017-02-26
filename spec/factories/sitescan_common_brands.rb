FactoryGirl.define do
  factory :brand_apple, class: SitescanCommon::Brand do
    logo { File.new("#{Rails.root}/spec/support/fixtures/apple.png") }
  end
end
