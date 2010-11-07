# encoding: utf-8
#
# zad. 2

module Debug
  def snapshot
    puts "Stan obiektu klasy #{self.class}"
    for iv in self.instance_variables
      puts "#{iv} = #{self.instance_variable_get(iv)}"
    end
  end
  def check
    self.methods.select { |m| m[0, 5] == 'test_' }.collect { |mm| "#{mm}: #{send(mm)}" }
  end
end

class Device
  include Debug
  def initialize(name = nil)
    @name = name
  end
  def test_name # should have name (and it should be String)
    if not @name.is_a? String
      "Failed"
    else
      "Passed"
    end
  end
end

d = Device.new("lol")
puts 'Dev 1:', d.check
e = Device.new
puts 'Dev 2:', e.check
