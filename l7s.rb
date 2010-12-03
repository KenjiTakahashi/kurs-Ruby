# encoding: utf-8
#
# zad. 1 server

require 'yaml'
require 'drb'

class Logger
  def initialize
    @file = 'log.pkl'
    if File.exist? @file
      @log = open(@file, 'r') { |f| YAML.load(f) }
    else
      @log = {}
    end
  end
  def save(id, msg)
    if @log.has_key? id
      @log[id][Time.now] = msg
    else
      @log[id] = { Time.now => msg }
    end
    open(@file, 'w') { |f| YAML.dump(@log, f) }
    "Saved"
  end
  def report(from, to, id, re)
    results = "<html>\n<body>\n"
    if @log.has_key? id
      for k, v in @log[id]
        if k >= from and k <= to and @log[id][k] =~ re
          results += "<div>" + k.to_s + ": " + @log[id][k] + "</div>\n"
        end
      end
    end
    results += "</body>\n</html>"
  end
  def Logger.run
    @@server = Logger.new
    DRb.start_service('druby://localhost:6666', @@server)
    DRb.thread.join
  end
end

Logger.run
