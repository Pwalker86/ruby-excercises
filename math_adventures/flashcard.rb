# frozen_string_literal: true

require_relative 'problem_generator'
require_relative 'problem_checker'

class FlashCard
  attr_reader :category, :problem

  def initialize(category)
    @category = category
  end

  def generate_and_display_problem
    @problem = ProblemGenerator.instance.generate_problem(@category)
    puts "#{@problem.operands.join(" #{@problem.operator} ")} = ?"
  end

  def user_answer
    gets.chomp.to_i
  end

  def check_answer(user_answer)
    ProblemChecker.correct?(problem: @problem, user_answer: user_answer)
  end

  def display_result(result)
    puts result ? 'Correct!' : 'Incorrect!'
  end
end
