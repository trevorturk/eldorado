class Mailer < ActionMailer::Base
  
  default_url_options[:host] = CONFIG['domain'].gsub('http://', '').gsub('https://', '')
  
  def subscription(subscribers, topic, post)
    subject       "New post in #{topic}"
    recipients    CONFIG['mailer']
    bcc           subscribers.map(&:email).join(', ')
    from          CONFIG['mailer']
    sent_on       Time.now.utc
    body          :topic => topic, :post => post
  end

end
