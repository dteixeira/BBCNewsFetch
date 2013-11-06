require 'rsolr'

# Direct connection
solr = RSolr.connect :url => 'http://localhost:8080/solr'

# send a request to /select
# response = solr.get 'select', :params => {:q => 'text' }
# puts response

=begin
File.open("./data.xml", "r") do |file|
  solr.update :data => file.read
end
=end

# response = solr.get 'select', :params => { :q => 'id:123456' }
# if response['response']['numFound'] == 1
#  solr.add :id => '123456', :title => 'This is my title, this is my text!', :topic => response['response']['docs'][0]['topic'] << 'world'
# else
#  solr.add :id => '123456', :title => 'This is my title, this is my text!', :topic => 'uk'
# end
solr.add :id => '123456', :title => 'I haz wifi.', :topic => 'cats'
solr.commit
