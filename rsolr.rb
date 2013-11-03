require 'rsolr'

# Direct connection
solr = RSolr.connect :url => 'http://localhost:8080/solr'

# send a request to /select
response = solr.get 'select', :params => {:q => '*:*'}
puts response
