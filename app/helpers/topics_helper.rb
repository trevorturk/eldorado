module TopicsHelper

  def can_edit?
    current_user.id == @topic.user_id
  end

end
