FactoryGirl.define do
  factory :product, :class => 'SitescanCommon::Product' do
    name 'Iphone 6s'
    path 'iphone_6s'
    after :create do |product|
      class_option = create :attribute_class_option_apple
      option = create :attribute_option, attribute_class_option: class_option
      create :product_attribute, attributable: product, value: option
    end
  end
end
