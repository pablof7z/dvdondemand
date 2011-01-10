class Admin::AffiliatesController < AdminController
  def update
    @affiliate = Affiliate.find(params[:id])
    
    if params[:affiliate][:approved] != @affiliate.approved
      if ! @affiliate.approved
        params[:affiliate][:approval_source] = "Approved by admin #{current_admin.email} on #{DateTime.now}"
      else
        params[:affiliate][:approval_source] = "Approval removed by admin #{current_admin.email} on #{DateTime.now}"
      end
    end
    
    super
    
  end
end

