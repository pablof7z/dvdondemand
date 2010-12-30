# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # fee amounts are substractions, so add parenthesis to them
  def fee_number_to_currency(n=0)
    "(#{number_to_currency(n, :precision => 2)})"
  end
end
