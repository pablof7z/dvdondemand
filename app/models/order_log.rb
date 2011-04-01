class OrderLog < ActiveRecord::Base
  belongs_to :order

  named_scope :debug, :conditions => "priority like 'debug'"
  named_scope :info, :conditions => "priority like 'info'"
  named_scope :warning, :conditions => "priority like 'warning'"
  named_scope :error, :conditions => "priority like 'error'"
  named_scope :fatal, :conditions => "priority like 'fatal'"
  named_scope :unknown, :conditions => "priority like 'unknown'"
end
