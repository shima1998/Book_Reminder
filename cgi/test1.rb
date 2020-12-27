#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require '../storage'

data=CGI.new()
userId = data['user_id'].to_s
checkUser = "true"

client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

=begin
userLists = client.query("SELECT USER FROM test_book1;")
userLists.each do |userList|#重複がないか確認して重複したらFalse
  if userList['USER'] == userID then
    checkUser = "false"
  end
end
=end

if checkUser == "true" then

client.query("set @index=0;")
client.query("update test_book1 set ID=(@index := @index + 1) where USER='#{userId}';")
productResults = client.query("SELECT * FROM test_book1 where USER='#{userId}';")

print <<-EOS
Content-type: text/html\n\n
EOS

print "[\n"
productResults.each do |productResult|
  print "{\n"
  print "\"ID\": " + "\"" + productResult["ID"].to_s + checkUser.to_s  + "\",\n"
  print "\"name\": " + "\"" + productResult["Name"].to_s + "\",\n"
  print "\"status\": " + "\"" + productResult["Status"].to_s + "\",\n"
  print "\"reviewName\": " + "\"" + productResult["ReviewName"].to_s + "\",\n"
  print "\"reviewPoint\": " + "\"" + productResult["ReviewPoint"].to_s + "\",\n"
  print "\"date\": " + "\"" + productResult["Date"].to_s + "\"\n"
  print "},\n"
end
print "{}]\n"
elsif checkUser == "false" then
print <<-EOS
Content-type: text/html\n\n
EOS

  print "[\n"
  print "{\n"
  print "\"ID\": \"0\",\n"
  print "\"name\": \"I don't know you.\",\n"
  print "\"status\": \"I don't know you.\",\n"
  print "\"reviewName\": \"I don't know you.\",\n"
  print "\"reviewPoint\": \"0\",\n"
  print "\"date\":\"I don't know you.\" \n"
  print "},\n"
  print "{}]\n"

else
print <<-EOS
Content-type: text/html\n\n
EOS

  print "[\n"
  print "{\n"
  print "\"ID\": \"0\",\n"
  print "\"name\": \"error.\",\n"
  print "\"status\": \"error.\",\n"
  print "\"reviewName\": \"error..\",\n"
  print "\"reviewPoint\": \"0\",\n"
  print "\"date\":\"error.\" \n"
  print "},\n"
  print "{}]\n"


end
