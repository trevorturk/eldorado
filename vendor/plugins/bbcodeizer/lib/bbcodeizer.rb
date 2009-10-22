module BBCodeizer  
  class << self
    
    include ApplicationHelper # for the random_string helper
    
    #:nodoc:
    Tags = {
      :literal               => [ /\[\[(.+?)\]\]/im, '&#91\1&#93' ],
      :start_code            => [ /\[code\](\r\n?)?/i, '<pre>' ],
      :end_code              => [ /(\r\n?)?\[\/code\]/i, '</pre>' ],
      :start_list            => [ /\[list\](\r\n?)?/i, '<ul>' ],
      :start_li              => [ /\[li\](\r\n?)?/i, '<li>' ],
      :end_li                => [ /(\r\n?)?\[\/li\](\r\n?)?/i, '</li>' ],
      :end_list              => [ /(\r\n?)?\[\/list\]/i, '</ul>' ],
      :start_quote           => [ /\[quote(?:=.*?)?\](\r\n?)?/i, '<blockquote>' ],
      :start_quote_with_cite => [ /\[quote=(.*?)\](\r\n?)?/i, '<blockquote><p><cite>\1 wrote:</cite></p>' ],
      :start_quote_sans_cite => [ /\[quote\](\r\n?)?/i, '<blockquote>' ],
      :end_quote             => [ /(\r\n?)?\[\/quote\]/i, '</blockquote>' ],
      :bold                  => [ /\[b\](.+?)\[\/b\]/im, '<strong>\1</strong>' ],
      :italic                => [ /\[i\](.+?)\[\/i\]/im, '<em>\1</em>' ],
      :underline             => [ /\[u\](.+?)\[\/u\]/im, '<u>\1</u>' ],
      :del                   => [ /\[del\](.+?)\[\/del\]/im, '<del>\1</del>' ],
      :strike                => [ /\[strike\](.+?)\[\/strike\]/im, '<del>\1</del>' ],
      :email_with_name       => [ /\[email=(.+?)\](.+?)\[\/email\]/i, '<a href="mailto:\1">\2</a>' ],
      :email_sans_name       => [ /\[email\](.+?)\[\/email\]/i, '<a href="mailto:\1">\1</a>' ],
      :url_with_title        => [ /\[url=(.+?)\](.+?)\[\/url\]/i, '<a href="\1">\2</a>' ],
      :url_sans_title        => [ /\[url\](.+?)\[\/url\]/i, '<a href="\1">\1</a>' ],
      :image                 => [ /\[img\](.+?)\[\/img\]/i, '<img src="\1" alt="\1" />' ],
      :size                  => [ /\[size=(\d{1,2})\](.+?)\[\/size\]/im, '<span style="font-size: \1px">\2</span>' ],
      :color                 => [ /\[color=([^;]+?)\](.+?)\[\/color\]/im, '<span style="color: \1">\2</span>' ],
      :youtube               => [ /\[youtube\](.+?)youtube.com\/watch\?v=(.+?)\[\/youtube\]/i, '<object width="425" height="350"><param name="movie" value="http://www.youtube.com/v/\2?fs=1"></param><param name="allowFullScreen" value="true"></param><embed src="http://www.youtube.com/v/\2?fs=1" type="application/x-shockwave-flash" allowfullscreen="true" width="425" height="350"></embed></object>' ],
      :googlevid             => [ /\[googlevid\](.+?)video.google.com\/videoplay\?docid=(.*?)\[\/googlevid\]/i, '<embed style="width:400px; height:326px;" id="VideoPlayback" type="application/x-shockwave-flash" src="http://video.google.com/googleplayer.swf?docId=\2&amp;hl=en"></embed>' ],
      :flash                 => [ /\[flash\](.+?)\[\/flash\]/i, '<object width="100%" height="100%"><param name="movie" value="\1"></param><embed src="\1" type="application/x-shockwave-flash" width="100%" height="100%"></embed></object>' ],
      :spoiler               => [ /\[spoiler\](.+?)\[\/spoiler\]/im, '<a href="#" class="spoiler-link" onclick="$(\'_RANDOM_ID_\').toggle(); return false;">SPOILER</a><div id="_RANDOM_ID_" class="spoiler" style="display:none;">\1</div>' ],
      :nsfw                  => [ /\[nsfw\](.+?)\[\/nsfw\]/im, '<a href="#" class="nsfw-link" onclick="$(\'_RANDOM_ID_\').toggle(); return false;">NSFW</a><div id="_RANDOM_ID_" class="nsfw" style="display:none;">\1</div>' ],
      :hide                  => [ /\[hide=(.+?)\](.+?)\[\/hide\]/im, '<a href="#" class="hide-link" onclick="$(\'_RANDOM_ID_\').toggle(); return false;">\1</a><div id="_RANDOM_ID_" class="hide" style="display:none;">\2</div>' ],
      :mp3                   => [ /\[mp3\](.+?)\[\/mp3\]/i, '<script language="JavaScript" src="/javascripts/audio-player.js"></script><object type="application/x-shockwave-flash" data="/flash/player.swf" id="_RANDOM_ID_" height="24" width="290"><param name="movie" value="/flash/player.swf"><param name="FlashVars" value="playerID=_RANDOM_ID_&amp;soundFile=\1"><param name="quality" value="high"><param name="menu" value="false"><param name="wmode" value="transparent"></object>' ],
      :superdeluxe           => [ /\[superdeluxe\](.+?)superdeluxe.com\/sd\/contentDetail.do\?id=(.+?)\[\/superdeluxe\]/i, '<object width="400" height="350"><param name="allowFullScreen" value="true" /><param name="movie" value="http://www.superdeluxe.com/static/swf/share_vidplayer.swf" /><param name="FlashVars" value="id=\2" /><embed src="http://www.superdeluxe.com/static/swf/share_vidplayer.swf" FlashVars="id=\2" type="application/x-shockwave-flash" width="400" height="350" allowFullScreen="true" ></embed></object>' ],
      :comedycentral         => [ /\[comedycentral\](.+?)comedycentral.com(.+?)?(.+?)=(.+?)\[\/comedycentral\]/i, '<embed FlashVars="config=http://www.comedycentral.com/motherload/xml/data_synd.jhtml?vid=\4%26myspace=false" src="http://www.comedycentral.com/motherload/syndicated_player/index.jhtml" quality="high" bgcolor="#006699" width="340" height="325" name="comedy_player" align="middle" allowScriptAccess="always" allownetworking="external" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>' ],
      :revver                => [ /\[revver\](.+?)revver.com\/video\/(.+?)\/(.+?)\[\/revver\]/i, '<embed type="application/x-shockwave-flash" src="http://flash.revver.com/player/1.0/player.swf" pluginspage="http://www.macromedia.com/go/getflashplayer" scale="noScale" salign="TL" bgcolor="#000000" flashvars="mediaId=\2&affiliateId=0&allowFullScreen=true" allowfullscreen="true" height="392" width="480"></embed>' ],
      :myspacetv             => [ /\[myspacetv\](.+?)myspace(.+?)videoid=(.+?)\[\/myspacetv\]/i, '<embed src="http://lads.myspace.com/videos/vplayer.swf" flashvars="m=\3&v=2&type=video" type="application/x-shockwave-flash" width="430" height="346"></embed>' ],
      :collegehumor          => [ /\[collegehumor\](.+?)collegehumor.com\/video:(.+?)\[\/collegehumor\]/i, '<embed src="http://www.collegehumor.com/moogaloop/moogaloop.swf?clip_id=\2" quality="best" width="400" height="300" type="application/x-shockwave-flash"></embed>' ],
      :hulu                  => [ /\[hulu\](.+?)\[\/hulu\]/i, '<object width="512" height="296"><param name="movie" value="http://www.hulu.com/embed/\1"></param><param name="allowFullScreen" value="true"></param><embed src="http://www.hulu.com/embed/\1" type="application/x-shockwave-flash" allowFullScreen="true"  width="512" height="296"></embed></object>' ],
      :metacafe              => [ /\[metacafe\](.+?)metacafe.com\/watch\/(.+?)\/(.+?)\/\[\/metacafe\]/i, '<embed src="http://www.metacafe.com/fplayer/\2/\3.swf" width="400" height="345" wmode="transparent" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed>' ],
      :yahoovid              => [ /\[yahoovid\](.+?)video.yahoo.com\/watch\/(.+?)\/(.+?)\[\/yahoovid\]/i, '<object width="512" height="323"><param name="movie" value="http://d.yimg.com/static.video.yahoo.com/yep/YV_YEP.swf?ver=2.2.2" /><param name="allowFullScreen" value="true" /><param name="flashVars" value="id=\3&vid=\2&lang=en-us&intl=us&embed=1" /><embed src="http://d.yimg.com/static.video.yahoo.com/yep/YV_YEP.swf?ver=2.2.2" type="application/x-shockwave-flash" width="512" height="323" allowFullScreen="true" flashVars="id=\3&vid=\2&lang=en-us&intl=us&embed=1" ></embed></object>' ],
      :flickr                => [ /\[flickr\](.+?)\/photos\/(.+?)\/(.+?)\[\/flickr\]/i, '<object type="application/x-shockwave-flash" width="400" height="300" data="http://www.flickr.com/apps/video/stewart.swf?v=1.162"><param name="flashvars" value="intl_lang=en-us&amp;photo_id=\3&amp;show_info_box=true"></param><param name="movie" value="http://www.flickr.com/apps/video/stewart.swf?v=1.162"></param><param name="bgcolor" value="#000000"></param><param name="allowFullScreen" value="true"></param><embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/video/stewart.swf?v=1.162" bgcolor="#000000" allowfullscreen="true" flashvars="intl_lang=en-us&amp;photo_id=\3&amp;flickr_show_info_box=true" height="300" width="400"></embed></object>' ],
      :gametrailers          => [ /\[gametrailers\](.+?)gametrailers.com\/player\/(.+?)\.(.+?)\[\/gametrailers\]/i, '<object codebase="http://download.macromedia.com/pub/shockwave/ca...=8,0,0,0" id="gtembed" width="480" height="392">	<param name="allowScriptAccess" value="sameDomain" /> <param name="allowFullScreen" value="true" /> <param name="movie" value="http://www.gametrailers.com/remote_wrap.php?mid=\2"/> <param name="quality" value="high" /> <embed src="http://www.gametrailers.com/remote_wrap.php?mid=\2" swLiveConnect="true" name="gtembed" align="middle" allowScriptAccess="sameDomain" allowFullScreen="true" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="480" height="392"></embed> </object>' ],      :slideshare            => [ /\[slideshare id=(.+?)&(.+?)=(.+?)&(.+?)=(.+?)\]/i, '<object type="application/x-shockwave-flash" wmode="transparent" data="https://s3.amazonaws.com:443/slideshare/ssplayer.swf?id=\1&#038;doc=\3" width="\5" height="348"><param name="movie" value="https://s3.amazonaws.com:443/slideshare/ssplayer.swf?id=\1&#038;doc=\3" /></object>' ],
      :funnyordie            => [ /\[funnyordie\](.+?)funnyordie.com\/videos\/([^\/]+)(.*)\[\/funnyordie\]/i, '<object width="464" height="388"><param name="movie" value="http://www2.funnyordie.com/public/flash/fodplayer.swf?6045" /><param name="flashvars" value="key=\2" /><param name="allowfullscreen" value="true" /><embed width="464" height="388" flashvars="key=\2" allowfullscreen="true" quality="high" src="http://www2.funnyordie.com/public/flash/fodplayer.swf?6045" type="application/x-shockwave-flash"></embed></object>' ],
      :atomfilms             => [ /\[atomfilms\](.+?)atomfilms.com\/film\/(.+?)\[\/atomfilms\]/i, '<embed src="http://www.atomfilms.com:80/a/autoplayer/shareEmbed.swf?keyword=\2" width="426" height="350"></embed>' ],
      :current               => [ /\[current\](.+?)current.com\/items\/(.+?)\/(.+?)\[\/current\]/i, '<object width="400" height="400"><param name="movie" value="http://current.com/e/\2/en_US"></param><param name="wmode" value="transparent"></param><param name="allowfullscreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://current.com/e/\2/en_US" type="application/x-shockwave-flash"  width="400" height="400" wmode="transparent" allowfullscreen="true" allowscriptaccess="always"></embed></object>' ],
      :vimeo                 => [ /\[vimeo\](.+?)vimeo.com\/(.+?)\[\/vimeo\]/i, '<object type="application/x-shockwave-flash" width="400" height="300" data="http://www.vimeo.com/moogaloop.swf?clip_id=\2&amp;server=www.vimeo.com&amp;fullscreen=1&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=">	<param name="quality" value="best" />	<param name="allowfullscreen" value="true" />	<param name="scale" value="showAll" />	<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id=\2&amp;server=www.vimeo.com&amp;fullscreen=1&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=" /></object>' ],
      :grooveshark           => [ /\[grooveshark\](.+?)\[\/grooveshark\]/i, '<object width="250" height="40"> <param name="movie" value="http://listen.grooveshark.com/songWidget.swf"></param> <param name="wmode" value="window"></param> <param name="allowScriptAccess" value="always"></param> <param name="flashvars" value="hostname=cowbell.grooveshark.com&widgetID=\1&style=grass&p=0"></param> <embed src="http://listen.grooveshark.com/songWidget.swf" type="application/x-shockwave-flash" width="250" height="40" flashvars="hostname=cowbell.grooveshark.com&widgetID=\1&style=grass&p=0" allowScriptAccess="always" wmode="window"></embed></object>'],
      :sup                   => [ /\[sup\](.+?)\[\/sup\]/im, '<sup>\1</sup>' ],
      :sub                   => [ /\[sub\](.+?)\[\/sub\]/im, '<sub>\1</sub>' ]
    }
        
    # Tags in this list are invoked. To deactivate a particular tag, call BBCodeizer.deactivate.
    # These names correspond to either names above or methods in this module.
                # The ':literal' tag MUST be first for it to work correctly
    TagList = [ :literal, :bold, :italic, :underline, :del, :strike, :email_with_name, 
                :email_sans_name, :url_with_title, :url_sans_title, :image, :size, :color, 
                :code, :quote, :youtube, :googlevid, :flash, :spoiler, :nsfw, :hide, :mp3, 
                :superdeluxe, :comedycentral, :revver, :myspacetv, :collegehumor, :hulu, 
                :metacafe, :yahoovid, :flickr, :gametrailers, :slideshare, :funnyordie, 
                :atomfilms, :vimeo, :li, :list, :current, :grooveshark, :sub, :sup ]

    # Parses all bbcode in +text+ and returns a new HTML-formatted string.
    def bbcodeize(text)
      text = text.dup
      TagList.each do |tag|
        if Tags.has_key?(tag)
          apply_tag(text, tag)
        else
          self.send(tag, text)
        end
        # Replace the matching random ids for the following tags: spoiler, nsfw, mp3
        @random_id = random_string
        2.times { text = text.sub('_RANDOM_ID_', @random_id) }
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
        # strip out newlines from within the tags and replace them with '<br />', otherwise
        # simple_format will simply append a '<br />' to the newlines, creating double spaces
        string.gsub!(/#{Tags[:start_code].last}.+?#{Tags[:end_code].last}/im) { |s| s.gsub(/\r\n?/, '<br />') }
      end
    end
  
    def li(string)
      # list tags must match, else don't do any replacing.
      if string.scan(Tags[:start_li].first).size == string.scan(Tags[:end_li].first).size
        apply_tags(string, :start_li, :end_li)
        # strip out newlines from within the tags and replace them with '<br />', otherwise
        # simple_format will simply append a '<br />' to the newlines, creating double spaces
        string.gsub!(/#{Tags[:start_li].last}.+?#{Tags[:end_li].last}/im) { |s| s.gsub(/\r\n?/, '<br />') }
      end
    end
    
    def list(string)
      # list tags must match, else don't do any replacing.
      if string.scan(Tags[:start_list].first).size == string.scan(Tags[:end_list].first).size
        apply_tags(string, :start_list, :end_list)
        # strip out newlines from within the tags and replace them with '<br />', otherwise
        # simple_format will simply append a '<br />' to the newlines, creating double spaces
        string.gsub!(/#{Tags[:start_list].last}.+?#{Tags[:end_list].last}/im) { |s| s.gsub(/\r\n?/, '<br />') }
      end
    end
    
    def quote(string)
      # quotes must match, else don't do any replacing
      if string.scan(Tags[:start_quote].first).size == string.scan(Tags[:end_quote].first).size
        apply_tags(string, :start_quote_with_cite, :start_quote_sans_cite, :end_quote)
        # strip out newlines from within the tags and replace them with '<br />', otherwise
        # simple_format will simply append a '<br />' to the newlines, creating double spaces
        string.gsub!(/#{Tags[:start_quote].last}.+?#{Tags[:end_quote].last}/im) { |s| s.gsub(/\r\n?/, '<br />') }
      end
    end

    def apply_tags(string, *tags)
      tags.each do |tag|
        string.gsub!(*Tags[tag])
      end
    end
    alias_method :apply_tag, :apply_tags
  end
end