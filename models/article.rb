require 'mongoid'

MONGOID_CONFIG_PATH = "#{ File.expand_path(File.dirname(__FILE__)) }/../mongoid.yml"
Mongoid.load! MONGOID_CONFIG_PATH, :development

class Article
  include Mongoid::Document

# Fields
  field :source, type: String
  field :text, type: String
  field :url, type: String

# Indices
  index({ source: 1 })
  index({ url: 1 }, { unique: true })
end
