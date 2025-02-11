# frozen_string_literal: true

# Represents an item in the sliding window algorithm.
class Item
  attr_accessor :price, :quantity

  def initialize(price, quantity)
    @price = price
    @quantity = quantity
  end

  def to_s
    "Price: #{@price}, Quantity: #{@quantity}"
  end
end

def generate_items_array(size)
  items = []
  size.times do
    price = rand(1..100) # Random price between 1 and 100
    quantity = rand(1..10) # Random quantity between 1 and 10
    items << Item.new(price, quantity)
  end
  items
end

# items = generate_items_array(100)

def find_max_subarray(items, property, k)
  return nil if items.empty? || items.length < k

  max_sum = 0
  max_window = []

  items.each_cons(k) do |window|
    sum = window.sum { |item| item.send(property) }
    next unless sum > max_sum

    max_sum = sum
    max_window = window
  end

  max_window
end

# puts 'Initial items:'
# puts items
#
# puts 'Item quantities:'
# puts find_max_subarray(items, 'quantity', 5)
#
# puts 'Item prices:'
# puts find_max_subarray(items, 'price', 5)
