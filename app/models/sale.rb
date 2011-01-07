class Sale < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :order
  belongs_to :wholesaler_invoice
  belongs_to :publisher_payment
  has_many :fee_versions

  named_scope :pending_payment, :conditions => {:type => ['Retail','Whole'], :publisher_payment_id => nil}

  default_scope :order => 'created_at'

  def self.totals
    sum(:total).round(2)
  end

  def self.totals_for(start,finish)
    sum(:total, :conditions => { :created_at => start..finish }).round(2)
  end

  def pending_payment
    !kind_of?(GetStock) && publisher_payment.blank?
  end

  def fees
    (production_fees + processing_fees).round(2)
  end

  def production_fees
    fee_versions.inject(0) do |sum,f| 
      # consider saved fee versions (regardless of current) for sale's total fee calculation
      f.fee.revert_to(f.number)
      sum += apply_production_fee(f.fee)
    end
  end

  def processing_fees
    apply_processing_fees
  end

  private

  # apply each production fee fix amount to every item in the sale
  def apply_production_fee(fee)
    order.items_from(publisher).inject(0) do |sum,i| 
      sum + (fee.percentage ? 0 : i.quantity*fee.amount)
    end
  end

  # apply each processing fee percentage to the publiher's sale totals
  def apply_processing_fees
    publisher_totals = order.items_from(publisher).sum { |i| i.quantity*i.price }
    fee_versions.inject(0) do |sum,f| 
      # consider saved fee versions (regardless of current) for sale's total fee calculation
      f.fee.revert_to(f.number)
      sum + (f.fee.percentage ? publisher_totals*f.fee.amount : 0)
    end
  end
end

