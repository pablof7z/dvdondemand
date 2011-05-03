class Retail::HomeController < RetailController
  def index
    @products = Product.featured.select { |product| product.retailable? }
    @latest_products = Product.available_filo.for_retail.last(25)
    @genres_for_cd = Genre.for_cd
    @genres_for_dvd = Genre.for_dvd

    @best_selling = Product.best_selling
  end
end
