class Publish::ProductsController < Publish::PublishController
  belongs_to :publisher do
    belongs_to :catalog, :optional => true
  end

  protected

  def collection
    # some badly needed refactoring here
    @products = params[:catalog_id].blank? ? current_publisher.products : current_publisher.catalogs.find(:first, :conditions => {:id => params[:catalog_id]}).products
  end
end

