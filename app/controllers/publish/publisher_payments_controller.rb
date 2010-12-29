class Publish::PublisherPaymentsController < PublishController
  belongs_to :publisher
  
  private
  
  def collection
    @publisher_payments = PublisherPayment.find(:all, :conditions => { :publisher_id => current_publisher.id }).map do |a|
      a if a.is_test_deposit? == false
    end.compact
  end
end

