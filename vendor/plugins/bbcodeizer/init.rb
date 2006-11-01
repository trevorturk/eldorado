require 'bbcodeizer'
require 'bbcodeize_helper'

ActionView::Base.send :include, BBCodeizeHelper

require 'application_helper'

module ApplicationHelper
  def format_text(text)
    white_list(bbcodeize(text))
  end
end