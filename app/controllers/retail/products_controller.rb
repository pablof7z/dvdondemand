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
end

