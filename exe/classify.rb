require "#{ File.expand_path(File.dirname(__FILE__)) }/../models/article.rb"
require 'classifier-reborn'
require 'colorize'
require 'pry'

sources = Article.distinct(:category)

puts "\nOne moment, training the classifier...".cyan

classifier = ClassifierReborn::Bayes.new(*sources)
Article.all.each do |article|
  classifier.train article.category, article.text
end

loop do
  puts "\nEnter the text you'd like to classify (or type `exit!` to quit the program):".yellow
  input = gets.chomp
  break if input == 'exit!'
  puts "#{ classifier.classify(input) }".green
end
