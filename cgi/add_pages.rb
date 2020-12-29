#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require '../storage'

data=CGI.new()
userId = data['book_user']
pages = data['pages']
today = Date.today

#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

client.query("insert into pages_book values(\"#{userId}\", \"#{today}\", #{pages});")

print <<-EOS
Content-type: text/html\n\n

Good!
EOS
