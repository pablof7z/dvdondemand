class Publish::SalesController < PublishController
  belongs_to :publisher
  actions :index, :show

  def index
    @retail_sales = current_publisher.retail_sales
    @whole_sales  = current_publisher.whole_sales
    @get_stocks   = current_publisher.get_stocks
    @payments     = current_publisher.payments

    if params[:year].blank?
      @years =
        (current_publisher.sales + current_publisher.payments).map do |x|
          x.created_at.year
        end.uniq.sort
    else
      @year = params[:year].to_i
    end

    respond_to do |format|
      format.html
      format.csv { @fillename = 'sales.csv' }
    end
  end

  def ledger
    @type  = params[:type] || 'retail_sales'
    @year  = params[:year].blank?  ? Time.now.year  : params[:year].to_i
    @month = params[:month].blank? ? Time.now.month : params[:month].to_i

    date   = DateTime.new(@year, @month, 1)
    start  = date.beginning_of_month
    finish = date.end_of_month

    @sales   = current_publisher.send(@type).find(:all, :conditions => {:created_at => start..finish})
    @grouped = @sales.group_by { |s| s.created_at.beginning_of_month }

    respond_to do |format|
      format.html
      format.csv { @filename = 'ledger.csv' }
    end
  end
end
