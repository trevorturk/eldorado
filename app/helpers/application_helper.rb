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
    @page_title || "El Dorado"
  end
  
  def nav_link(name,options)
      if options[:controller] == @current_controller
        link_to(name, options, :class => 'current-page')
      else
        link_to(name,options)
      end
  end
  
  def bb(text)
      white_list(auto_link(bbcodeize(h(text))))
    end
     
end
