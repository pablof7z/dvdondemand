class Retail::ProductsController < RetailController
  belongs_to :catalog
  actions :show

  def show
    show! do
      render(:text => 'Forbidden', :status => 403) and return if (@catalog.private || !@product.available?)
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

