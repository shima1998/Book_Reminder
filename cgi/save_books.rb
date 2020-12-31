#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require "uri"
require "json"
require "net/http"
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

userDB = client.query("select ID from LINEID_test where USER=\"#{userId}\"")
userToken = ""

userDB.each do |userD|
   userToken = userD["ID"].to_s
end

channelAccessToken = $_CAT

targetUri = "https://api.line.me/v2/bot/message/push"

uri = URI.parse(targetUri)#OK

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true #HTTPS 使う場合は trueを毎回設定

request = Net::HTTP::Post.new(uri)
request["Content-Type"] = "application/json"
request["Authorization"] = "Bearer #{channelAccessToken}"

reqBody = {"to"=>"#{userToken}","messages"=>[{"type"=>"text","text"=>"「#{name}」が追加されました!\n読んでいきましょう!"}]}

request.body = reqBody.to_json
res = http.request(request)


print <<-EOS
Content-type: text/html\n\n

完了!
EOS
