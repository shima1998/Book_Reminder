#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require './storage'

data=CGI.new()

bookIndex = data['book_list']
bookId = data['book_user']

#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

client.query("set @index=0;")
client.query("update test_book1 set ID=(@index := @index + 1) where USER='#{bookId}';")
productResults = client.query("SELECT * FROM test_book1 where USER='#{bookId}';")

print <<-EOS
Content-type: text/html\n\n

<!DOCTYPE html>
<html lang="ja">
<head>
     <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>BookList</title>
    <link rel="stylesheet" type="text/css" href="./css/style.css">
    <link rel="stylesheet" type="text/css" href="./css/home-menu.css">
</head>
<body>

<header>
     <div class="global-menu">
      <ul>
        <a href="./BookList.html"><li>Home</li></a>
        <a href="./BookChart.html"><li>Data</li></a>
        <a href="./BookChart.html"><li>Helps</li></a>
	<li style="background-color: rgb(68, 68, 68)"><form method="post" id="user"><input type="text" id="userID" name="user_id" value=""></form></li>
	<li style="background-color: rgb(68, 68, 68)"><button type="button" id="button" onclick="changeUser()">Login</button></li>
      </ul>
    </div>
</header>

<div id="bookInfo" class="main">
<a href="./BookList.html"><button>戻る</button></a>
EOS

puts "#{bookIndex}"

productResults.each do |productResult|
    if productResult["ID"].to_s=="#{bookIndex}" then
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

<form action="./ChangeInfo.rb" method="post">
<input type="hidden" name="book_user" value="#{bookId}">
<button type="submit" class="submit-book" name="book_value" alt="編集する" value="#{bookIndex}">
編集する
</button>
</form>

</div>
<footer>
</footer>
</body>
</html>
EOS
