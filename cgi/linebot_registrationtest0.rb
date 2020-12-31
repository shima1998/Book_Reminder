#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require "cgi"
require "uri"
require "json"
require "net/http"
require "mysql2"
require "../storage"

puts <<-EOS                                                                                                              
Content-type: text/html\n\n

linebot
EOS

client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

data = CGI.new()
dValue = data.keys#LINEAPIで使うJSONが格納されてる
dJson = JSON.parse(dValue[0])
replyToken = dJson['events'][0]['replyToken']
userID = dJson["events"][0]["source"]["userId"]
regiCode = dJson["events"][0]["message"]["text"]
canGetInclude = "true"

toUserResponse = "Undefined"

channelAccessToken = $_CAT

targetUri = "https://api.line.me/v2/bot/message/reply"

uri = URI.parse(targetUri)#OK

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true #HTTPS 使う場合は trueを毎回設定

request = Net::HTTP::Post.new(uri)
request["Content-Type"] = "application/json"
request["Authorization"] = "Bearer #{channelAccessToken}"

lineDBs = client.query("select * from LINEID_test;")

if regiCode.include?("登録:") then 
  subject = regiCode.delete("登録:")
  
  lineDBs.each do |lineDB|#重複がないか確認して重複したらFalse
    if lineDB["ID"] == userID || lineDB["USER"] == subject then
      canGetInclude = "false"
    end
  end

  if canGetInclude == "true" then
    client.query("insert into LINEID_test values(\"#{subject}\",\"#{userID}\");")
    toUserResponse = "You can regist ID!"
  elsif canGetInclude == "false" then
    toUserResponse = "You can't regist ID..."
  else
    toUserResponse = "Error"
  end


  reqBody = {"replyToken"=>"#{replyToken}","messages"=>[{"type"=>"text","text"=>toUserResponse.to_s}]}

  request.body = reqBody.to_json
  res = http.request(request)

elsif regiCode.include?("書籍:") then
  subject = regiCode.delete("書籍:")
  bookLists = client.query('select * from test_book1;')
=begin
  bookLists.each do |bookList|
    if bookList["Name"] == subject then
      bookName = bookList["Name"].to_s
      status = bookList["Status"].to_s
      bookRevName = bookList["ReviewName"].to_s
      bookRevPoint = bookList["ReviewPoint"].to_s
  end
=end
  reqBody = {"replyToken"=>"#{replyToken}","messages"=>[{"type"=>"text","text"=>"書籍"}]}
  request.body = reqBody.to_json
  res = http.request(request)
else
  reqBody = {"replyToken"=>"#{replyToken}","messages"=>[{"type"=>"text","text"=>"本は読んでますか?"},{"type"=>"text","text"=>"https://mimalab.c.fun.ac.jp/b1017216/Book_Reminder/BookList.html"}]}
  request.body = reqBody.to_json
  res = http.request(request)
end

=begin
if regiCode.include?("登録:") then#何が起きたのか返したい
  if canGetInclude == "true" then
    toUserResponse = "You can regist ID!"
  elsif canGetInclude == "false" then
    toUserResponse = "You can't regist ID..."
  else
    toUserResponse = "Error"
  end
else 
  toUserResponse = "Please, registration code."
end
=end

=begin
f=File.open("test_stdin.txt", "w")
f.write("bool:" + canGetInclude + "\n")
f.write("UserID:" + userID.to_s + "\n")
f.write("Code:" + regiCode.to_s + "\n")
#    f.write("DBs:" + lineDBs[3]["USER"].to_s + "\n")
f.write("subject:" + subject.to_s + "\n")
f.close
=end
