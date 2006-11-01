require 'digest/sha1'

class User < ActiveRecord::Base

  validates_presence_of     :login, :email, :password_hash
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_length_of       :login, :minimum => 2
  validates_length_of       :login, :maximum => 15
    
  def self.authenticate(login, password)
    find_by_login_and_password_hash(login, Digest::SHA1.hexdigest(password + PASSWORD_SALT))
  end
  
  def self.encrypt(password)
    Digest::SHA1.hexdigest(password + PASSWORD_SALT)
  end  
    
end
