class Publish::ProductsController < PublishController
  belongs_to :publisher do
    belongs_to :catalog, :optional => true
  end

  def new
    new! { @genres = Genre.for_cd }
  end

  def edit
    edit! { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd }
  end
  
  def create
    create! do |success, failure|
      failure.html { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd; render :action => 'new' }
    end
  end
  
  def update
    update! do |success, failure|
      failure.html { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd; render :action => 'edit' }
    end
  end

  def destroy
    current_publisher.products.find(params[:id]).update_attribute(:deleted_at, Time.now)
    redirect_to publish_publisher_products_url(current_publisher)
  end

  protected

  def collection
    @products = if parent_type == :catalog
      # optional catalog set, get only associated products
      current_publisher.catalogs.find(params[:catalog_id]).products.available
    else
      current_publisher.products.available
    end
  end
end

