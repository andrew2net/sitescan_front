if Rails.env == 'production'
  ENV["ELASTICSEARCH_URL"] = 'https://search-sitscan-ynmjt45m5vkegr2tyw55jgyj74.us-east-1.es.amazonaws.com'
end
