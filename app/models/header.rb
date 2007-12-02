# == Schema Information
# Schema version: 64
#
# Table name: headers
#
#  id           :integer(11)     not null, primary key
#  parent_id    :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#  description  :text            
#  user_id      :integer(11)     
#  created_at   :datetime        
#  updated_at   :datetime        
#  votes        :integer(11)     default(0)
#

class Header < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :path_prefix => 'public/headers', :max_size => 500.kilobytes
  
  validates_as_attachment
  validates_uniqueness_of :filename
  validates_presence_of :user_id
  
  before_create :reject_index_files
  
  attr_protected :id, :parent_id, :user_id, :created_at, :updated_at
  
  def self.random
    ids = connection.select_all("SELECT id FROM headers where votes >= 0")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end
  
  def reject_index_files
    errors.add_to_base("Invalid file name") and return false if %w(index.html index.htm).include?(filename)
  end
  
  def vote_up
    self.votes = self.votes + 1
    self.save!
  end

  def vote_down
    self.votes = self.votes - 1
    self.save!
  end
  
  def to_s
    filename.to_s
  end

end
