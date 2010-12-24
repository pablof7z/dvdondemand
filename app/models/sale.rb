class Sale < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :order
  belongs_to :wholesaler_invoice
  belongs_to :publisher_payment

  default_scope :order => 'created_at'

  def self.totals
    sum(:total).round(2)
  end

  def fees
    Fee.all.inject(0) { |sum,f| sum += collect_fees_for(f) }
  end

  def collect_fees_for(fee)
    # apply given Fee to each product's sale (considering quantity). Round 2 decimals for percentage's sake
    order.items_from(publisher).inject(0) { |sum,i| sum + i.quantity * (fee.percentage ? fee.amount*i.price : fee.amount) }.round(2)
  end

  def pending_payment
    publisher_payment.blank?
  end
end

