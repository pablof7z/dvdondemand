class Admin::GenresController < AdminController
  private
  def collection
    @genres ||= end_of_association_chain.paginate :page => params[:page], :per_page => params[:per_page] || Genre.per_page
  end
end
