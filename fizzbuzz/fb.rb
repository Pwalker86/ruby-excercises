def fizz?(num)
  return true if num % 3 == 0

  false
end

def buzz?(num)
  return true if num % 5 == 0

  false
end

def fizzbuzz?(num)
  if fizz?(num) && buzz?(num)
    'FizzBuzz'
  elsif fizz?(num)
    'Fizz'
  elsif buzz?(num)
    'Buzz'
  end
end

# result = []
#
# 1.upto(100) do |num|
#   result << fizzbuzz?(num)
# end
#
# puts result.compact
