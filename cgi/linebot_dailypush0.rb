#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require "cgi"
require "uri"
require 'cgi'
require "json"
require "net/http"
require "../storage"
require 'mysql2'

# Only receive POST_Data
# I want to receive POST_Data from CGI, but I couldn't get String. I get string "#<CGI:~~~~~>" from CGI only.

=begin
data = CGI.new()
bookUser = data['book_user']
=end
today = Date.today

client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

channelAccessToken = $_CAT

targetUri = "https://api.line.me/v2/bot/message/push"

uri = URI.parse(targetUri)#OK

http = Net::HTTP.new(uri.host, uri.port)#
http.use_ssl = true #HTTPS 使う場合は trueを毎回設定

request = Net::HTTP::Post.new(uri)
request["Content-Type"] = "application/json"
request["Authorization"] = "Bearer #{channelAccessToken}"


productResults = client.query('select * from LINEID_test;')

productResults.each do |productResult|
  userName = productResult["USER"].to_s
  userID = productResult["ID"].to_s

  todayPages = client.query("select Pages from pages_book where USER=\"#{userName}\"&&Date=\"#{today}\";")
  todayPagesSum = 0
  
  todayPages.each do |todayPage|
    todayPagesSum+=todayPage["Pages"]
  end

  if todayPagesSum==0 then
    reqBody = {"to"=>"#{userID}","messages"=>[{"type"=>"text","text"=>"今日はまだ本を読んでいないみたいです。\n１ページだけでも読んでみませんか?"}]}
    request.body = reqBody.to_json
    res = http.request(request)
  else
    reqBody = {"to"=>"#{userID}","messages"=>[{"type"=>"text","text"=>"今日も順調に本を読んでいますね!\nこの調子で読んでいきましょう!"}]}
    request.body = reqBody.to_json
    res = http.request(request)
  end
end

#認証用
print <<-EOF
Content-type: text/html\n\n

linebot
EOF


usrID = ""

reqBody = {"to"=>"#{usrID}","messages"=>[{"type"=>"text","text"=>"あ"}]}

request.body = reqBody.to_json
#http.request(request)
res = http.request(request)

#以下確認用
f=File.open("test_pushtest.txt", "w")
    f.write("ChannelAccessToken:" + channelAccessToken + "\n")
#    f.write("length:" + (dValue.length).to_s + "\n")
    f.write("targetURI:" + targetUri + "\n")
    f.write("URIHost:" + uri.host.to_s + "\n")
#    f.write("hashTest:" + reqBody0["second"][1]["rep"] + "\n")
    f.write("UserID: " + reqBody["to"] + "\n")
    f.write("HashToJson: " + reqBody.to_json + "\n")
    f.write("Content-Type: " + request["Content-Type"] + "\n")
    f.write("Authorization: " + request["Authorization"] + "\n")
    f.write("reqBody: " + request.body.to_s + "\n")
    f.write("resCode: " + res.code.to_s + "\n")
    f.write("resBody: " + res.body.to_s + "\n")
    f.write("resMsg: " + res.message.to_s + "\n")
    f.write("resEntity: " + res.entity.to_s + "\n")
    f.write("resValue: " + res.value.to_s + "\n")
f.close

