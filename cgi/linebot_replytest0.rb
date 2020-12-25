#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require "cgi"
require "uri"
require "json"
require "net/http"
require "../storage"

# Only receive POST_Data
# I want to receive POST_Data from CGI, but I couldn't get String. I get string "#<CGI:~~~~~>" from CGI only.

print <<-EOF
Content-type: text/html\n\n
linebot
EOF

data = CGI.new()
dValue = data.keys#LINEAPIで使うJSONが格納されてる
dJson = JSON.parse(dValue[0])
replyToken = dJson['events'][0]['replyToken']

reqBody0 = {"first"=>["test","test2"],"second"=>[{"rep"=>"max","rep2"=>"max2"},{"rep"=>"max3","rep2"=>"max4"}], "third"=>"max5"}#テスト用変数

channelAccessToken = $_CAT

targetUri = "https://api.line.me/v2/bot/message/reply"

uri = URI.parse(targetUri)#OK

http = Net::HTTP.new(uri.host, uri.port)#
http.use_ssl = true #HTTPS 使う場合は trueを毎回設定

request = Net::HTTP::Post.new(uri)
request["Content-Type"] = "application/json"
request["Authorization"] = "Bearer #{channelAccessToken}"

reqBody = {"replyToken"=>"#{replyToken}","messages"=>[{"type"=>"text","text"=>"Hello, user"},{"type"=>"text","text"=>"#{replyToken}"}]}

request.body = reqBody.to_json
http.request(request)
res = http.request(request)
