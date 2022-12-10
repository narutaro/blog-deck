require 'rss'
require 'open-uri'
require 'erb'
require 'uri'
require 'date'

# favicon
  # www.google.com/s2/favicons?domain=zenn.dev
  # www.google.com/s2/favicons?domain=qiita.com

zenn = 'https://zenn.dev/masaino/feed'
qiita = 'https://qiita.com/narutaro/feed'
hashnode = 'https://senzu.hashnode.dev/rss.xml'
urls = [zenn, qiita, hashnode] 
#urls = [zenn, qiita] 

config = {
  gravater: 'https://2.gravatar.com/userimage/73769069/6a402895e21ba364812a7b6c655f0b73'
}

class Blog

  def initialize
    @posts = [] 
  end

  attr_reader :posts

  def parse_atom(rss)
    rss.entries.each do |entry|
      post = {}
      post[:title] = entry.title.content 
      post[:content] = format_content(entry.content.content)
      post[:link] = entry.link.href 
      post[:host] = URI.parse(post[:link]).host
      post[:updated] = format_date(entry.updated.content) 
      post[:published] = format_date(entry.published.content)
      post[:author] = entry.author.name.content 
      post[:id] = entry.id.content 
      @posts << post
    end
  end

  def parse_rss(rss)
    rss.channel.items.each do |item|
      post = {}
      post[:title] = item.title
      post[:content] = format_content(item.description)
      post[:link] = item.link
      post[:host] = URI.parse(post[:link]).host
      post[:updated] = nil
      post[:published] = format_date(item.pubDate)
      post[:author] = item.dc_creators[0].content
      post[:id] = nil
      @posts << post
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

  def format_date(date_string)
    date_string.strftime("%Y-%m-%d")
  end

  def format_content(content)
    # remove \n
    content = content.gsub("\n", " ")
    # remote URLs
    URI.extract(content) do |u|
      content = content.gsub(u, "")
    end
    # remove HTML tags
    content = content.gsub(/<\/?[^>]*>/, "")
    # make it less than 100 charactor
    content.slice(0, 100) + " ..."
  end

end

rssp = Blog.new
rssp.run_rss_parse(urls)

posts = rssp.posts.sort_by{ |entry| entry[:published] }.reverse
# pp posts

#template = "index.erb"
erb = ERB.new(File.read("index.erb"))
File.write("index.html", erb.result(binding))
#puts erb.result(binding)
