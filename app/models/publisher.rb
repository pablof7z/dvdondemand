class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :items

  has_many :sales

  has_many :get_orders, :class_name => 'Order'
  has_many :get_stocks, :class_name => 'GetStock'
  has_many :whole_sales, :class_name => 'Wholesale'
  has_many :retail_sales, :class_name => 'Retail'

  has_many :payments, :as => :owner, :conditions => { :is_test_deposit => false }
  has_many :all_payments, :as => :owner
  has_many :financial_informations, :as => :owner
  has_many :validated_financial_informations, :as => :owner, :class_name => 'FinancialInformation', :conditions => { :validated => true }
  
  belongs_to :affiliate
  belongs_to :affiliate_introduction
  
  named_scope :available, :conditions => { :deleted_at => nil }  
  named_scope :approved, :conditions => { :deleted_at => nil, :approved => true }
  
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :affiliate_introduction_id, :allow_nil => true
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  after_create :add_default_catalog

  has_attached_file :image, :url=> '/system/images/publisher/:id/:basename_:style.:extension',
                    :styles => { :medium => '300x300>', :thumb => '100x100>' }
  validates_attachment_content_type :image,  :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :allow_nil => true

  # set the pagination limit here, but mind the tests
  def self.per_page
    10  
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def artist_name
    nickname || full_name
  end

  # all pending payments totals (minus fees)
  def pending_payment_totals
    unless sales.pending_payment_publisher.blank?
      sales.pending_payment_publisher.inject(0) { |sum,s| sum + (s.total - s.fees) }.round(2)
    else
      0
    end
  end
  
  def default_financial_information
    validated_financial_informations.each { |a| return a if a.default }
    return validated_financial_informations.first
  end

  def update_with_password(params)
    if params[:password].blank? and params[:password_confirmation].blank? and params[:current_password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      update_attributes(params)
    else
      super
    end
  end
  
  def destroy
    self.update_attribute(:deleted_at, Time.now)
    catalogs.each { |c| c.delete }
    products.each { |p| p.destroy }
  end

  private
  
  def add_default_catalog
    catalog = Catalog.new(:title => "#{full_name}'s Collection", :publisher => self)
    catalog.save!
  end
end
