# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../math_adventures/problem_generator'
require_relative '../math_adventures/problem'

class FlashcardTest < Minitest::Test
  def test_can_generate_addition_problem_with_word
    problem = ProblemGenerator.instance.generate_problem('addition')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '+'
    assert problem.answer.is_a?(Integer)
  end
end
