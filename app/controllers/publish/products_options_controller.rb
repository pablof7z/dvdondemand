class Publish::ProductsOptionsController < ApplicationController
  before_filter :authenticate_publisher!

  def create
    ProductOption.delete_all(:product_id => params[:product_id])
    unless params[:packaging_option_ids].blank?
      for packaging_option_id in params[:packaging_option_ids]
        ProductOption.create(:product_id => params[:product_id], :packaging_option_id => packaging_option_id)
      end
    end
    redirect_to publish_publisher_product_path(current_publisher, params[:product_id])
  end
end

