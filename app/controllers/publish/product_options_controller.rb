class Publish::ProductOptionsController < PublishController
  before_filter :authenticate_publisher!

  def create
    @product = Product.find(params[:product_id])
    @product.packaging_option_ids = params[:packaging_option_ids]

    redirect_to publish_publisher_product_path(current_publisher, params[:product_id])
  end
end

