class Mailer < ActionMailer::Base
  
  default_url_options[:host] = DOMAIN
  
  def subscription(subscribers, topic, post)
    subject       "New post in #{topic}"
    recipients    MAILER
    bcc           subscribers.map(&:email).join(', ')
    from          MAILER
    sent_on       Time.now.utc
    body          :topic => topic, :post => post
  end

end
