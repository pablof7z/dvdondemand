class Retail::HomeController < RetailController
  def index
    @products = Product.all(:order => :updated_at, :limit => 50).map do |p|
      p if p.available_for_retail_listing?
    end.compact

    @catalogs = Catalog.public.all(:order => :updated_at, :limit => 50).map do |c|
      c if c.available_for_retail_listing?
    end.compact

    @genres_for_cd = Genre.for_cd
    @genres_for_dvd = Genre.for_dvd

    @best_selling = @products.take(5)
  end
  
  def search
    @products = Product.search(params[:id]).map do |product|
      product if product.available_for_retail_listing?
    end.compact
  end
end
