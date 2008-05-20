class Header < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, :max_size => 500.kilobytes, :content_type => :image
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
