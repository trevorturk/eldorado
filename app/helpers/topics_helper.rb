module TopicsHelper

  def can_edit?
    current_user == @topic.user
  end

end
