class Retail::ProductsController < RetailController
  belongs_to :catalog
  actions :show
  
  def show_private
  end

  def show
    show! do
      render(:text => 'Forbidden', :status => 403) and return if (!@product.available?)
      
      password = params[:password] || session[:password]
      render :action => :show_private and return if @catalog.private and @catalog.password != password
      
      if params[:password] != nil
        session[:password] = params[:password]
      end
    end
  rescue ActiveRecord::RecordNotFound
    # also raised when accessing a Product with incorrect Catalog association
    render(:text => 'Not Found', :status => 404)
  end

  def flag
    resource.flag_count = (resource.flag_count.nil?)? 1 : resource.flag_count += 1
    if resource.save
      flash[:notice] = 'The product has been flagged'
    else
      flash[:alert] = 'Error flagging the product'
    end
    redirect_to retail_catalog_product_path(resource.catalogs.first, resource)
  end

end

