# add methods to action controller base
ActionController::Base.send(:include, SessionTimeout)