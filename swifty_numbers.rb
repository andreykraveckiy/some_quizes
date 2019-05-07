require 'prime'

class Swifty
  class << self
    def swifty?(number)
      return false if number.zero?
      (number % number.digits.inject(:+)).zero?
    end

    def right_tamable?(number)
      begin
        return false unless swifty?(number)
        number /= 10
      end while number > 10

      true
    end

    def strong?(number)
      return false unless swifty?(number)
      return false unless Prime.prime?(number / number.digits.inject(:+))

      true
    end

    def strong_right_tamable_prime?(number)
      return false unless Prime.prime?(number)
      return false if number < 10

      candidate = number / 10
      return false unless right_tamable?(candidate)
      return false unless strong?(candidate)

      true
    end

    def right_tamables(length = 1)
      return "digits quantity should be greater than 1" if length < 1

      digits = (0..9).to_a
      (1...length).to_a.inject([digits.select { |d| swifty?(d) }]) do |res, iteration|
        res << res.last.product(digits).map { |a, b| a * 10 + b }.select { |num| swifty?(num) }
      end.flatten
    end
  end
end

strong_numbers = Swifty.right_tamables(13).select { |num| Swifty.strong?(num) }
make_prime = strong_numbers.product([1, 3, 7, 9]).map { |a, b| a * 10 + b }

answer = make_prime.select { |num| Swifty.strong_right_tamable_prime?(num) }

answer.inject(:+)

# ar = (1...10 ** 4).select { |num| Swifty.strong_right_tamable_prime?(num) }
# ar.inject(:+)

# unswer = [181, 211, 271, 277, 421, 457, 631, 2011, 2017, 2099, 2473, 2477, 4021, 4027, 4073, 4079, 4231, 4813, 4817, 6037, 8011, 8017, 8039, 8461, 8467]
# 90619
# sum_dig = [9, 3, 6, 11, 13, 18]
# prime_numbers = [2, 7, 3, 5, 67, 19, 37, 47, 89, 73]


# one_ten_7 = [181, 211, 271, 277, 421, 457, 631, 2011, 2017, 2099, 2473, 2477, 4021, 4027, 4073, 4079, 4231, 4813, 4817, 6037, 8011, 8017, 8039, 8461, 8467, 20071, 20431, 40867, 48091, 84061, 84067, 400237, 400277, 4008271, 4860013]
