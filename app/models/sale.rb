class Sale < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :order
  belongs_to :wholesaler_invoice
  belongs_to :publisher_payment
  has_many :fee_versions

  named_scope :pending_payment, :conditions => { :publisher_payment_id => nil }
  default_scope :order => 'created_at'

  def self.totals
    sum(:total).round(2)
  end

  def fees
    fee_versions.all.inject(0) do |sum,f| 
      f.fee.revert_to!(f.number)
      sum += collect_fees_for(f.fee)
    end
  end

  def collect_fees_for(fee)
    # apply given Fee to each product's sale (considering quantity). Round 2 decimals for percentage's sake
    order.items_from(publisher).inject(0) { |sum,i| sum + i.quantity * (fee.percentage ? fee.amount*i.price : fee.amount) }.round(2)
  end

  def pending_payment
    publisher_payment.blank?
  end
end

