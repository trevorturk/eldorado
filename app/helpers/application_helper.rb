# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  
  protected
  
  def random_image
    image_files = %w( .jpg .gif .png )
    files = Dir.entries(
          "#{RAILS_ROOT}/public/headers" 
      ).delete_if { |x| !image_files.index(x[-4,4]) }
    files[rand(files.length)]
  end

  def page_title
    if @topic && (current_action != "new")
      @topic.title + " (" + SITE_TITLE + ")"
    elsif @user && (current_action != "new") && logged_in?
      @user.login + " (" + SITE_TITLE + ")"
    else
      SITE_TITLE
    end
  end
  
  def tab(name)
    if name == current_controller
      'tab'
    elsif name == "topics" && (current_controller == "posts")
      'tab'
    end
  end
  
  def current_controller
    request.path_parameters['controller']
  end
  
  def current_action
    request.path_parameters['action']
  end
    
end
