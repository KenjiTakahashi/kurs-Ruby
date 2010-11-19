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
  def wyszukaj(item, kind = 'name')
    for p in @pad
      if p[kind] == item
        return "Nazwa: #{p['name']}\nTelefon: #{p['phone']}\nMail: #{p['mail']}\nGG: #{p['gg']}"
      end
    end
    "Nie znaleziono"
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
      "Usunieto"
    else
      "Nie ma takiego wpisu!"
    end
    self.save
  end
protected
  def save
    open(@file, 'w') { |f| YAML.dump(@pad, f) }
  end
end

puts "Podaj plik notatnika [notatnik.pkl]"
p = gets
if p != "\n"
  n = Notatnik.new(p)
else
  n = Notatnik.new
end
while true
  puts "Dostepne akcje:"
  puts "[1] Przegladanie"
  puts "[2] Dodawanie"
  puts "[3] Usuwanie"
  puts "[4] Wyszukiwanie"
  puts "[5] Wyjscie"
  print "Wybierz opcje: "
  o = gets.to_i
  if o == 5
    break
  elsif o == 1
    puts n.przegladaj
  elsif o == 2
    while true
      print "[Wymagane] Podaj nazwe: "
      name = gets
      if name == "\n"
        puts "Nazwa nie moze byc pusta!"
      else
        break
      end
    end
    print "Podaj number telefonu [0]: "
    phone = gets
    print "Podaj e-mail []: "
    mail = gets
    print "Podaj number gadu-gadu [0]: "
    gg = gets
    puts n.dodaj(name, {'phone' => phone, 'mail' => mail, 'gg' => gg})
  elsif o == 3
    print "Podaj nazwe rekordu do usuniecia: "
    r = gets
    puts n.usun(r)
  elsif o == 4
    while true
      puts "Wybierz kryterium: "
      puts "[1] Nazwa"
      puts "[2] Telefon"
      puts "[3] E-mail"
      puts "[4] Gadu-gadu"
      puts "[5] Wyjscie"
      print "Wybierz opcje: "
      ko = gets
      if ko == 1
        print "Podaj nazwe: "
        koo = gets
        n.wyszukaj(koo)
      elsif ko == 2
        print "Podaj number telefonu: "
        koo = gets
        puts n.wyszukaj(koo, 'phone')
      elsif ko == 3
        print "Podaj e-mail: "
        koo = gets
        puts n.wyszukaj(koo, 'mail')
      elsif ko == 4
        print "Podaj number gadu-gadu: "
        koo = gets
        puts n.wyszukaj(koo, 'gg')
      elsif ko == 5
        break
      else
        puts "Nieznana opcja"
      end
    end
  else
    puts "Nieznana opcja"
  end
end
