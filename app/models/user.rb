require 'digest/sha1'

class User < ActiveRecord::Base
  
  has_many :posts, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :headers, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :uploads, :dependent => :destroy
  
  validates_presence_of     :login, :email, :password_hash
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_length_of       :login, :maximum => 25
  validates_confirmation_of :password, :on => :create
  
  before_create { |u| u.last_login_at = u.profile_updated_at = Time.now.utc }
  before_update { |u| u.profile_updated_at = Time.now.utc }
    
  attr_reader :password
  
  attr_protected :admin, :posts_count, :topics_count, :headers_count, :events_count, :created_at, :updated_at, :last_login_at, :profile_updated_at, :online_at, :banned_until, :ban_message
   
  def password=(value)
    return if value.blank?
    write_attribute :password_hash, User.encrypt(value)
    @password = value
  end
  
  def self.authenticate(login, password)
    find_by_login_and_password_hash(login, encrypt(password))
  end
  
  def self.encrypt(password)
    Digest::SHA1.hexdigest(password + PASSWORD_SALT)
  end
  
  def self.users_online
    User.find(:all, :conditions => ["online_at > ?", Time.now.utc-5.minutes])
  end
  
end
