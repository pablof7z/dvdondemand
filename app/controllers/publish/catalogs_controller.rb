class Publish::CatalogsController < PublishController
  belongs_to :publisher
  
  def show
    show! { @products = @catalog.products.available.paginate :page => params[:page], :per_page => params[:per_page] || Product.per_page }
  end

  def create
    create! do |success, failure|
      success.html { redirect_to publish_publisher_catalogs_path(current_publisher) }
    end
  end
end
