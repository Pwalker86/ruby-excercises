require 'minitest/autorun'
require_relative '../sliding_window/sliding_window'

class TestSlidingWindow < Minitest::Test
  def setup
    @items = [
      Item.new(10, 2),
      Item.new(20, 3),
      Item.new(30, 4),
      Item.new(40, 5),
      Item.new(50, 6)
    ]
  end

  def test_find_max_subarray_quantity
    result = find_max_subarray(@items, 'quantity', 3)
    assert_equal [@items[2], @items[3], @items[4]], result
  end

  def test_find_max_subarray_price
    result = find_max_subarray(@items, 'price', 2)
    assert_equal [@items[3], @items[4]], result
  end

  def test_find_max_subarray_empty
    result = find_max_subarray([], 'price', 2)
    assert_nil result
  end

  def test_find_max_subarray_insufficient_items
    result = find_max_subarray(@items, 'price', 10)
    assert_nil result
  end
end
