module ExceptionHandler
  
  protected

  def generic_error
    flash[:notice] = "Sorry, there was an error."
    redirect_to root_path
  end

  def record_not_found
    flash[:notice] = "Sorry, the page you requested was not found."
    redirect_to root_path
  end

  def invalid_page
    flash[:notice] = "Sorry, the page number you requested was not valid."
    redirect_to root_path
  end
  
end