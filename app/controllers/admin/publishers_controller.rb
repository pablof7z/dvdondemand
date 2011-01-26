class Admin::PublishersController < AdminController
  def update
    @publisher = Publisher.find(params[:id])
    
    if params[:publisher][:approved] != @publisher.approved
      if ! @publisher.approved
        params[:publisher][:approval_source] = "Approved by admin #{current_admin.email} on #{DateTime.now}"
      else
        params[:publisher][:approval_source] = "Approval removed by admin #{current_admin.email} on #{DateTime.now}"
      end
    end
    
    super
  end
  
  private

  def collection
    @publishers ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || Publisher.per_page
  end
end
