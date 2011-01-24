class Admin::OrdersController < AdminController
  actions :index, :show

  private

  def collection
    @orders ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || Order.per_page
  end
end
