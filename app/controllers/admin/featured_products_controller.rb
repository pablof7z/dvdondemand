class Admin::FeaturedProductsController < AdminController
  defaults :resource_class => Product

  def create
    collection.update_all(:featured => nil)

    featured = params[:featured].split(' ')
    featured.each_with_index do |featured, index|
      begin
        product = Product.find(featured)
        product.featured = index + 1
        product.save!
      rescue ActiveRecord::ActiveRecordError => e
        flash[:alert] = "Error updating featured products list: #{e}"
        collection.update_all(:featured => nil)
        break
      end

    end

    flash[:notice] = 'Featured products list updated' unless flash[:alert]
    redirect_to admin_featured_products_path
  end

  private

  def collection
    @products ||= Product.featured
  end
end
