class Sale < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :order
  belongs_to :wholesaler_invoice
  has_many :publisher_payments

  default_scope :order => 'created_at'

  def fees
    Fee.all.inject(0) { |sum,f| sum += fees_for(f) }
  end

  def fees_for(fee)
    # apply given Fee to each product's sale (considering quantity)
    order.items_from(publisher).inject(0) { |sum,i| sum + i.quantity * (fee.percentage ? fee.amount*i.price : fee.amount) }
  end
end

