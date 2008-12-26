class Notifier < ActionMailer::Base
  
  default_url_options[:host] = DOMAIN
  
  def welcome(sent_at = Time.now)
    subject       'Notifier#welcome'
    recipients    ''
    from          ''
    sent_on       sent_at
  end

  def forgot_password(sent_at = Time.now)
    subject       'Notifier#forgot_password'
    recipients    ''
    from          ''
    sent_on       sent_at
  end

  def personal_message(sent_at = Time.now)
    subject       'Notifier#personal_message'
    recipients    ''
    from          ''
    sent_on       sent_at
  end

  def subscription(topic, post)
    subject       "New post in #{topic}"
    recipients    MAILER
    bcc           topic.subscribers.map(&:email)*'; '
    from          MAILER
    sent_on       Time.now
    body          :topic => topic, :post => post
  end

end
