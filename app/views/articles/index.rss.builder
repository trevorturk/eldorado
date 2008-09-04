xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@settings.title}: Blog"
    xml.description "#{@settings.tagline}"
    xml.link formatted_articles_url(:rss)
    for item in @articles
      xml.item do
        xml.title item.title
        xml.description bb(item.body)
        xml.author(item.user)
        xml.pubDate item.created_at.to_s(:rfc822)
        xml.link formatted_article_url(item, :rss)
        xml.guid formatted_article_url(item, :rss)
      end
    end
  end if @articles
end