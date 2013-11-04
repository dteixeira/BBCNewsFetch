#encoding: UTF-8

# lib requires
require File.join(File.dirname(__FILE__), 'news_fetch', 'news_fetch.rb')

LOG_DIRECTORY = 'news_logs'

# fetch topics (no longer applies)
total_time = 0
=begin
print 'Fetching topics..... '
start = Time.now
NewsFetch::Fetcher.instance.fetch_topics
start = (Time.now - start) * 1000.0
total_time += start
puts start.floor.to_s + ' ms'
=end

# fetch news
print 'Fetching news....... '
start = Time.now
NewsFetch::Fetcher.instance.fetch_all_news_rss
start = (Time.now - start) * 1000.0
total_time += start
puts start.floor.to_s + ' ms'

# write results to file
print 'Saving to file...... '
filename = Time.now.strftime("%Y%m%d%H%M%S") + ".xml"
start = Time.now
File.open(File.join(File.dirname(__FILE__), LOG_DIRECTORY, filename), 'w:UTF-8') do |file|
  file.write(NewsFetch::Fetcher.instance.news_to_xml)
end
start = (Time.now - start) * 1000.0
total_time += start
puts start.floor.to_s + ' ms'

# end and total stats output
puts "\nDone                 " + total_time.floor.to_s + ' ms'
