require "#{ File.expand_path(File.dirname(__FILE__)) }/../models/article.rb"

Mongoid::Tasks::Database.create_indexes
