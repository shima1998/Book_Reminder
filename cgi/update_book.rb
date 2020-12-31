#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require "uri"
require "json"
require "net/http"
require '../storage'


# 取得した値を使い、本の詳細情報を変更するＣＧＩ

data=CGI.new()

bookIndex = data['book_index']
name = data['book_name']
status = data['book_status']
reviewName = data['book_review_name']
reviewPoint = data['book_review']
impressions = data['book_impression']
bookId = data['book_user']

#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

client.query("set @index:=0;")
client.query("update test_book1 set ID=(@index := @index + 1) where USER='#{bookId}';")
client.query("update test_book1 set Name=\"#{name}\", Status=#{status}, ReviewName=\"#{reviewName}\", ReviewPoint=#{reviewPoint}, Impressions=\"#{impressions}\" where ID=#{bookIndex} AND USER='#{bookId}';")
productResults = client.query("SELECT * FROM test_book1 where USER=\"#{bookId}\";")

channelAccessToken = $_CAT

targetUri = "https://api.line.me/v2/bot/message/push"

uri = URI.parse(targetUri)#OK

http = Net::HTTP.new(uri.host, uri.port)#
http.use_ssl = true #HTTPS 使う場合は trueを毎回設定

request = Net::HTTP::Post.new(uri)
request["Content-Type"] = "application/json"
request["Authorization"] = "Bearer #{channelAccessToken}"

userDB = client.query("select ID from LINEID_test where USER=\"#{bookId}\"")
userToken = ""

userDB.each do |userD|
   userToken = userD["ID"].to_s
end

if status == "2" || status == "3" then
  reqBody = {"to"=>"#{userToken}","messages"=>[{"type"=>"text","text"=>"積読が解消されましたね!\nおめでとうございます!"}]}
  request.body = reqBody.to_json
  res = http.request(request)
end

print <<-EOS
Content-type: text/html\n\n

<!DOCTYPE html>
<html lang="ja">
<head>
         <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <link rel="stylesheet" type="text/css" href="../css/style.css" />
 <link rel="stylesheet" type="text/css" href="../css/home-menu.css" media="screen"/>
    <title>Update</title>
</head>
<body>

<header>
<div class="global-menu">
      <ul>
        <a href="../BookList.html"><li>Home</li></a>
        <a href="../BookChart.html"><li>Data</li></a>
        <a href="../BookChart.html"><li>Helps</li></a>
	<li style="background-color: rgb(68, 68, 68)"><form method="post" id="user"><input type="text" id="userID" name="user_id" value=""></form></li>
	<li style="background-color: rgb(68, 68, 68)"><button type="button" id="button" onclick="changeUser()">Login</button></li>
      </ul>
    </div>
</header>
<div class="main">
EOS



productResults.each do |productResult|
   if productResult["ID"].to_s=="#{bookIndex}" then
        print "<h2>完了</h2>"
       print "<h2>#{productResult["Name"].to_s}</h2>"
       
       case productResult["Status"]
       when 0 then
           print "<p>状態: 未着手</p>"
       when 1 then
           print "<p>状態: 読書中</p>"
       when 2 then
           print "<p>状態: 読了</p>"
       when 3 then
           print "<p>状態: 部分読了</p>"
       else
           print "<p>error</p>"
       end

       print <<-EOS
           <p>#{productResult["ReviewName"].to_s}: #{productResult["ReviewPoint"].to_s}</p>
           <h2>感想</h2>
           <p>#{productResult["Impressions"].to_s}</p>
       EOS
   end
end

print <<-EOS
</div>
<br>
<a href="../BookList.html"><button>メニューに戻る</button></a>
</p>
</body>
</html>
EOS
