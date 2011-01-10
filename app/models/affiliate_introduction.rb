class AffiliateIntroduction < ActiveRecord::Base
  belongs_to :affiliate
  has_one :publisher
  
  validates_presence_of :affiliate_id, :first_name, :last_name, :email, :signup_hash
  validates_uniqueness_of :signup_hash
  validates_uniqueness_of :email, :scope => :affiliate_id
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def before_validation_on_create
    create_signup_hash
  end
  
  def after_validation_on_create
    Affiliate::Notifications.deliver_introduction(self)
  end
  
  def validate
    if Publisher.find_by_email(email) != nil
      errors.add_to_base("This publisher has already signed up")
    end
  end
  
  def used?
    publisher != nil
  end
  
  private
  
  def create_signup_hash
    a = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
    
    while true
      s = ""
      32.times { s << a[rand(a.size-1)] }
      break if AffiliateIntroduction.find_by_signup_hash(s) == nil
    end
    self.signup_hash = s
  end
end
