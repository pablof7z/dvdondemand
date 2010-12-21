class Publish::ProductPlacementsController < PublishController
  before_filter :authenticate_publisher!

  def create
    @product = Product.find(params[:product_id])
    @product.catalog_ids = params[:catalog_ids]

    redirect_to publish_publisher_product_path(current_publisher, params[:product_id])
  end
end

