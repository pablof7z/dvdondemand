class Publish::ProductsController < Publish::PublishController
  belongs_to :publisher do
    belongs_to :catalog, :optional => true
  end

  protected

  def collection
    @products = current_publisher.products
  end
end

