class Wholesale::CatalogsController < WholesaleController
  before_filter :authenticate_wholesaler!, :except => [ :index ]
  
  def index
    @catalogs = Catalog.all
    
    respond_to do |format|
      format.xml { send_data @catalogs.to_xml, :filename => "complete_catalog.xml" }
      format.html
    end
  end
end
