class Publish::PaymentsController < PublishController
  belongs_to :publisher
  
  private
  
  def collection
    @payments = Payment.find(:all, :conditions => { :owner_id => current_publisher.id, :owner_type => 'Publisher' }).map do |a|
      a if a.is_test_deposit? == false
    end.compact
  end
end

