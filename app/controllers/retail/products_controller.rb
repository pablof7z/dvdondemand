class Retail::ProductsController < Retail::RetailController
  belongs_to :catalog, :optional => true
  actions :show

  def show
    show! do
      render(:text => 'Forbidden', :status => 403) and return if @catalog.private
    end
  end
end

