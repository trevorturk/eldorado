# == Schema Information
# Schema version: 76
#
# Table name: users
#
#  id                 :integer(11)     not null, primary key
#  login              :string(255)     
#  email              :string(255)     
#  password_hash      :string(255)     
#  created_at         :datetime        
#  admin              :boolean(1)      
#  posts_count        :integer(11)     default(0)
#  signature          :string(255)     
#  bio                :text            
#  profile_updated_at :datetime        
#  online_at          :datetime        
#  avatar             :string(255)     
#  auth_token         :string(255)     
#  auth_token_exp     :datetime        
#  time_zone          :string(255)     
#  ban_message        :string(255)     
#  banned_until       :datetime        
#  chatting_at        :datetime        
#

require 'digest/sha1'

class User < ActiveRecord::Base
  
  has_many :avatars, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :headers, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :posts, :order => 'posts.created_at desc', :dependent => :destroy
  has_many :themes, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :uploads, :dependent => :destroy
  has_one :current_avatar, :class_name => 'Avatar', :foreign_key => 'current_user_id', :dependent => :nullify
      
  validates_presence_of     :login, :email, :password_hash
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_length_of       :login, :maximum => 25
  validates_confirmation_of :password, :on => :create
  validates_confirmation_of :password, :on => :update, :allow_blank => true
  
  validates_format_of       :email, :on => :create,
                            :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  before_create :set_defaults
  
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )
    
  attr_reader :password
  
  attr_protected :id, :created_at, :admin, :posts_count
     
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
  
  def banned?
    return true if banned_until > Time.now.utc unless banned_until.nil?
  end
  
  def remove_ban
    self.ban_message = self.banned_until = nil
    self.save
  end
  
  def self.authenticate(login, password)
    find_by_login_and_password_hash(login, encrypt(password))
  end
  
  def self.encrypt(password)
    Digest::SHA1.hexdigest(password)
  end
  
  def self.newest
    find(:first, :order => 'created_at desc')
  end
  
  def self.online
    User.find(:all, :conditions => ['logged_out = ? and (online_at > ? or chatting_at > ?)', false, Time.now.utc-5.minutes, Time.now.utc-30.seconds], :order => 'login asc')
  end
  
  def self.chatting
    User.find(:all, :conditions => ['chatting_at > ?', Time.now.utc-30.seconds], :order => 'login asc')
  end
  
  def set_defaults
    self.profile_updated_at = Time.now.utc
    self.time_zone = Setting.find(:first).time_zone
  end
  
  def to_s
    login
  end
end
