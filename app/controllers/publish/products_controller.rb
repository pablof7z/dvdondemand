class Publish::ProductsController < Publish::PublishController
  belongs_to :publisher do
    belongs_to :catalog, :optional => true
  end
  respond_to :html, :json

  def new
    new! { @genres = Genre.for_cd }
  end

  def create
    @product = Product.new(params[:product])
    @product.iso_content_type = MIME::Types.type_for(@product.iso_file_name).to_s
    create! do |success, failure|
      success.html { redirect_to(@product) }
      success.json { render :json => { :result => 'success', :product => publish_product_path(@product) } }
    end
  end

  def edit
    edit! { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd }
  end

  protected

  def collection
    @products = if parent_type == :catalog
      # optional catalog set, get only associated products
      current_publisher.catalogs.find(:first, :conditions => {:id => params[:catalog_id]}).products
    else
      current_publisher.products
    end
  end
end

