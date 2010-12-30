class Retail::GenresController < RetailController
  actions :index, :show
  respond_to :html, :xml, :rss

  def index
    index! do |format|
      format.html do
        @products = Product.all(:order => :updated_at, :limit => 5).map do |p|
          p if p.available_for_retail_listing?
        end.compact
      end
      format.xml do
        render :xml => @catalogs.to_xml(:except => [:private, :password, :publisher_id, :updated_at], :include => { :publisher => {:except => [:id, :email, :approved, :created_at, :updated_at]} })
      end
    end
  end
end

