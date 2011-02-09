class Admin::WholesalePricesController < AdminController
  private
  def collection
    @wholesale_prices ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || WholesalePrice.per_page
  end
end
