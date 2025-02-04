# frozen_string_literal: true

def binary_search(array, target)
  left = 0
  right = array.length - 1

  while left <= right
    mid = (left + right) / 2
    if array[mid] == target
      return mid
    elsif array[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end

  -1
end
