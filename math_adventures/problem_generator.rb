# frozen_string_literal: true

require 'singleton'
require_relative 'problem'
CATEGORIES = %w[addition subtraction multiplication division].freeze
SYMBOL_CATEGORIES = %w[+ - * /].freeze

# ProblemGenerator class
# This class is responsible for generating problems based on the category
# provided by the user.
class ProblemGenerator
  include Singleton
  # rubocop:disable Metrics/MethodLength
  def generate_problem(category)
    case category
    when 'addition', '+'
      generate_addition_problem
    when 'subtraction', '-'
      generate_subtraction_problem
    when 'multiplication', '*'
      generate_multiplication_problem
    when 'division', '/'
      generate_division_problem
    else
      raise ArgumentError, "Unknown category: #{category}"
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  # TODO: This will be expanded once i figure out the CC standards and a reliable way to generate problems according the those standards
  def generate_addition_problem
    operands = Array.new(2) { rand(1..10) }
    answer = operands.sum
    Problem.new('+', operands, answer)
  end

  def generate_subtraction_problem
    a = rand(1..10)
    b = rand(1..a)
    operands = [a, b]
    answer = a - b
    Problem.new('-', operands, answer)
  end

  def generate_multiplication_problem
    operands = Array.new(2) { rand(1..10) }
    answer = operands.reduce(:*)
    Problem.new('*', operands, answer)
  end

  def generate_division_problem
    b = rand(1..10)
    answer = rand(1..10)
    a = b * answer
    operands = [a, b]
    Problem.new('/', operands, answer)
  end
end
