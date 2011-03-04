class Retail::CatalogsController < RetailController
  actions :index, :show
  respond_to :html, :xml, :rss

  def index
    index! do |format|
      format.html do
        @products = Product.available.for_retail.first(5)
      end
      format.xml do
        render :xml => @catalogs.to_xml(:except => [:private, :password, :publisher_id, :updated_at], :include => { :publisher => {:except => [:id, :email, :approved, :created_at, :updated_at]} })
      end
    end
  end
  
  def show_private
  end

  def show
    show! do |format|
      password = params[:password] || session[:password]
      render :action => :show_private and return if @catalog.private and @catalog.password != password
      
      if params[:password] != nil
        session[:password] = params[:password]
      end

      format.html do
        @products = @catalog.products.available.for_retail.paginate :page => params[:page], :per_page => params[:per_page] || Product.per_page
      end
      format.xml do
        render :xml => @catalog.to_xml(:except => [:private, :password, :publisher_id, :updated_at], :include => { :publisher => {:except => [:id, :email, :approved, :created_at, :updated_at]}, :products => {:except => [:catalog_id, :publisher_id, :cover_file_size, :cover_updated_at]} })
      end
    end
  end

  private

  def collection
    @catalogs = Catalog.all
  end
end
