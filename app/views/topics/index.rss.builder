xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@settings.title}: Forum"
    xml.description "#{@settings.tagline}"
    xml.link forum_root_url
    for item in @topics
      xml.item do
        xml.title item.title
        xml.description bb(item.posts.first.body)
        xml.author(item.user)
        xml.pubDate item.created_at.utc.to_s(:rfc822)
        xml.link topic_url(item)
        xml.guid topic_url(item)
      end
    end
  end if @topics
end