class Admin::FlaggedProductsController < AdminController
  defaults :resource_class => Product
  actions :index, :delete

  def destroy
    resource.flag_count = nil
    if resource.save
      flash[:notice] = 'Product unflagged'
    else
      flash[:error] = 'Error unflagging product'
    end
    redirect_to admin_flagged_products_path
  end

  private

  def collection
    @products ||= end_of_association_chain.flagged.paginate :page => params[:page], :per_page => params[:per_page] || Product.per_page
  end
end
