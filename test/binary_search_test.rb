# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../binary_search/binary_search'

class FeaturedIdsTest < Minitest::Test
  def test_can_find_target
    assert_equal 3, binary_search([1, 2, 3, 4, 5], 4)
  end

  def test_returns_negative_one_if_target_not_found
    assert_equal(-1, binary_search([1, 2, 3, 4, 5], 6))
  end
end
