FactoryGirl.define do
  factory :category, class: 'SitescanCommon::Category' do
    name 'Electronics'
    path 'electronics'
    show_on_main true
    factory :category_with_products do
      after(:create) do |cat, evaluate|
        create_list(:product, 1, categories: [cat])
      end
    end
  end
end
