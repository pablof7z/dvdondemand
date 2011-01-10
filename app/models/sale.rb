class Sale < ActiveRecord::Base
  belongs_to :publisher
  has_one :affiliate, :through => :publisher
  belongs_to :order
  belongs_to :wholesaler_invoice
  belongs_to :payment
  belongs_to :affiliate_payment, :class_name => 'Payment'
  has_many :fee_versions

  named_scope :payable, :conditions => {:type => ['Retail','Wholesale']}
  named_scope :pending_payment_publisher, :conditions => {:type => ['Retail','Wholesale'], :payment_id => nil}
  named_scope :pending_payment_affiliate, :conditions => {:type => ['Retail','Wholesale'], :affiliate_payment_id => nil}
  named_scope :done_payment_affiliate, :conditions => [ "(type = 'Retail' OR type = 'Wholesale') AND affiliate_payment_id IS NOT NULL" ]

  default_scope :order => 'created_at'

  def self.totals
    payable.sum(:total).round(2)
  end

  def self.totals_for(start,finish)
    sum(:total, :conditions => { :created_at => start..finish }).round(2)
  end

  def self.pending_payment_publishers
    pending_payment_publisher.map { |s| s.publisher }.uniq.compact
  end
  
  def self.pending_payment_affiliates
    pending_payment_affiliate.map { |s| s.affiliate }.uniq.compact
  end

  def pending_payment
    !kind_of?(GetStock) && payment.blank?
  end

  def fees
    (production_fees + processing_fees).round(2)
  end

  def production_fees
    fee_versions.inject(0) do |sum,f| 
      # consider saved fee versions (regardless of current) for sale's total fee calculation
      f.fee.revert_to(f.number)
      sum + apply_production_fee(f.fee)
    end
  end

  # apply each production fee fix amount to every item in the sale
  def apply_production_fee(fee)
    order.items_from(publisher).inject(0) do |sum,i| 
      sum + (fee.percentage ? 0 : i.quantity*fee.amount)
    end
  end

  def processing_fees
    apply_processing_fees
  end

  # apply each processing fee percentage to the publiher's sale totals
  def apply_processing_fees
    publisher_sale_totals = order.items_from(publisher).sum { |i| i.quantity*i.price }
    fee_versions.inject(0) do |sum,f| 
      # consider saved fee versions (regardless of current) for sale's total fee calculation
      f.fee.revert_to(f.number)
      sum + (f.fee.percentage ? publisher_sale_totals*f.fee.amount : 0)
    end
  end
end

