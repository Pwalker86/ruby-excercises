# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../math_adventures/problem_generator'

class ProblemGeneratorTest < Minitest::Test
  def test_can_generate_addition_problem_with_word
    problem = ProblemGenerator.instance.generate_problem('addition')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '+'
    assert problem.answer.is_a?(Integer)
  end

  def test_can_generate_addition_problem_with_symbol
    problem = ProblemGenerator.instance.generate_problem('+')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '+'
    assert problem.answer.is_a?(Integer)
  end

  def test_can_generate_subtraction_problem_with_word
    problem = ProblemGenerator.instance.generate_problem('subtraction')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '-'
    assert problem.answer.is_a?(Integer)
  end

  def test_can_generate_subtraction_problem_with_symbol
    problem = ProblemGenerator.instance.generate_problem('-')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '-'
    assert problem.answer.is_a?(Integer)
  end

  def test_can_generate_multiplication_problem_with_word
    problem = ProblemGenerator.instance.generate_problem('multiplication')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '*'
    assert problem.answer.is_a?(Integer)
  end

  def test_can_generate_multiplication_problem_with_symbol
    problem = ProblemGenerator.instance.generate_problem('*')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '*'
    assert problem.answer.is_a?(Integer)
  end

  def test_can_generate_division_problem_with_word
    problem = ProblemGenerator.instance.generate_problem('division')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '/'
    assert problem.answer.is_a?(Integer)
  end

  def test_can_generate_division_problem_with_symbol
    problem = ProblemGenerator.instance.generate_problem('/')
    assert problem.is_a?(Problem)
    assert problem.operands.is_a?(Array)
    problem.operands.each { |operand| assert operand.is_a?(Integer) }
    assert problem.operator == '/'
    assert problem.answer.is_a?(Integer)
  end

  def raises_error_when_invalid_category
    assert_raises(ArgumentError) { ProblemGenerator.new('invalid') }
  end
end
