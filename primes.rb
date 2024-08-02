def prime_greater_than(num)
  return num if prime?(num)

  prime_greater_than(num + 1)
end

def prime?(num)
  return false if num < 2

  (Math.sqrt(num) - 2).floor.times do |i|
    return false if (num % (i + 2)).eql?(0)
  end
  true
end
