class Publish::SalesController < PublishController
  belongs_to :publisher
  actions :index, :show

  def index
    @retail_sales = current_publisher.retail_sales
    @whole_sales  = current_publisher.whole_sales
    @get_stocks   = current_publisher.get_stocks
    @payments     = current_publisher.publisher_payments

    if params[:year].blank?
      @years = 2007..2010   # overview multi-year reports
    else
      @year = params[:year].to_i
    end

    respond_to do |format|
      format.html do
        render :action => :overview if @years
      end

      format.csv do 
        arry = []
        if @years
          @years.each do |year|
            period = DateTime.new(year, 1, 1)
            start  = period.beginning_of_year
            finish = period.end_of_year
            arry << csv_row(start,finish) { ['Year', start.strftime('%Y')] }
          end
          send_data(arry.to_csv, :filename => "sales.csv")
        else
          (1..12).each do |month|
            period = DateTime.new(@year, month, 1)
            start  = period.beginning_of_month
            finish = period.end_of_month
            arry << csv_row(start,finish) { ['Month', start.strftime('%b %Y')] }
          end
          send_data(arry.to_csv, :filename => "sales_#{@year}.csv")
        end
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

  private

  def csv_row(start,finish)
    whole    = @whole_sales.totals_for(start,finish)
    retail   = @retail_sales.totals_for(start,finish)
    getstock = @get_stocks.totals_for(start,finish)
    payment  = @payments.totals_for(start,finish)
    subtotal = whole + retail + getstock
    [ 
      yield, 
      ['Retail Sales', retail],
      ['Royalty Sales', 0],
      ['Wholesale Sales', whole],
      ['Get Stock Purchases', getstock],
      ['Totals', subtotal],
      ['PPS Payments', payment] 
    ]
  end
end

