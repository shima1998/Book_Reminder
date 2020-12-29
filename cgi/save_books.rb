#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require '../storage'

data=CGI.new()

name = data['book_name']
status = data['book_status']
reviewName = data['book_review_name']
reviewPoint = data['book_review']
impressions = data['book_impression']
userId = data['book_user']

today = Date.today

#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])


productResults = client.query("select * from test_book1;")

client.query("insert into test_book1 values(1, '#{userId}','#{name}', #{status}, '#{reviewName}', #{reviewPoint}, '#{impressions}','#{today}');")

print <<-EOS
Content-type: text/html\n\n

完了!
EOS
