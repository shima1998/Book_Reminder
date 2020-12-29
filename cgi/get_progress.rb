#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require '../storage'

data=CGI.new()
userId = data['user_id']

#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

productResults = client.query("select * from pages_book where USER='#{userId}';")

print <<-EOS
Content-type: text/html\n\n
EOS

print "[\n"
productResults.each do |productResult|
    print "{\n"
    print "\"date\": " + "\"" + productResult["Date"].to_s + "\",\n"
    print "\"pages\": " + "\"" + productResult["Pages"].to_s + "\"\n"
    print "},\n"
end

print "{}]\n"
