class Publish::GetStocksController < PublishController
  belongs_to :publisher
  actions :index
  
  def index
    @products = current_publisher.products
  end
end
