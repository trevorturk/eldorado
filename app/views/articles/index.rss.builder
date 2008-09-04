xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@settings.title}: Blog"
    xml.description "#{@settings.tagline}"
    xml.link blog_url
    for item in @articles
      xml.item do
        xml.title item.title
        xml.description bb(item.body)
        xml.author(item.user)
        xml.pubDate item.created_at.utc.to_s(:rfc822)
        xml.link article_url(item)
        xml.guid article_url(item)
      end
    end
  end if @articles
end