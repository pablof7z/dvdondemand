class Publish::GetStocksController < PublishController
  belongs_to :publisher
  actions :index, :create
  
  def index
    @order = current_publisher.get_orders.build
    current_publisher.products.available.each do |p|
      @order.items.build(:product => p, :packaging_option => nil, :quantity => 0)
    end
  end

  def create
    @order = Order.new(params[:order])
    if @order.save
      if @order.purchase
        @order.to_get_stock 
        flash[:notice] = 'Your GetStock has been successfully processed.'
      end
    else
      flash[:notice] = 'Error while processing your GetStock.'
    end
    redirect_to publish_publisher_get_stocks_url
  end
end
