require 'escargot'

ActiveRecord::Base.class_eval do
  include Escargot::ActiveRecordExtensions
end

ElasticSearch::Api::Hit.class_eval do
  include Escargot::HitExtensions
end

ElasticSearch::Client.class_eval do
  include Escargot::AdminIndexVersions
end

config_file = Rails.root.join("config", "elasticsearch.yml")

unless File.exists?(config_file)
  Rails.logger.debug "No config/elastic_search.yaml file found, connecting to localhost:9200"
  $elastic_search_client ||= ElasticSearch.new("http://localhost:9200", :timeout => 2)
else
  config = YAML.load_file(config_file)
  
  if config = config[Rails.env]
    host = config["host"]
    port = config["port"]
    timeout = config["timeout"]
  end
  
  host    ||= "localhost"
  port    ||= "9200"
  timeout ||= 20
  
  $elastic_search_client ||= ElasticSearch.new("#{host}:#{port}", :timeout => timeout)
end