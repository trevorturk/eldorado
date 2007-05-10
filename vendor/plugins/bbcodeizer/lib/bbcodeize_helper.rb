require 'bbcodeizer'

module BBCodeizeHelper
  # Parses all bbcode in +text+ and returns a new HTML-formatted string.
  def bbcodeize(text)
    BBCodeizer.bbcodeize(text)
  end
end