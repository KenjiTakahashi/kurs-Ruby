# encoding: utf-8
#
# zad. 1

require 'open-uri'

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
      doc = open(page).read
    rescue OpenURI::HTTPError, URI::InvalidURIError, Errno::ETIMEDOUT
      "There was an error with your request"
    else
      doc.scan(/<(img|video|applet).*?(\/>|(\/img|\/video|\/applet)?)/i).size
    end
  end
  def page_summary(page)
    begin
      doc = open(page).read
    rescue OpenURI::HTTPError, URI::InvalidURIError, Errno::ETIMEDOUT
      "There was an error with your request"
    else
      results = []
      if doc =~ /<title>.*?<\/title>/i
        results << "Title: #{$&.gsub(/<.*?title>/i, '')}"
      end
      for res in doc.scan(/<meta.*?\/>/i)
        if res =~ /name/i
          results << self.reg_split(res, 'name')
        elsif res =~ /http-equiv/i
          results << self.reg_split(res, 'http-equiv')
        end
      end
    end
    results
  end
protected
  def reg_split(res, reg)
    tmp = res.split(/#{reg}\s*?=\s*?("|')?/i).last.split(/("|')?\s*?content\s*?=\s*?("|')?/i)
    "#{tmp[0]}: #{tmp.last.gsub(/("|')?\s*?\/?>?/i, '')}"
  end
  def przeglad_aux(start, page, depth, block)
    if depth > 0
      begin
        p start + page
        @cache << page
        doc = open(start + page).read
      rescue OpenURI::HTTPError, URI::InvalidURIError, Errno::ETIMEDOUT
        nil
      else
        for a in doc.scan(/href.*?<\/a>/i)
          l = a.gsub(/(href\s*?=\s*?("|')|("|').*?>.*)/i, '')
          if not l =~ /^(mailto:|http:|https:|www.).*/i and not @cache.include?(l)
            @results << block.call(doc)
            self.przeglad_aux(start, l, depth - 1, block)
          end
        end
      end
    else
      @results
    end
  end
end

p = Przeglader.new
puts p.przeglad('http://www.ii.uni.wroc.pl/cms/', 3, lambda{ |x| return x })
#puts p.page_summary('http://www.thecamels.org/')
#puts p.page_weight('http://www.thecamels.org/')
