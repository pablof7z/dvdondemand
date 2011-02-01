# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # fee amounts are substractions, so add parenthesis to them
  def fee_number_to_currency(n=0)
    "(#{number_to_currency(n, :precision => 2)})"
  end

  def column_list(list, columns = 3)
    rows = (list.length / columns.to_f).ceil
    columns.times do |column|
      yield column, list[column * rows, rows]
    end        
  end
end
