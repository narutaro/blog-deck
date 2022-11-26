require 'rss'
require 'open-uri'

# favicon
  # www.google.com/s2/favicons?domain=zenn.dev
  # www.google.com/s2/favicons?domain=qiita.com

zenn = 'https://zenn.dev/masaino/feed'
qiita = 'https://qiita.com/narutaro/feed'
#github = 'https://github.com/narutaro/blog/wiki.atom'
#  qiita2 = 'https://qiita.com/narutaro/feed.atom'

urls = [zenn, qiita] 
#urls = [qiita] 
#urls = [github] 


def parse_atom(rss)
  posts = {}
  p rss.class
=begin
  puts "rss----------------------------------------------------------------------------------------------------------"
  puts rss.version
  puts rss.updated.content
  puts rss.title.content
  puts rss.lang
  puts rss.feed_type
  puts rss.feed_version
  puts rss.id.content
  puts rss.encoding
  puts "rss.link.href: " + rss.link.href
  puts rss.link.type
=end
  rss.entries.each_with_index do |entry, i|
    #puts "rss.entries---------------------------------------------------------------------------------------------------------"
    post = {}
    post[:title] = entry.title.content 
    post[:content] = entry.content.content 
    post[:link] = entry.link.href 
    post[:host] = URI.parse(post[:link]).host
    post[:updated] = entry.updated.content 
    post[:published] = entry.published.content 
    post[:author] = entry.author.name.content 
    post[:id] = entry.id.content 
    #p entry.title.content
    #p entry.link.href
    #p entry.content.content
    #p entry.updated.content
    #p entry.published.content
    #p entry.author.name.content
    #p entry.id.content
    posts[i] = post
  end
  pp posts
end

def parse_rss(rss)
  posts = {}
  p rss.class
=begin
  puts "rss----------------------------------------------------------------------------------------------------------"
  puts rss.version
  puts rss.feed_type
  puts rss.feed_version
  puts rss.encoding
  puts "rss.channel----------------------------------------------------------------------------------------------------------"
  puts rss.channel.description
  puts "rss.channel.generator: " + rss.channel.generator
  puts rss.channel.image.title
  puts rss.channel.image.link
  puts rss.channel.image.url
=end
  rss.channel.items.each_with_index do |item, i|
    #puts "rss.channel.item----------------------------------------------------------------------------------------------------------"
    post = {}
    post[:title] = item.title
    post[:content] = item.description
    post[:link] = item.link
    post[:host] = URI.parse(post[:link]).host
    post[:updated] = nil
    post[:published] = item.pubDate
    post[:author] = item.dc_creators[0].content
    post[:id] = nil
    #puts item.title
    #puts item.description
    #puts item.enclosure.url
    #puts item.guid.content
    #puts item.link
    #puts item.pubDate
    #puts item.dc_creators[0].content
    posts[i] = post
  end
  pp posts
end

urls.each do |url|
  URI.open(url) do |xml|
    rss = RSS::Parser.parse(xml, false)
    case rss.class.to_s
    when 'RSS::Rss' then
      parse_rss(rss)
    when 'RSS::Atom::Feed' then
      parse_atom(rss)
    else
      puts "No match"
    end
  end
end
