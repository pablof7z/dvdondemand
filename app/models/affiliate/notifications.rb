class Affiliate::Notifications < ActionMailer::Base
  def introduction(introduction)
    recipients introduction.email
    from       "#{introduction.affiliate.name}"
    subject    "Invitation to join #{SITE}"
    sent_on    Time.now
    body({ :introduction=>introduction })
  end
end
