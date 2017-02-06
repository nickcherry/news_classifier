require "#{ File.expand_path(File.dirname(__FILE__)) }/../models/article.rb"
require 'classifier-reborn'
require 'colorize'
require 'pry'

puts "\nOne moment while we train the classifier".cyan

lsi = ClassifierReborn::LSI.new
total_articles = Article.count
Article.all.each_with_index do |article, i|
  puts "...classifying article #{ i + 1 } of #{ total_articles }".cyan
  lsi.add_item article.text, article.source
end

loop do
  puts "\nEnter the text for which you want to find similar articles (or type `exit!` to quit the program):".yellow
  input = gets.chomp
  break if input == 'exit!'
  puts "#{ lsi.find_related(input, 1).first }".green
end
