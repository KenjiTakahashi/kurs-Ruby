# encoding: utf-8
#
# zad. 1 client

require 'drb'

remote = DRbObject.new_with_uri('druby://localhost:6666')
if remote.respond_to? 'save'
  names = ["name1", "3name", "orand"]
  10.times do
    puts remote.save(names[rand(3)], rand(32**29).to_s(32))
  end
end
puts
if remote.respond_to? 'report'
  puts remote.report(Time.now - 1800, Time.now - 100, names[rand(3)], /^[a-z].*/i)
end
