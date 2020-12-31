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
userId = data['book_user']
#userId="A"
pages = data['pages']
#pages = "10"
today = Date.today

#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

client.query("insert into pages_book values(\"#{userId}\", \"#{today}\", #{pages});")

userDB = client.query("select ID from LINEID_test where USER=\"#{userId}\"")
userToken = ""

userDB.each do |userD|
   userToken = userD["ID"].to_s
end

channelAccessToken = $_CAT

print <<-EOS
Content-type: text/html\n\n

EOS

=begin
f=File.open("test_pushtest.txt", "w")
    f.write("ChannelAccessToken:" + channelAccessToken + "\n")
    f.write("UserToken:" + userToken.to_s + "\n")
f.close
=end


targetUri = "https://api.line.me/v2/bot/message/push"

uri = URI.parse(targetUri)#OK

http = Net::HTTP.new(uri.host, uri.port)#
http.use_ssl = true #HTTPS 使う場合は trueを毎回設定

request = Net::HTTP::Post.new(uri)
request["Content-Type"] = "application/json"
request["Authorization"] = "Bearer #{channelAccessToken}"

#userDB = client.query("select ID from LINEID_test where USER=\"#{userId}\"")
#userToken = userDB["ID"].to_s

reqBody = {"to"=>"#{userToken}","messages"=>[{"type"=>"text","text"=>"#{pages}ページ読んだんですね!\nお疲れ様です!"}]}

request.body = reqBody.to_json
res = http.request(request)
