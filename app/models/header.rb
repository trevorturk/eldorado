class Header < ActiveRecord::Base
  
  has_attachment :content_type => :image, :storage => :file_system, :max_size => 50.kilobytes
  validates_as_attachment
  validates_uniqueness_of :filename

end
