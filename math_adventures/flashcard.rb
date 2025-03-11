# frozen_string_literal: true

require_relative 'problem_generator_ai'
require_relative 'problem_generator'
require_relative 'problem_checker'

class FlashCard
  attr_reader :category, :problem

  def initialize(category, category_symbol, grade)
    @category = category
    @category_symbol = category_symbol
    @grade = grade
    @problem = ProblemGeneratorAI.instance.generate_problem(@category, @category_symbol, @grade)
  end

  def print
    puts @problem.print
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
