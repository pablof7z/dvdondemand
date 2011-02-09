class Retail::PublishersController < RetailController
  actions :index, :show

  def show
    show! do
      render(:text => 'Forbidden', :status => 403) and return unless @publisher.approved
    end
  end

  protected

  def collection
    # by default, only show approved Publishers
    @publishers ||= end_of_association_chain.approved.paginate :page => params[:page], :per_page => params[:per_page] || Publisher.per_page
  end
end
