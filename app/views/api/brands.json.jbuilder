json.array! @brands do |brand|
  json.logo_url brand.logo.url(:thumb)
  json.opt_id brand.attribute_class_option_id
end