#encoding: UTF-8

require 'nokogiri'

module NewsFetch
  class News
    attr_accessor :title, :body, :url, :description, :id, :topic

    def initialize(*args)
      @id, @url, @title, @description, @body, @topic = args
    end

    def parse_news!(page)
      @body = ''
      if(page.at_css('div.article'))
        page = page.css('div.story-body div.article p')
      else
        page = page.css('div.story-body p')
      end
      page.each { |child| @body << clear_line(child) }
    end

    private
    def clear_line(line)
      return (line.content.strip().gsub(/\s+/, ' ').gsub('&', 'and')+ "\n")
    end
  end
end
