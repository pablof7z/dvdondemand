class Retail::HomeController < RetailController
  def index
    @products = Product.random
    @catalogs = Catalog.random
    @genres_for_cd = Genre.for_cd
    @genres_for_dvd = Genre.for_dvd

    @best_selling = Product.best_selling
  end
end
