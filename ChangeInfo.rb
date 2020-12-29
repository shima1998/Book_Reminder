#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require './storage'

data=CGI.new()

bookIndex = data['book_value']
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
        <a href="./BookChart.html"><li>Datas</li></a>
        <a href="./BookChart.html"><li>Helps</li></a>
	<li style="background-color: rgb(68, 68, 68)"><form method="post" id="user"><input type="text" id="userID" name="user_id" value=""></form></li>
	<li style="background-color: rgb(68, 68, 68)"><button type="button" id="button" onclick="changeUser()">Login</button></li>
      </ul>
    </div>
</header>

<div id="bookInfo" class="main">
<a href="./BookList.html"><button>戻る</button></a>
<form action="./cgi/update_book.rb" id="bookNewData" method="get">
EOS

productResults.each do |productResult|
    if productResult["ID"].to_s=="#{bookIndex}" then
        print <<-EOS
        <input type="number" name="book_index" value="#{bookIndex}" style="visibility: hidden;" readonly>
<input type="text" name="book_user" value="#{bookId}" style="visibility: hidden;" readonly>
        <p>タイトル:<input type="text" name="book_name" value="#{productResult["Name"].to_s}" size="40"></p>
            <p>
                状態:<select name="book_status" value=""#{productResult["Status"].to_s}">
                        <option value="0">未着手</option>
                        <option value="1">読書中</option>
                        <option value="2">読了</option>
                        <option value="3">部分読了</option>
                    </select>
            </p>

            <p>
                <h2>評価</h2>
                評価名:<input type="text" name="book_review_name" value="#{productResult["ReviewName"].to_s}" size="40"><br>
                <input type="range" min="0" max="5" value="#{productResult["ReviewPoint"].to_s}" name="book_review">
                <!-- どうやったら改行できる? -->
            </p>

            <p>
                感想:<br>
                <textarea name="book_impression" rows="4" cols="40">#{productResult["Impressions"].to_s}</textarea>
            </p>
        EOS
    end
end

print <<-EOS
<input type="submit" value="決定">
<br>
<br>
<br>
<br>
<br>
<br>
<div class="delete-button">
<button  formaction="./cgi/delete_book.rb" type="submit">削除</button>
</div>
</form>
</body>
</html>
EOS

# なぜかtype submitのボタンを作るとInternalServerError吐いた
