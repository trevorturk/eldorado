require 'digest/sha1'
class User < ActiveRecord::Base

  validates_presence_of     :login, :email, :password_hash
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_length_of       :login, :minimum => 2
  validates_length_of       :login, :maximum => 15
  validates_format_of       :email, :with => /^([^@s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i
  validates_format_of       :login, :with => /^[a-zA-Z]{2}(?:\w+)?$/, :message => "must start with a letter and can only contain letters, numbers, and underscores"  
  validates_confirmation_of :password, :on => :create
  
  attr_reader :password
  
  def self.authenticate(login, password)
    find_by_login_and_password_hash(login, Digest::SHA1.hexdigest(password + PASSWORD_SALT))
  end

  def password=(value)
    write_attribute :password_hash, Digest::SHA1.hexdigest(value + PASSWORD_SALT)
    @password = value
  end
    
end
