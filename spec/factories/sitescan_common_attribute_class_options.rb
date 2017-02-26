FactoryGirl.define do
  factory :attribute_class_option_apple,
    class: SitescanCommon::AttributeClassOption do
    value 'Apple'
    after :create do |option|
      create :brand_apple, attribute_class_option: option
    end
    association :attribute_class, factory: :attribute_class_brand
  end
end
