class Order < ActiveRecord::Base
  belongs_to :sale
  belongs_to :customer
  belongs_to :shipping_option # USPS, FedEx, DHL, etc.
  has_many :customer_payments

  has_many :items, :class_name => 'OrderItem', :dependent => :delete_all
  accepts_nested_attributes_for :items

  has_many :transactions, :class_name => 'OrderTransaction', :dependent => :delete_all
  attr_accessor :card_number, :card_verification  # to not persist'em in the db
  attr_accessor :first_name, :last_name           # just for credit_card validations

  validate_on_create :valid_credit_card
  validates_presence_of :billing_address

  def item_count
    total = 0
    total = items.inject(0) do |subtotal, item|
      subtotal + item.quantity
    end
    total
  end

  def total
    total = 0
    total = items.inject(0) do |subtotal, item|
      subtotal + item.product.price * item.quantity + item.packaging_option.price
    end
    total
  end

  # all amounts are in cents for ActiveMerchant
  def total_in_cents
    (total*100).round
  end

  def purchase
    response = GATEWAY.purchase(total_in_cents, credit_card, :order_id => id, :ip => ip_address)
    transactions.create!(:action => 'purchase', :amount => total_in_cents, :response => response)
    response.success?
  end

  private

  def valid_credit_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :first_name         => first_name,
      :last_name          => last_name,
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year
    )
  end
end

