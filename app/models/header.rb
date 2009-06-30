class Header < ActiveRecord::Base
    
  include PaperclipSupport
  
  belongs_to :user
  
  has_attached_file :attachment, :url => "/headers/:filename", :storage => :filesystem
  
  validates_attachment_size :attachment, :less_than => 500.kilobytes
  # validates_attachment_content_type :attachment, :content_type => /image/
  
  def self.random
    ids = connection.select_all("SELECT id FROM headers where votes >= 0")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
    
  def vote_up
    self.votes = self.votes + 1
    self.save(false)
  end

  def vote_down
    self.votes = self.votes - 1
    self.save(false)
  end
  
end
