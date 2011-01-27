class Admin::ShippingOptionsController < AdminController
  private
  def collection
    @shipping_options ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || ShippingOption.per_page
  end
end
