class Comment < ActiveRecord::Base
  
  def to_s
    body
  end
end
