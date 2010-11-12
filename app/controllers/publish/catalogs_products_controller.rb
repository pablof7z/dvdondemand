class Publish::CatalogsProductsController < ApplicationController
  before_filter :authenticate_publisher!

  def create
    CatalogsProducts.delete_all(:product_id => params[:product_id])
    unless params[:catalog_ids].blank?
      for catalog_id in params[:catalog_ids]
        CatalogsProducts.create(:product_id => params[:product_id], :catalog_id => catalog_id)
      end
    end
    redirect_to publish_publisher_product_path(current_publisher, params[:product_id])
  end
end

