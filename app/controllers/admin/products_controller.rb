class Admin::ProductsController < AdminController
  def enable
    @product = Product.find_by_id(params[:id])
    @product.deleted_at = nil
    if @product.save
      flash[:notice] = "Product is now available"
      redirect_to admin_products_path
    end
  end
  
  def disable
    @product = Product.find_by_id(params[:id])
    @product.destroy
    if @product.save
      flash[:notice] = "Product was deleted"
      redirect_to admin_products_path
    end
  end
  
  def collection
    @products ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || Product.per_page
  end
end
