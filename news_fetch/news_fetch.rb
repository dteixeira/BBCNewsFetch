# lib requires
require File.join(File.dirname(__FILE__), 'news.rb')

# external requires
require 'nokogiri'
require 'open-uri'
require 'singleton'
require 'json'
require 'thread'

module NewsFetch
  class Fetcher
    include Singleton

    private
    TOPICS_URL = 'http://api.bbcnews.appengine.co.uk/topics'
    TOPICS_ROOT = :topics
    NEWS_URL = 'http://api.bbcnews.appengine.co.uk/stories/'
    NEWS_ROOT = :stories
    URL_WHITE_LIST = %w[www.bbc.co.uk]

    public
    attr_reader :topics, :news

    def initialize
      @topics = nil
      @news = nil
      @lock = Mutex.new
    end

    def fetch_topics
      begin
        # fetch array of topics
        @topics = JSON.parse(Nokogiri::HTML(open(TOPICS_URL)), { :symbolize_names => true })[TOPICS_ROOT]
        @new = {}
        if @topics.empty?
          @topics = nil
          @news = nil
        end
      rescue
        @topics = nil
        @news = nil
      end
      return !!@topics
    end

    def fetch_news topic
      begin
        result = JSON.parse(Nokogiri::HTML(open(NEWS_URL + topic)), { :symbolize_names => true })[NEWS_ROOT]
        @lock.synchronize do
          @news ||= {}
          @news[topic] = []
        end
        result.each do |news|
          next unless URL_WHITE_LIST.any? { |l| news[:link].include?(l) }
          n = News.new(
            news[:link][/[0-9]+(#|$)/].delete('#'),
            news[:link][/^[^\#]*/].delete('#'),
            news[:title],
            news[:description],
            '',
            topic)
          n.parse_news(Nokogiri::HTML(open(news[:link])))
          @lock.synchronize { @news[topic] << n }
        end
      rescue Exception => e
        puts e
        puts e.backtrace
      end
      return @news[topic]
    end

    def fetch_all_news
      if @topics
        threads = []
        @topics.each do |topic|
          t = Thread.new { fetch_news(topic[:id]) }
          threads << t
        end
        threads.each { |thread| thread.join }
      end
      return @news
    end

    def list_all_sources
      counter = {}
      @news.each do |key, topic|
        topic.each do |news|
          url = news.url[/^http:\/\/[^\/]*/]
          counter[url] ||= 0
          counter[url] += 1
        end
      end
      counter
    end
  end
end
