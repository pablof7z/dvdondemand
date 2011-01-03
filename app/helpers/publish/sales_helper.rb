module Publish::SalesHelper
  def saleize(sale)
    # this is foobar, it should be extracted from publisher's has_many assoc. names if they were named correctly for starts
    case sale
      when Wholesale: 'whole_sales'
      when GetStock: 'get_stocks'
      when Retail: 'retail_sales'
    end
  end

  def current_or_not(action=nil)
    if block_given?
      {:class => 'current'} if yield
    else
      {:class => 'current'} if controller.action_name == action
    end
  end
end
