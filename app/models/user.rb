# == Schema Information
# Schema version: 49
#
# Table name: users
#
#  id                 :integer(11)   not null, primary key
#  login              :string(255)   
#  email              :string(255)   
#  password_hash      :string(255)   
#  created_at         :datetime      
#  last_login_at      :datetime      
#  admin              :boolean(1)    
#  posts_count        :integer(11)   default(0)
#  signature          :string(255)   
#  bio                :text          
#  profile_updated_at :datetime      
#  online_at          :datetime      
#  avatar_id          :integer(11)   
#

require 'digest/sha1'

class User < ActiveRecord::Base
  
  has_many :avatars, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :headers, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :themes, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :uploads, :dependent => :destroy
      
  validates_presence_of     :login, :email, :password_hash
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_length_of       :login, :maximum => 25
  validates_confirmation_of :password, :on => :create
  
  before_create { |u| u.last_login_at = u.profile_updated_at = Time.now.utc }
    
  attr_reader :password
  
  attr_protected :id, :created_at, :last_login_at, :admin, :posts_count
   
  def password=(value)
    return if value.blank?
    write_attribute :password_hash, User.encrypt(value)
    @password = value
  end
  
  def updated_at
    profile_updated_at
  end
  
  def is_online?
    return true if online_at > Time.now.utc-5.minutes unless online_at.nil?
  end
  
  def self.authenticate(login, password)
    find_by_login_and_password_hash(login, encrypt(password))
  end
  
  def self.encrypt(password)
    Digest::SHA1.hexdigest(password)
  end
  
  def self.users_online
    User.find(:all, :conditions => ["online_at > ?", Time.now.utc-5.minutes])
  end
    
end
