class Publish::GetStocksController < PublishController
  belongs_to :publisher
  actions :index
  
  def index
    @order = current_publisher.get_orders.build
    current_publisher.products.available.each do |p|
      @order.items.build(:product => p, :packaging_option => nil, :quantity => 0)
    end
  end
end
