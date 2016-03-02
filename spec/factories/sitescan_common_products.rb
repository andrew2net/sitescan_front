FactoryGirl.define do
  factory :product, :class => 'SitescanCommon::Product' do
    association :categories, factory: :category
    name 'Iphone 6s'
    factory :product_with_categories do
      after(:create) do |product, evaluate|
        create_list :category, 1, products: [product]
      end
    end
  end
end
