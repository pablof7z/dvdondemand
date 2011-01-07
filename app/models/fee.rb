class Fee < ActiveRecord::Base
  validates_presence_of :description, :amount
  # please don't use default_scope to hide deleted fees. See http://blog.semanticart.com/2009/03/22/using-default-scope-to-recreate-acts-as-paranoid.html
  named_scope :applicable, :conditions => {:deleted_at => nil}
  named_scope :production, :conditions => {:percentage => false, :deleted_at => nil}
  named_scope :processing, :conditions => {:percentage => true,  :deleted_at => nil}
  versioned
end

