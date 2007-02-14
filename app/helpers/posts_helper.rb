module PostsHelper
  
  def can_edit_post?()
    current_user == post.user
  end
  
end
