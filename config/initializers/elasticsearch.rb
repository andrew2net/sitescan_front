if Rails.env == 'production'
  ENV["ELASTICSEARCH_URL"] = 'https://search-sitescan-jk6agkeej2sappoj3ebd4dlhxe.us-east-1.es.amazonaws.com'
end
