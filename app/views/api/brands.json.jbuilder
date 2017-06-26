json.array! @brands do |b|
  brand = b[:brand]
  json.logo_url brand.logo.url(:thumb)
  json.opt_id brand.opt_id
  json.name brand.attribute_class_option.value
  json.products b[:products] do |ao|
    product = ao.product_attribute.attributable
    json.(product, :path, :name)
    image = product.product_images.first
    json.image_url image.attachment.url(:medium) if image
    min_price = product.search_products.map { |sp| sp.price }.min
    json.min_price min_price if min_price
  end
end
