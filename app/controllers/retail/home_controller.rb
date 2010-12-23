class Retail::HomeController < RetailController
  def index
    @products = Product.all(:order => :updated_at, :limit => 50).map { |p| p if p.available_for_retail_listing? }.compact
    @catalogs = Catalog.public.all(:order => :updated_at, :limit => 50).map { |c| c if c.available_for_retail_listing }.compact
    @genres_for_cd = Genre.for_cd
    @genres_for_dvd = Genre.for_dvd
  end
end
