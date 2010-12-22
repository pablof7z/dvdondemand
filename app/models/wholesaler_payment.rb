class WholesalerPayment < ActiveRecord::Base
  belongs_to :invoice, :class_name => 'WholesalerInvoice', :foreign_key => 'wholesaler_invoice_id'
  belongs_to :credit_card
  has_one :wholesaler, :through => :invoice
  
  has_many :transactions, :class_name => 'WholesalerPaymentTransaction', :dependent => :delete_all
  
  validates_numericality_of :amount
  
  def validate
    if amount > invoice.owed
      errors.add(:amount, "is greater than the total owed for this invoice")
    elsif invoice.owed > WHOLESALER_MINIMUM_PAYMENT and amount < WHOLESALER_MINIMUM_PAYMENT
      errors.add(:amount, "is less than the minimum payment")
    end
  end
  
  def purchase
    response = GATEWAY.purchase(total_in_cents, credit_card_for_f, options)
    transactions.create!(:action => 'purchase', :amount => total_in_cents, :response => response)
    response.success?
  end
  
  def total_in_cents
    (amount*100).round
  end
  
  # full parameters documented in ActiveMerchant's billing/gateways/linkpoint.rb file
  def options
    {
      :billing_address => {
        :name     => wholesaler.name,
        :address1 => credit_card.address1,
        :address2 => credit_card.address2,
        :city     => credit_card.city,
        :state    => credit_card.state,
        :zip      => credit_card.zip,
        :country  => credit_card.country,
        :company  => credit_card.company,   # same as Customer's?
        :email    => wholesaler.email      # same as Customer's?
      },
      :order_id   => "9-#{id}",
      :email      => wholesaler.email,
      # WTF: chargetotal is the only following field that FirstData uses
      # see http://railsdog.lighthouseapp.com/projects/31096/tickets/1411-credit-payment-to-linkpoint-gateway-fails 
      # :tax         => tax,
      # :vattax      => vattax,
      # :subtotal    => subtotal,
      # :shipping    => shipping_option.price,
      :chargetotal => amount
    }
  end
  
  def credit_card_for_f
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => credit_card.card_type,
      :number             => credit_card.card_number,
      :verification_value => credit_card.card_verification_value,
      :month              => credit_card.card_expires_on.month,
      :year               => credit_card.card_expires_on.year
    )
  end
end
