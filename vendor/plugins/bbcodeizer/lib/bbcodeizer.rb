module BBCodeizer  
  class << self
    
    include ApplicationHelper # for the random_string helper
    
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
      :image                 => [ /\[img\](.+?)\[\/img\]/i, '<img src="\1" alt="\1" />' ],
      :size                  => [ /\[size=(\d{1,2})\](.+?)\[\/size\]/i, '<span style="font-size: \1px">\2</span>' ],
      :color                 => [ /\[color=([^;]+?)\](.+?)\[\/color\]/i, '<span style="color: \1">\2</span>' ],
      :youtube               => [ /\[youtube\](.+?)youtube.com\/watch\?v=(.+?)\[\/youtube\]/i, '<object width="425" height="350"><param name="movie" value="http://www.youtube.com/v/\2"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" width="425" height="350"></embed></object>' ],
      :googlevid             => [ /\[googlevid\](.+?)video.google.com\/videoplay\?docid=(.*?)\[\/googlevid\]/i, '<embed style="width:400px; height:326px;" id="VideoPlayback" type="application/x-shockwave-flash" src="http://video.google.com/googleplayer.swf?docId=\2&amp;hl=en"></embed>' ],
      :flash                 => [ /\[flash\](.+?)\[\/flash\]/i, '<object width="100%" height="100%"><param name="movie" value="\1"></param><embed src="\1" type="application/x-shockwave-flash" width="100%" height="100%"></embed></object>' ],
      :spoiler               => [ /\[spoiler\](.+?)\[\/spoiler\]/im, '<a href="#" class="spoiler-link" onclick="$(\'_RANDOM_ID_\').toggle(); return false;">SPOILER</a><div id="_RANDOM_ID_" class="spoiler" style="display:none;">\1</div>' ],
      :nsfw                  => [ /\[nsfw\](.+?)\[\/nsfw\]/i, '<a href="#" class="nsfw-link" onclick="$(\'_RANDOM_ID_\').toggle(); return false;">NSFW</a><div id="_RANDOM_ID_" class="nsfw" style="display:none;">\1</div>' ],
      :mp3                   => [ /\[mp3\](.+?)\[\/mp3\]/i, '<script language="JavaScript" src="/javascripts/audio-player.js"></script><object type="application/x-shockwave-flash" data="/flash/player.swf" id="_RANDOM_ID_" height="24" width="290"><param name="movie" value="/flash/player.swf"><param name="FlashVars" value="playerID=_RANDOM_ID_&amp;soundFile=\1"><param name="quality" value="high"><param name="menu" value="false"><param name="wmode" value="transparent"></object>' ],
      :superdeluxe           => [ /\[superdeluxe\](.+?)superdeluxe.com\/sd\/contentDetail.do\?id=(.+?)\[\/superdeluxe\]/i, '<object width="400" height="350"><param name="allowFullScreen" value="true" /><param name="movie" value="http://www.superdeluxe.com/static/swf/share_vidplayer.swf" /><param name="FlashVars" value="id=\2" /><embed src="http://www.superdeluxe.com/static/swf/share_vidplayer.swf" FlashVars="id=\2" type="application/x-shockwave-flash" width="400" height="350" allowFullScreen="true" ></embed></object>' ],
      :comedycentral         => [ /\[comedycentral\](.+?)comedycentral.com\/motherload\/index.jhtml\?ml_video=(.+?)\[\/comedycentral\]/i, '<embed FlashVars="config=http://www.comedycentral.com/motherload/xml/data_synd.jhtml?vid=\2%26myspace=false" src="http://www.comedycentral.com/motherload/syndicated_player/index.jhtml" quality="high" bgcolor="#006699" width="340" height="325" name="comedy_player" align="middle" allowScriptAccess="always" allownetworking="external" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>' ],
      :revver                => [ /\[revver\](.+?)revver.com\/watch\/(.+?)\[\/revver\]/i, '<embed type="application/x-shockwave-flash" src="http://flash.revver.com/player/1.0/player.swf" pluginspage="http://www.macromedia.com/go/getflashplayer" scale="noScale" salign="TL" bgcolor="#000000" flashvars="mediaId=\2&affiliateId=0&allowFullScreen=true" allowfullscreen="true" height="392" width="480"></embed>' ],
      :myspacetv             => [ /\[myspacetv\](.+?)myspace(.+?)videoid=(.+?)\[\/myspacetv\]/i, '<embed src="http://lads.myspace.com/videos/vplayer.swf" flashvars="m=\3&v=2&type=video" type="application/x-shockwave-flash" width="430" height="346"></embed>' ],
      :collegehumor          => [ /\[collegehumor\](.+?)collegehumor.com\/video:(.+?)\[\/collegehumor\]/i, '<embed src="http://www.collegehumor.com/moogaloop/moogaloop.swf?clip_id=\2" quality="best" width="400" height="300" type="application/x-shockwave-flash"></embed>' ],
      :metacafe              => [ /\[metacafe\](.+?)metacafe.com\/watch\/(.+?)\/(.+?)\/\[\/metacafe\]/i, '<embed src="http://www.metacafe.com/fplayer/\2/\3.swf" width="400" height="345" wmode="transparent" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed>' ],
      :yahoovid              => [ /\[yahoovid\](.+?)id=(.+?)&(.+?)vid=(.+?)'(.+?)\[\/yahoovid\]/i, '<embed src="http://us.i1.yimg.com/cosmos.bcst.yahoo.com/player/media/swf/FLVVideoSolo.swf" flashvars="id=\2&vid=\4" type="application/x-shockwave-flash" width="425" height="350"></embed>' ],
      :gametrailers          => [ /\[gametrailers\](.+?)gametrailers.com\/player\/(.+?).(.+?)\[\/gametrailers\]/i, '<object codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" id="gtembed" width="480" height="392">	<param name="allowScriptAccess" value="sameDomain" /> <param name="allowFullScreen" value="true" /> <param name="movie" value="http://www.gametrailers.com/remote_wrap.php?mid=/2"/> <param name="quality" value="high" /> <embed src="http://www.gametrailers.com/remote_wrap.php?mid=27505" swLiveConnect="true" name="gtembed" align="middle" allowScriptAccess="sameDomain" allowFullScreen="true" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="480" height="392"></embed> </object>' ],
      :atomfilms             => [ /\[atomfilms\](.+?)atomfilms.com\/film\/(.+?)\[\/atomfilms\]/i, '<embed src="http://www.atomfilms.com:80/a/autoplayer/shareEmbed.swf?keyword=\2" width="426" height="350"></embed>' ]
    }

    # Tags in this list are invoked. To deactivate a particular tag, call BBCodeizer.deactivate.
    # These names correspond to either names above or methods in this module.
    TagList = [ :bold, :italic, :underline, :email_with_name, :email_sans_name, 
                :url_with_title, :url_sans_title, :image, :size, :color,
                :code, :quote, :youtube, :googlevid, :flash, :spoiler, :nsfw, :mp3, 
                :superdeluxe, :comedycentral, :revver, :myspacetv, :collegehumor,
                :metacafe, :yahoovid, :gametrailers, :atomfilms ]

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
        string.gsub!(*Tags[tag])
      end
    end
    alias_method :apply_tag, :apply_tags
  end
end