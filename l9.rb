# encoding: utf-8
#
# zad. 3

require 'yaml'

class Notatnik
  def initialize(file = 'notepad.pkl')
    @file = file
    if File.exist? file
      @pad = open(file, 'r') { |f| YAML.load(f) }
    else
      @pad = []
    end
  end
  def przegladaj
    results = ''
    for p in @pad
      results << "Nazwa: #{p['name']}\nTelefon: #{p['phone']}\nMail: #{p['mail']}\nGG: #{p['gg']}\n\n"
    end
    results
  end
  def wyszukaj(item, kind = ['name'])
    return "Nie znaleziono" if @pad.empty? or item.empty?
    for p in @pad
      kind.each_with_index do |k, i|
        if p[k] != item[i]
          return "Nie znaleziono"
        else
          @p = p
        end
      end
    end
    return "Nazwa: #{@p['name']}\nTelefon: #{@p['phone']}\nMail: #{@p['mail']}\nGG: #{@p['gg']}"
  end
  def dodaj(name, values)
    @pad << {
      'name' => name,
      'phone' => values['phone'],
      'mail' => values['mail'],
      'gg' => values['gg']
    }
    self.save
    'Dodano'
  end
  def usun(name)
    if @pad.delete(name)
      self.save
      "Usunieto"
    else
      "Nie ma takiego wpisu!"
    end
  end
protected
  def save
    open(@file, 'w') { |f| YAML.dump(@pad, f) }
  end
end

filename = ask_open_file
Shoes.app do
  def clear
    @msg.remove if @msg
    @stack.remove if @stack
  end
  def form
    para "Nazwa:"
    @name = edit_line
    para "Numer telefonu:"
    @phone = edit_line
    para "E-mail:"
    @mail = edit_line
    para "Numer gadu-gadu:"
    @gg = edit_line
  end
  def clear_form
    @name.text = ""
    @phone.text = ""
    @mail.text = ""
    @gg.text = ""
  end
  if filename
    n = Notatnik.new(filename)
  else
    n = Notatnik.new
  end
  self.stack do
    button "Przegladanie" do
      clear
      @stack = para n.przegladaj
    end
    button "Dodawanie" do
      clear
      @stack = stack do
        form
        button "Dodaj" do
          if @name.text.empty?
            @msg.remove if @msg
            @msg = para "Nazwa nie moze byc pusta"
          else
            @msg.remove if @msg
            @msg = para n.dodaj(@name.text,
                         {'phone' => @phone.text,
                           'mail' => @mail.text,
                           'gg' => @gg.text})
            clear_form
          end
        end
      end
    end
    button "Usuwanie" do
      clear
      @stack = stack do
        para "Nazwa rekordu:"
        @name = edit_line
        button "Usun" do
          @msg.remove if @msg
          @msg = para n.usun(@name.text)
        end
      end
    end
    button "Wyszukiwanie" do
      clear
      @stack = stack do
        form
        button "Wyszukaj" do
          @msg.remove if @msg
          @items = Array.new
          @opts = Array.new
          for v in [['name', @name.text],
            ['phone', @phone.text],
            ['mail', @mail.text],
            ['gg', @gg.text]]
            if not v[1].empty?
              @items << v[1]
              @opts << v[0]
            end
          end
          @msg = para n.wyszukaj(@items, @opts)
          clear_form
        end
      end
    end
    button "Wyjscie" do
      exit
    end
  end
end
