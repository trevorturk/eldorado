module TopicsHelper

  def can_edit_topic?
    current_user == @topic.user
  end
    
end
