class Subscription < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  
  validates_uniqueness_of :topic_id, :scope => :user_id
  
  def to_s
    id.to_s
  end
end
