class Publish::GetStocksController < PublishController
  belongs_to :publisher
  actions :index, :create, :show
  
  def index
    @order = current_publisher.get_orders.build
    current_publisher.products.available.each do |p|
      @order.items.build(:product => p, :price => p.price, :packaging_option => nil, :quantity => 0)
    end
  end

  def create
    @order = Order.new(params[:order])
    if @order.save and @order.purchase
        get_stock = @order.to_get_stock 
        flash[:notice] = 'Your GetStock has been successfully processed.'
        redirect_to receipt_publish_publisher_get_stock_path(current_publisher, get_stock)
    else
      flash[:alert] = 'Error while processing your GetStock.'
      redirect_to publish_publisher_get_stocks_url
    end
  end

  def receipt
    @order = resource.order
    @order.first_name = resource.publisher.first_name
    @order.last_name = resource.publisher.last_name
    render :partial => 'receipt', :layout => 'receipt' if params[:printable] == 'true'
  end

end
