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
    @page_title || "El Dorado.org"
  end
         
end
