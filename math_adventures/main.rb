# frozen_string_literal: true

require 'json'
require 'pry'
require_relative 'flashcard'

CATEGORIES = {
  '+' => 'addition',
  '-' => 'subtraction',
  '*' => 'multiplication',
  '/' => 'division'
}.freeze

puts 'Welcome to Math Adventure!'
puts 'What category would you like to practice? (+, -, *, /)'
category_symbol = gets.chomp
category = CATEGORIES[category_symbol]

puts 'What grade are you in?'
grade = gets.chomp.to_i

puts 'How many questions would you like to answer?'
number_of_questions = gets.chomp.to_i
total_correct = 0

flashcards = []

puts 'Here we go!'
puts "Generating #{number_of_questions} questions for #{category} grade #{grade}..."
number_of_questions.times do
  flashcards << FlashCard.new(category, category_symbol, grade)
end

flashcards.each do |flash_card|
  flash_card.print
  user_answer = flash_card.user_answer
  result = flash_card.check_answer(user_answer)
  total_correct += 1 if result
  flash_card.display_result(result)
end

percentage = total_correct / number_of_questions.to_f * 100

puts "You got #{total_correct} out of #{number_of_questions} correct! That's #{percentage}%!"
if total_correct == number_of_questions
  puts 'Congratulations! You are a math wizard!'
elsif percentage >= 80
  puts 'Good job! You are getting better!'
else
  puts 'Keep practicing!'
end

if File.exist?('out.json')
  file = File.read('out.json')
  sessions = JSON.parse(file)
else
  sessions = {}
end

# Ensure the category key exists
sessions[category] ||= {}

# Add the new session data
sessions[category]["grade_#{grade}"] ||= []
sessions[category]["grade_#{grade}"] << {
  total_questions: number_of_questions,
  total_correct: total_correct,
  percentage: percentage
}

# Write the updated data back to the JSON file
File.open('out.json', 'w') do |f|
  f.write(JSON.pretty_generate(sessions))
end
