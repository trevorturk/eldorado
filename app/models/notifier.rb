class Notifier < ActionMailer::Base
  
  default_url_options[:host] = DOMAIN
  
  def welcome(sent_at = Time.now.utc)
    subject       'Notifier#welcome'
    recipients    ''
    from          ''
    sent_on       sent_at
  end

  def forgot_password(sent_at = Time.now.utc)
    subject       'Notifier#forgot_password'
    recipients    ''
    from          ''
    sent_on       sent_at
  end

  def personal_message(sent_at = Time.now.utc)
    subject       'Notifier#personal_message'
    recipients    ''
    from          ''
    sent_on       sent_at
  end

  def subscription(subscribers, topic, post)
    subject       "New post in #{topic}"
    recipients    MAILER
    bcc           subscribers.map(&:email).join(', ')
    from          MAILER
    sent_on       Time.now.utc
    body          :topic => topic, :post => post
  end

end
