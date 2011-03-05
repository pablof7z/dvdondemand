class PublisherMailing < ActionMailer::Base
  def email_about_product(recipients, product)
    @subject = "Invitation to see my new product #{product.title}"
    @bcc = recipients
    @from = product.publisher.email
    @sent_on = Time.now
    @body["product"] = product
  end
end
