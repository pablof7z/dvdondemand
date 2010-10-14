class Retail::CatalogsController < Retail::RetailController
  actions :index, :show
  respond_to :html, :xml, :rss

  def index
    index! do |format|
      format.html do
        @products = Product.all(:order => :updated_at, :limit => 5)
      end
      format.xml do
        render :xml => @catalogs.to_xml(:except => [:private, :password, :publisher_id, :updated_at], :include => { :publisher => {:except => [:id, :email, :approved, :created_at, :updated_at]} })
      end
    end
  end

  def show
    show! do |format|
      render(:text => 'Forbidden', :status => 403) and return if @catalog.private

      format.xml do
        render :xml => @catalog.to_xml(:except => [:private, :password, :publisher_id, :updated_at], :include => { :publisher => {:except => [:id, :email, :approved, :created_at, :updated_at]}, :products => {:except => [:catalog_id, :publisher_id, :cover_file_size, :cover_updated_at]} })
      end
    end
  end

  protected

  def collection
    # by default, only show non-private (public) Catalogs
    @catalogs = Catalog.public
  end
end

