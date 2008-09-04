@items = @topics
xml.instruct! :xml, :version => "1.0"
xml.feed(:xmlns => "http://www.w3.org/2005/Atom") do |feed|
  feed.title "#{@settings.title}: Forum"
  feed.link :href => request.url
  feed.updated((@items.first.created_at.to_s(:rfc3339) if @items))
  feed.id request.url
  for item in @items do
    feed.entry do |e|
      e.id topic_url(item)
      e.title item.title
      e.content bb(item.posts.first.body)
      e.updated item.updated_at.to_s(:rfc3339)
      e.link :href => topic_url(item)
      e.author { |author| author.name item.user }
    end
  end if @items
end
