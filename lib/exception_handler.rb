module ExceptionHandler
  
  class ActiveRecord::SettingsNotFound < StandardError; end
  
  protected
  
  def generic_error
    flash[:notice] = "Sorry, there was an error."
    redirect_to root_path
  end
  
  def not_found
    flash[:notice] = "Sorry, the page you requested was not found."
    redirect_to root_path
  end
  
  def invalid_page
    flash[:notice] = "Sorry, the page number you requested was not valid."
    redirect_to root_path
  end
  
  def default_settings
    Setting.defaults
    flash[:notice] = 'Welcome to El Dorado! Please create an admin user account for yourself.'
    redirect_to new_user_path
  end
  
  def url_upload_not_found
    flash[:notice] = "Sorry, the URL you provided was not valid."
    redirect_to new_upload_path
  end  
end
