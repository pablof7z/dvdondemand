class Sale < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :order
  has_many :publisher_payments

  default_scope :order => 'created_at'

  def fees
    total = 0
    Fee.all.each do |fee|
      # apply each (fixed amount) Fee by each product's sale quantity
      total += order.items_from(publisher).inject(0) { |sum,i| sum + i.quantity*fee.amount }
    end
    total
  end
end

