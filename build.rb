require 'rss'
require 'open-uri'

# favicon
  # www.google.com/s2/favicons?domain=zenn.dev
  # www.google.com/s2/favicons?domain=qiita.com

  zenn = 'https://zenn.dev/masaino/feed'
  qiita1 = 'https://qiita.com/narutaro/feed'
#  qiita2 = 'https://qiita.com/narutaro/feed.atom'

#urls = [zenn, qiita1] 
#urls = [qiita1] 
urls = [zenn] 

def parse_atom(rss)
  p rss.class
  puts "rss----------------------------------------------------------------------------------------------------------"
  puts rss.version
  puts rss.updated.content
  puts rss.title.content
  puts rss.lang
  puts rss.feed_type
  puts rss.feed_version
  puts rss.id.content
  puts rss.encoding
  puts rss.link.href
  puts rss.link.type
  puts "rss.entries---------------------------------------------------------------------------------------------------------"
  rss.entries.each do |entry|
    p entry.title.content
    p entry.link.href
    p entry.content.content
    p entry.updated.content
    p entry.published.content
    p entry.author.name.content
    p entry.id.content
  end
end

def parse_rss(rss)
=begin
  p rss.class
  puts "rss----------------------------------------------------------------------------------------------------------"
  puts rss.version
  puts rss.feed_type
  puts rss.feed_version
  puts rss.encoding
  #puts rss.generator
  puts "rss.channel----------------------------------------------------------------------------------------------------------"
  puts rss.channel.description
  puts rss.channel.image.title
  puts rss.channel.image.link
  puts rss.channel.image.url
  puts "rss all----------------------------------------------------------------------------------------------------------"
=end
  pp rss
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
