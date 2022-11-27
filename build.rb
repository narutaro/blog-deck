require 'rss'
require 'open-uri'
require 'erb'

# favicon
  # www.google.com/s2/favicons?domain=zenn.dev
  # www.google.com/s2/favicons?domain=qiita.com

zenn = 'https://zenn.dev/masaino/feed'
qiita = 'https://qiita.com/narutaro/feed'
urls = [zenn, qiita] 

class Blog

  def initialize
    @posts = {}
  end

  attr_reader :posts

  def parse_atom(rss)
    rss.entries.each_with_index do |entry, i|
      post = {}
      post[:title] = entry.title.content 
      post[:content] = entry.content.content 
      post[:link] = entry.link.href 
      post[:host] = URI.parse(post[:link]).host
      post[:updated] = entry.updated.content 
      post[:published] = entry.published.content 
      post[:author] = entry.author.name.content 
      post[:id] = entry.id.content 
      @posts[i] = post
    end
  end

  def parse_rss(rss)
    rss.channel.items.each_with_index do |item, i|
      post = {}
      post[:title] = item.title
      post[:content] = format_content(item.description)
      post[:link] = item.link
      post[:host] = URI.parse(post[:link]).host
      post[:updated] = nil
      post[:published] = item.pubDate
      post[:author] = item.dc_creators[0].content
      post[:id] = nil
      @posts[i] = post
    end
  end

  def run_rss_parse(urls)
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
  end

  def format_date
  end

  def format_content(content)
    content.delete("\n")
  end

end

rssp = Blog.new
rssp.run_rss_parse(urls)

posts = rssp.posts

#template = "index.erb"
erb = ERB.new(File.read("index.erb"))
File.write("index.html", erb.result(binding))
#puts erb.result(binding)
