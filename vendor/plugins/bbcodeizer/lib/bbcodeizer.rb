module BBCodeizer  
  class << self

    #:nodoc:
    Tags = {
      :start_code            => [ /\[code\]/i, '<pre>' ],
      :end_code              => [ /\[\/code\]/i, '</pre>' ],
      :start_quote           => [ /\[quote(?:=.*?)?\]/i, nil ],
      :start_quote_with_cite => [ /\[quote=(.*?)\]/i, '<blockquote><p><cite>\1 wrote:</cite></p>' ],
      :start_quote_sans_cite => [ /\[quote\]/i, '<blockquote>' ],
      :end_quote             => [ /\[\/quote\]/i, '</blockquote>' ],
      :bold                  => [ /\[b\](.+?)\[\/b\]/i, '<strong>\1</strong>' ],
      :italic                => [ /\[i\](.+?)\[\/i\]/i, '<em>\1</em>' ],
      :underline             => [ /\[u\](.+?)\[\/u\]/i, '<u>\1</u>' ],
      :email_with_name       => [ /\[email=(.+?)\](.+?)\[\/email\]/i, '<a href="mailto:\1">\2</a>' ],
      :email_sans_name       => [ /\[email\](.+?)\[\/email\]/i, '<a href="mailto:\1">\1</a>' ],
      :url_with_title        => [ /\[url=(.+?)\](.+?)\[\/url\]/i, '<a href="\1">\2</a>' ],
      :url_sans_title        => [ /\[url\](.+?)\[\/url\]/i, '<a href="\1">\1</a>' ],
      :image                 => [ /\[img\](.+?)\[\/img\]/i, '<img src="\1" />' ],
      :size                  => [ /\[size=(\d{1,2})\](.+?)\[\/size\]/i, '<span style="font-size: \1px">\2</span>' ],
      :color                 => [ /\[color=([^;]+?)\](.+?)\[\/color\]/i, '<span style="color: \1">\2</span>' ],
      :youtube               => [ /\[youtube\](.+?)youtube.com\/watch\?v=(.+?)\[\/youtube\]/i, '<object width="425" height="350"><param name="movie" value="http://www.youtube.com/v/\2"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" width="425" height="350"></embed></object>' ],
      :googlevid             => [ /\[googlevid\](.+?)video.google.com\/videoplay\?docid=(.*?)\[\/googlevid\]/i, '<embed style="width:400px; height:326px;" id="VideoPlayback" type="application/x-shockwave-flash" src="http://video.google.com/googleplayer.swf?docId=\2&amp;hl=en"></embed>' ],
      :flash                 => [ /\[flash\](.+?)\[\/flash\]/i, '<object width="100%" height="100%"><param name="movie" value="\1"></param><embed src="\1" type="application/x-shockwave-flash" width="100%" height="100%"></embed></object>' ],
      :spoiler               => [ /\[spoiler\](.+?)\[\/spoiler\]/i, '<a href="#" onclick="$(\'_SPOILER\').toggle(); return false;">Show Spoiler</a><div id="_SPOILER" style="display:none;">\1</div>' ],
      :mp3                   => [ /\[mp3\](.+?)\[\/mp3\]/i, '<script language="JavaScript" src="/javascripts/audio-player.js"></script><object type="application/x-shockwave-flash" data="/flash/player.swf" id="_MP3" height="24" width="290"><param name="movie" value="/flash/player.swf"><param name="FlashVars" value="playerID=_MP3&amp;soundFile=\1"><param name="quality" value="high"><param name="menu" value="false"><param name="wmode" value="transparent"></object>' ],
      :funnyordie            => [ /\[funnyordie\](.+?)funnyordie.com\/videos\/(.+?)\[\/funnyordie\]/i, '<object id="myFlash" type="application/x-shockwave-flash" width="464" height="380" wmode="transparent" data="http://www2.funnyordie.com/public/flash/fodplayer.swf?file=http://www2.funnyordie.com/\2.flv&autoStart=false"><param name="movie" value="http://www2.funnyordie.com/public/flash/fodplayer.swf?file=http://www2.funnyordie.com/\2.flv&autoStart=false" /><param name="wmode" value="transparent" /><param name="swliveconnect" value="true" /><embed type="application/x-shockwave-flash" src="http://www2.funnyordie.com/public/flash/fodplayer.swf" pluginspage="http://www.macromedia.com/go/getflashplayer" scale="noScale" salign="TL" bgcolor="#000000" flashvars="file=http://www2.funnyordie.com/\2.flv&autoStart=false" />' ]
    }
    # removed quotes from cites, added youtube, googlevid, spoiler, mp3, funnyordie

    # Tags in this list are invoked. To deactivate a particular tag, call BBCodeizer.deactivate.
    # These names correspond to either names above or methods in this module.
    TagList = [ :bold, :italic, :underline, :email_with_name, :email_sans_name, 
                :url_with_title, :url_sans_title, :image, :size, :color,
                :code, :quote, :youtube, :googlevid, :flash, :spoiler, :mp3, :funnyordie ]

    # Parses all bbcode in +text+ and returns a new HTML-formatted string.
    def bbcodeize(text)
      text = text.dup
      TagList.each do |tag|
        if Tags.has_key?(tag)
          apply_tag(text, tag)
        else
          self.send(tag, text)
        end
        char = ("a".."z").to_a + ("1".."9").to_a 
        random_string = Array.new(6, '').collect{char[rand(char.size)]}.join
        text = text.sub('_SPOILER', random_string)
        text = text.sub('_SPOILER', random_string)
        char = ("a".."z").to_a + ("1".."9").to_a 
        random_string = Array.new(6, '').collect{char[rand(char.size)]}.join
        text = text.sub('_MP3', random_string)
        text = text.sub('_MP3', random_string)
      end
      text
    end

    # Configuration option to deactivate particular +tags+.
    def deactivate(*tags)
      tags.each { |t| TagList.delete(t) }
    end

    # Configuration option to change the replacement string used for a particular +tag+. The source
    # code should be referenced to determine what an appropriate replacement +string+ would be.
    def replace_using(tag, string)
      Tags[tag][1] = string
    end
    
  private

    def code(string)
      # code tags must match, else don't do any replacing.
      if string.scan(Tags[:start_code].first).size == string.scan(Tags[:end_code].first).size
        apply_tags(string, :start_code, :end_code)
      end
    end
  
    def quote(string)
      # quotes must match, else don't do any replacing
      if string.scan(Tags[:start_quote].first).size == string.scan(Tags[:end_quote].first).size
        apply_tags(string, :start_quote_with_cite, :start_quote_sans_cite, :end_quote)
      end
    end
        
    def apply_tags(string, *tags)
      tags.each do |tag|
        while_true { string.sub!(*Tags[tag]) }
      end
    end
    alias_method :apply_tag, :apply_tags

    # there's no good way to do the C equivalent of "while(foo());"
    # the closest thing is "{ } while foo", which is wrapped here because
    # that looks pretty odd.
    def while_true(&block)
      { } while yield
    end
  end
end