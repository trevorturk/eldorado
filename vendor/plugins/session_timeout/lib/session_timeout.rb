module SessionTimeout
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def session_times_out_in(time, opts={})
      opts[:after_timeout] = opts[:after_timeout] || nil
      class_eval { prepend_before_filter Proc.new { |c| c.check_session_expiry(time, opts)}, :except => opts[:except]  }
    end
  end
  
  def check_session_expiry(time, opts)
    logger.info "::: Checking session expiry"
    if session[:expires_at]
      if session_has_timed_out?
        logger.info "::: Session has expired, resetting session."
        reset_session
        unless opts[:after_timeout].nil?
          logger.info "::: Calling after timeout callback"
          return opts[:after_timeout].call(self) if opts[:after_timeout].instance_of?(Proc)
          return self.send(opts[:after_timeout]) if opts[:after_timeout].instance_of?(Symbol)
        end
      else
        logger.info "::: Session has not expired. Reinitialising."
        initialize_session_expiry(time)
      end
    else
      "::: Session expiry not initialized"
      initialize_session_expiry(time)
    end
  end
  
  protected    
    def initialize_session_expiry(time)
      expires_at = time.from_now
      logger.info "::: Initializing session expiry. Expires at #{expires_at}"
      session[:expires_at] = expires_at
    end
    
    def session_has_timed_out?
      Time.now > session[:expires_at]
    end
end