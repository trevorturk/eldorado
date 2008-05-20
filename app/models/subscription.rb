class Subscription < ActiveRecord::Base
  
  def to_s
    id.to_s
  end
end
