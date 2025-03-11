# frozen_string_literal: true

# Problem class
# @operator: [String] the operator for the problem
# @operands: [Array] the operands for the problem
# @answer: [Integer] the answer to the problem
class Problem
  attr_reader :operator, :operands, :correct_answer, :standards

  def initialize(problem_text:, correct_answer:, standards: [])
    @problem_text = problem_text
    @correct_answer = correct_answer
    @standards = standards
  end

  def print
    puts "#{@problem_text}"
  end
end
