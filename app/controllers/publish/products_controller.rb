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
    create! { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd }
  end
  
  def update
    update! { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd }
  end

  protected

  def collection
    @products = if parent_type == :catalog
      # optional catalog set, get only associated products
      current_publisher.catalogs.find(params[:catalog_id]).products
    else
      current_publisher.products
    end
  end
end

