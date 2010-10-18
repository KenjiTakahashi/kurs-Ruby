# encoding: utf-8

# zad. 2

class MorseTree
  attr_accessor :left, :right, :value

  def initialize(v = nil)
    @left = nil
    @right = nil
    @value = v
    @@list = []
    @path = ""
    @temp = [ # Magic, don't touch!
      ['E','T'], ['I','A'], ['S','U'], ['H','V'],
      ['5','4'], nil,nil, ['Ś','3'], nil,nil,
      ['F','ü'], ['Ę',nil], nil,nil, ['','2'],
      nil, ['?','_'], nil,nil, ['R','W'],
      ['L','Ą'], [nil,''], nil, ['"',nil],
      nil,nil, ['+',nil], [nil,'.'], nil,nil,nil,
      ['P','J'], [nil,''], nil, ['@',nil],
      nil,nil, [nil,'1'], nil, ["'",nil],
      nil,nil, ['N','M'], ['D','K'], ['B','X'],
      ['6','='], [nil,'-'], nil,nil,nil, ['/',nil],
      nil,nil, ['C','Y'], ['Ć',''], nil,
      [';','!'], nil,nil, ['(',nil], [nil,')'],
      nil,nil,nil, ['G','O'], ['Z','Q'], ['7',''],
      nil, [nil,','], nil,nil, [nil,'Ń'],
      nil,nil, ['Ó','CH'], ['8',nil], [':',nil],
      nil,nil,nil, ['9','0'], nil,nil
    ]
  end
  def fill(t = self)
    v = @temp.shift
    if v and t
      t.insert_left(v[0]) if v[0]
      t.insert_right(v[1]) if v[1]
      fill(t.left)
      fill(t.right)
    end
  end
  def decode(morse_string)
    sentence = ""
    for strings in morse_string.split('/')
      for s in strings.split(' ')
        sentence << find_letter(s.split(''))
      end
      sentence << ' '
    end
    return sentence.chop
  end
#  def encode(normal_string)
#    morse = ""
#    for strings in normal_string.split(' ')
#      for s in strings.split('')
#        morse << find_code(s)
#      end
#      morse << '/'
#    end
#    return morse
#  end
  def order(t = self)
    @@list << t.value
    if t.left
      in_order(t.left)
    end
#    @@list << t.value
    if t.right
      in_order(t.right)
    end
#    @@list << t.value
    return @@list
  end
protected
  def insert_left(v)
    @left = MorseTree.new(v)
  end
  def insert_right(v)
    @right = MorseTree.new(v)
  end
  def find_letter(s, v = self)
    ss = s.shift
    if ss
      if ss == '*'
        find_letter(s, v.left)
      elsif ss == '-'
        find_letter(s, v.right)
      else
        raise UndefinedSymbol
      end
    else
      return v.value
    end
  end
end

mt = MorseTree.new
mt.fill
#print mt.order
#puts
puts mt.decode('*- *-** */*--- *- *--- *-')
