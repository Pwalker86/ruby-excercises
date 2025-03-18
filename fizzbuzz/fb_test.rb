# frozen_string_literal: true

require 'minitest/autorun'
require_relative './fb'

class FizzBuzzTest < Minitest::Test
  def test_fizz_returns_true_if_divisible_by_three
    assert fizz?(3)
    assert fizz?(9)
    assert fizz?(12)
    assert fizz?(99)
  end

  def test_buzz_returns_true_if_divisible_by_5
    assert buzz?(5)
    assert buzz?(25)
    assert buzz?(50)
    assert buzz?(75)
  end

  def test_fizzbuzz_returns_fizz_if_divisible_by_3
    assert_equal 'Fizz', fizzbuzz?(3)
  end

  def test_fizzbuzz_returns_buzz_if_divisible_by_5
    assert_equal 'Buzz', fizzbuzz?(5)
  end

  def test_returns_fizzbuzz_if_divisible_by_5_and_3
    assert_equal 'FizzBuzz', fizzbuzz?(15)
  end
end
