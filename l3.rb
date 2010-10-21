# encoding: utf-8

# zad. 2

def pierwsza(n)
  (2..n).select { |i| (2..Math.sqrt(i).ceil).each { |j| i % j == 0 ? break : j } }
end

print pierwsza(128)

puts
# zad. 3

def doskonale(n)
  (6..n).select { |j| j == (1...j).select { |i| j % i == 0 }.inject(0) { |sum, i| sum + i }  }
end

print doskonale(28)

puts
