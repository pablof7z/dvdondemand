class Admin::WholesalersController < AdminController
  private
  def collection
    @wholesalers ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || Wholesaler.per_page
  end
end
