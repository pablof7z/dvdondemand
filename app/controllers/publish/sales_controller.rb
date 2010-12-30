class Publish::SalesController < PublishController
  belongs_to :publisher
  actions :index, :show

  def index
    @retail_sales = current_publisher.retail_sales
    @whole_sales  = current_publisher.whole_sales
    @get_stocks   = current_publisher.get_stocks
    @payments     = current_publisher.publisher_payments

    if params[:year].blank?
      # overview multi-year reports
      @years = 2007..2010
    else
      @year = params[:year].to_i
    end

    respond_to do |format|
      format.html { render :action => :overview if @years }
      format.csv do 
        # csv output only available per-year (foobar: only current)
        ary = []
        @year = Time.now.year
        (1..12).each do |month|
          period = DateTime.new(@year, month, 1)
          start  = period.beginning_of_month
          finish = period.end_of_month
          # the tamale
          whole    = @whole_sales.find(:all, :conditions => { :created_at => start..finish }).inject(0)  { |sum,i| sum + i.total } 
          retail   = @retail_sales.find(:all, :conditions => { :created_at => start..finish }).inject(0) { |sum,i| sum + i.total } 
          getstock = @get_stocks.find(:all, :conditions => { :created_at => start..finish }).inject(0)   { |sum,i| sum + i.total } 
          payment  = @payments.find(:all, :conditions => { :created_at => start..finish }).inject(0)     { |sum,i| sum + i.amount } 
          subtotal = whole + retail + getstock
          # build the row
          ary << { 'Month' => month, 'Retail Sales' => retail, 'Royalty Sales' => 0, 'Wholesale Sales' => whole, 'Get Stock Purchases' => getstock, 'Totals' => subtotal, 'PPS Payments' => payment }
        end
        send_data ary.to_csv
      end
    end
  end

  def ledger
    yy = params[:year]  || Time.now.year
    mm = params[:month] || Time.now.month
    dd = DateTime.new(yy.to_i, mm.to_i, 1)
    start  = dd.beginning_of_month
    finish = dd.end_of_month
    @sales = current_publisher.send(params[:type] || 'retail_sales').find(:all, :conditions => {:created_at => start..finish})
    @group = @sales.group_by { |s| s.created_at.beginning_of_month }
  end
end

