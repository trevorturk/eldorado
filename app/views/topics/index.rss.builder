xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@settings.title}: Forum"
    xml.description "#{@settings.tagline}"
    xml.link formatted_topics_url(:rss)
    for item in @topics
      xml.item do
        xml.title item.title
        xml.description bb(item.posts.first.body)
        xml.author(item.user)
        xml.pubDate item.created_at.to_s(:rfc822)
        xml.link topic_url(item)
        xml.guid formatted_topic_url(item, :rss)
      end
    end
  end if @topics
end