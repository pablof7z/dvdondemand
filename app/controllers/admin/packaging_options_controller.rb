class Admin::PackagingOptionsController < AdminController
  def update
    update!(:notice => "Packaging option updated") { admin_packaging_options_path }
  end
  
  private
  def collection
    @packaging_options ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || PackagingOption.per_page
  end
end
