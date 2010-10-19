class Publish::CatalogsProductsController < ApplicationController
  before_filter :authenticate_publisher!

  def create
    CatalogsProducts.delete_all(:product_id => params[:product_id])
    params[:catalog_ids].each { |catalog_id| CatalogsProducts.create(:product_id => params[:product_id], :catalog_id => catalog_id) } unless params[:catalog_ids].blank?
    redirect_to publish_publisher_product_path(params[:publisher_id], params[:product_id])
  end
end

