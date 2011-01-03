module Publish::SalesHelper
  def current_or_not(action=nil)
    if block_given?
      {:class => 'current'} if yield
    else
      {:class => 'current'} if controller.action_name == action
    end
  end
end
