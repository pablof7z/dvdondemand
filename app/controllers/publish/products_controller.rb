class Publish::ProductsController < PublishController
  belongs_to :publisher do
    belongs_to :catalog, :optional => true
  end

  skip_before_filter :verify_authenticity_token, :only => [ :iso, :audio_files ]

  def new
    new! { @genres = Genre.for_dvd }
  end

  def edit
    edit! { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd }
  end
  
  def create
    create! do |success, failure|
      failure.html { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd; render :action => 'new' }
      success.html do
        @product.catalogs << current_publisher.catalogs.first
        @product.save!
        redirect_to publish_publisher_product_path(current_publisher, @product)
      end
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to publish_publisher_product_path(current_publisher, @product) }
      failure.html { @genres = @product.cd? ? Genre.for_cd : Genre.for_dvd; render :action => 'edit' }
    end
  end

  def destroy
    current_publisher.products.find(params[:id]).update_attribute(:deleted_at, Time.now)
    redirect_to publish_publisher_products_url(current_publisher)
  end
  
  def iso
    @product = Product.find(params[:id])
    if @product.update_attributes(:iso => params[:File0], :iso_chunk => params[:jupart], :iso_eof => params[:jufinal])
      render :text => 'SUCCESS'
    else
      render :text => 'ERROR: '
    end
  end
  
  def remove_iso
    @product = Product.find(params[:id])
    @product.iso.destroy
    if @product.save
      flash[:notice] = "The ISO file was removed"
    end

    redirect_to publish_publisher_product_path(current_publisher, @product)
  end

  def audio_files
    @product = Product.find(params[:id])
    if @product.update_attributes(:audio_files => params[:File0], :audio_files_chunk => params[:jupart], :audio_files_eof => params[:jufinal])
      render :text => 'SUCCESS'
    else
      render :text => 'ERROR: '
    end
  end

  def remove_audio_files
    @product = Product.find(params[:id])
    @product.audio_files.destroy
    if @product.save
      flash[:notice] = "Audio files deleted"
    end

    redirect_to publish_publisher_product_path(current_publisher, @product)
  end

  def email
    @product = Product.find(params[:id])
    
    if request.post?
      begin
        PublisherMailing.deliver_email_about_product(params[:email].gsub(/ /, ','), @product)
        flash[:notice] = "Email recipients notified"
      rescue
        flash[:warning] = "#{$!}"
      end
      redirect_to publish_publisher_products_path(current_publisher)
    end
  end
  
  private

  def begin_of_association_chain
    current_publisher.catalogs.find(params[:catalog_id]) if params[:catalog_id]
  end

  def collection
    @products ||= end_of_association_chain.available.paginate :page => params[:page], :per_page => params[:per_page] || Product.per_page
  end
end
