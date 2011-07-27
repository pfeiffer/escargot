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

$elastic_search_client ||= ElasticSearch.new("localhost:9500", :timeout => 2, :transport => ElasticSearch::Transport::Thrift)