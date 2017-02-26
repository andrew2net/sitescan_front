FactoryGirl.define do
  factory :attribute_class_brand, class: SitescanCommon::AttributeClass do
    name 'Brand'
    depend_image false
    depend_link false
    searchable true
    show_in_catalog true
    type_id SitescanCommon::AttributeClass::TYPE_OPTION
    widget_id SitescanCommon::AttributeClass::WIDGET_BRAND
    attribute_class_group
    # after :create do |attribute_class|
    #   create :attribute_class_option_apple, attribute_class: attribute_class
    # end
  end
end
