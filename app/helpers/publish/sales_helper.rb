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

  def buttonize(path, text='Submit', method=:get)
    if path
      form_tag path, :method => method do
        content_tag :p, :class => 'btso', :align => 'center' do
          content_tag :button, :class => 'b1', :type => 'submit' do
            text
          end
        end
      end
    end
  end
end
