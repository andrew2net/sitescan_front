class Category < SitescanCommon::Category
  scope :popular, ->{ where(show_on_main: true).order(:lft) }
end