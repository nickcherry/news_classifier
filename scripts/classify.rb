require "#{ File.expand_path(File.dirname(__FILE__)) }/../models/article.rb"
require 'classifier-reborn'
require 'colorize'

puts "\nOne moment while we train the classifier".cyan

sources = Article.distinct(:source)
classifier = ClassifierReborn::Bayes.new(*sources)
total_articles = Article.count
Article.all.each_with_index do |article, i|
  puts "...classifying article #{ i + 1 } of #{ total_articles }".cyan
  classifier.train article.source, article.text
end

loop do
  puts "\nEnter the text you'd like to classify (or type `exit!` to quit the program):".yellow.bold
  input = gets.chomp
  break if input == 'exit!'
  source, score = classifier.classify_with_score(input)
  puts 'Best Guess: '.green + source.green.bold
  puts 'Score: '.green + score.to_s.green.bold
end
