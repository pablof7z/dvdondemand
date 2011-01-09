class AffiliateIntroduction < ActiveRecord::Base
  belongs_to :affiliate
  
  validates_presence_of :affiliate_id, :hash
  validates_uniqueness_of :hash
  
  def before_validation_on_create
    create_hash
  end
  
  private
  
  def create_hash
    a = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
    
    while true
      s = ""
      64.times { s << a[rand(a.size-1)] }
      break if Wholesaler.find_by_api_key(s) == nil
    end
    self.hash = s
  end
end
