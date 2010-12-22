class Publish::SalesController < PublishController
  belongs_to :publisher
  actions :index, :show

  def index
    @retail_sales = current_publisher.retail_sales
    @whole_sales  = current_publisher.whole_sales
    index!
  end

  def ledger
    yy = params[:year]  || Time.now.year
    mm = params[:month] || Time.now.month
    dd = Date.new(yy.to_i, mm.to_i, 1)
    start  = dd.beginning_of_month
    finish = dd.end_of_month
    @sales = current_publisher.send(params[:type] || 'retail_sales').find(:all, :conditions => {:created_at => start..finish})
    @group = @sales.group_by { |s| s.created_at.beginning_of_month }
  end
end

