#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require '../storage'

data=CGI.new()

testKeys = data.keys

#パスはサーバーで入れてね

print <<-EOS
Content-type: text/html\n\n
EOS


testKeys.each do |testKey|
  print "key:" + testKey.to_s + "\n"
end


#print data.content_type
print "keys:" + data.keys.to_s + "\n"
print "params:" + data.params.to_s + "\n"


