# encoding: utf-8
#
# zad. 1

require 'open-uri'
require 'hpricot'

class Przeglader
  def initialize
    @cache = []
    @results = []
  end
  def przeglad(start_page, depth, block)
    self.przeglad_aux(start_page + '/', '', depth, block)
    @results
  end
  def page_weight(page)
    begin
      doc = Hpricot(open(page))
    rescue OpenURI::HTTPError, URI::InvalidURIError, Errno::ETIMEDOUT
      "There was an error with your request"
    else
      (doc/'img').size + (doc/'video').size + (doc/'applet').size
    end
  end
  def page_summary(page)
    begin
      doc = Hpricot(open(page))
    rescue OpenURI::HTTPError, URI::InvalidURIError, Errno::ETIMEDOUT
      "There was an error with your request"
    else
      doc = Hpricot((doc/'head').inner_html)
      results = ["Title: #{doc.at('title').inner_html}"]
      (doc/'meta').each do |d|
        if d['http-equiv']
          results << "#{d['http-equiv']}: #{d['content']}"
        else
          results << "#{d['name']}: #{d['content']}"
        end
      end
    end
    results
  end
protected
  def przeglad_aux(start, page, depth, block)
    if depth > 0
      begin
        p start + page
        @cache << page
        h = open(start + page)
      rescue OpenURI::HTTPError, URI::InvalidURIError, Errno::ETIMEDOUT
        nil
      else
        doc = Hpricot(h)
        (doc/'a').map { |link| link['href'].to_s }.each do |l|
          if not l =~ /^(mailto:|http:|https:|www.).*/i and not @cache.include?(l)
            @results << block.call(h.read)
            self.przeglad_aux(start, l, depth - 1, block)
          end
        end
      ensure
        h.close if h
      end
    else
      @results
    end
  end
end

p = Przeglader.new
#puts p.przeglad('http://www.ii.uni.wroc.pl/cms/', 3, lambda{ |x| return x })
#puts p.page_summary('http://www.thecamels.org/')
puts p.page_weight('http://www.thecamels.org/')
