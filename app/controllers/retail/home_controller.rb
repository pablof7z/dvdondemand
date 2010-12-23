class Retail::HomeController < RetailController
  def index
    @products = Product.all(:order => :updated_at, :limit => 50).map { |p| p if p.available_for_retail_listing? }.compact
    @catalogs = Catalog.public.all(:order => :updated_at, :limit => 50).map { |c| c if c.available_for_retail_listing }.compact
  end
  
  def search
    @products = Product.search(params[:id]).map do |product|
      product if product.available_for_retail_listing?
    end.compact
  end
end
