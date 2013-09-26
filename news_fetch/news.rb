require 'nokogiri'

module NewsFetch
  class News
    attr_accessor :title, :body, :url, :description, :id, :topic

    def initialize(*args)
      @id, @url, @title, @description, @body, @topic = args
    end

    def parse_news(page)
      @body = ''
      if(page.css('div.article'))
        page = page.css('div.story-body div.article p')
      else
        page = page.css('div.story-body p')
      end
      page.xpath('//@*').remove
      page.each { |child| @body += clear_line(child) }
    end

    private
    def clear_line line
      line.content.strip().gsub(/\s+/, ' ') + "\n"
    end
  end
end
