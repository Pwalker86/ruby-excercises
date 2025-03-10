# frozen_string_literal: true

require_relative 'flashcard'

CATEGORIES = {
  '+' => 'addition',
  '-' => 'subtraction',
  '*' => 'multiplication',
  '/' => 'division'
}.freeze

puts 'Welcome to Math Adventure!'
puts 'What category would you like to practice? (+, -, *, /)'
category = CATEGORIES[gets.chomp]

puts 'How many questions would you like to answer?'
number_of_questions = gets.chomp.to_i
total_correct = 0

puts 'Here we go!'

number_of_questions.times do
  flash_card = FlashCard.new(category)
  flash_card.generate_and_display_problem
  user_answer = flash_card.user_answer
  result = flash_card.check_answer(user_answer)
  total_correct += 1 if result
  flash_card.display_result(result)
end

puts "You got #{total_correct} out of #{number_of_questions} correct!"
if total_correct == number_of_questions
  puts 'Congratulations! You are a math wizard!'
elsif total_correct >= number_of_questions / 2
  puts 'Good job! You are getting better!'
else
  puts 'Keep practicing!'
end
