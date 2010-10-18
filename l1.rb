# encoding: utf-8

# zad. 2

def sum(list)
  s = 0
  for l in list
    for i in l
      s += i
    end
  end
  return s
end

puts "zad. 2: #{sum([[1,2],[3,4],[5,6,7]])}"

# zad. 4

def num_to_str(number)
  rep=[
    "jeden",
    "dwa",
    "trzy",
    "cztery",
    "pięć",
    "sześć",
    "siedem",
    "osiem",
    "dziewięć"
  ]
  string = ""
  for i in number.to_s.split("")
    string += rep[i.to_i] + " "
  end
  return string
end

puts "zad. 4: #{num_to_str(123)}"

# zad. 5

def str_to_num(strings)
  rep={
    "zero" => "0",
    "jeden" => "1",
    "dwa" => "2",
    "trzy" => "3",
    "cztery" => "4",
    "pięć" => "5",
    "sześć" => "6",
    "siedem" => "7",
    "osiem" => "8",
    "dziewięć" => "9"
  }
  string = ""
  for s in strings
    string += rep[s]
  end
  return string.to_i
end

puts "zad. 5: #{str_to_num(["jeden", "dwa", "pięć"])}"

# zad. 6

def print_(line, n)
  n.times { print " " }
  print " " if n > 3
  line.each { |l| print " #{l}" }
  puts
end
def pascal_triangle(n)
  line = [1]
  print 0
  print_ line, n
  for i in 0..n - 1
    print i + 1
    next_line = [1]
    for i in 0..line.length - 2
      next_line << line[i] + line[i+1]
    end
    next_line << 1
    line = next_line
    n -= 1
    print_ line, n
  end
end

puts "zad. 6:"
pascal_triangle(8)
