class Affiliate::Notifications < ActionMailer::Base
  def introduction(introduction)
    recipients introduction.email
    from       "#{SITE} <no-reply@#{SITE.gsub(/ /, '').downcase}.com>"
    reply_to   "#{introduction.affiliate.name} <#{introduction.affiliate.email}>"
    subject    "Invitation to join #{SITE}"
    sent_on    Time.now
    body({ :introduction=>introduction })
    content_type "text/html"
  end
end
