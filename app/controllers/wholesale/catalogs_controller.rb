class Wholesale::CatalogsController < WholesaleController
  before_filter :authenticate_wholesaler!, :except => [ :index ]
  
  def index
    case params[:type]
    when 'catalogs'
      @catalogs = Catalog.all.map { |c| c if c.has_a_product_available_for_retail_listing }.compact
      
      respond_to do |format|
        format.xml { send_data @catalogs.to_xml(:include => :products), :filename => "catalog.xml" }
        format.html
      end
    when 'packaging_options'
      @packaging_options = PackagingOption.all
      
      respond_to do |format|
        format.xml { send_data @packaging_options.to_xml, :filename => "packaging_options.xml" }
        format.html
      end
    when 'shipping_options'
      @shipping_options = ShippingOption.all
      
      respond_to do |format|
        format.xml { send_data @shipping_options.to_xml, :filename => "shipping_options.xml" }
        format.html
      end
    end
  end
end
