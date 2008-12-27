class Header < ActiveRecord::Base
  
  attr_protected :id, :parent_id, :content_type, :filename, :thumbnail, :size, :width, :height, :user_id, :created_at, :updated_at
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :partition => false, :content_type => :image, :max_size => 500.kilobytes
  include AttachmentFuExtensions
  
  def self.random
    ids = connection.select_all("SELECT id FROM headers where votes >= 0")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
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
    filename
  end
  
end
