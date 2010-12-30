class Admin::FeesController < AdminController

  def destroy
    Fee.find(params[:id]).update_attribute(:deleted_at, Time.now)
    redirect_to admin_fees_url
  end

  private

  def collection
    @fees ||= end_of_association_chain.applicable
  end
end

