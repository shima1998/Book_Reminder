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

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <title>Booksave</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js"></script>
</head>
<body onload="">
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
<div class="main">
    <h2>書籍登録</h2>
    <!-- <p>input要素がうまく改行できずrange要素が状態選択のすぐ横に来てしまう</p> -->
    <form action="cgi/save_books.rb" id="bookData" method="post">
        <p>
            タイトル:<input type="text" name="book_name" size="40">
        </p>

        <p>
            状態:<select name="book_status">
                    <option value="0">未着手</option>
                    <option value="1">読書中</option>
                    <option value="2">読了</option>
                    <option value="3">部分読了</option>
                </select>
        </p>

        <p>
            <h2>評価</h2>
            評価名:<input type="text" name="book_review_name" size="40"><br>
            <input type="range" min="0" max="5" name="book_review">
            <!-- どうやったら改行できる? -->
        </p>

        <p>
            感想:<br>
            <textarea name="book_impression" rows="4" cols="40"></textarea>
        </p>

        
        <!-- <input type="submit" value="登録"> -->
    </form>

    <button type="button" id="sendData">送信</button>
</div>
    <script src="js/bookSave.js"></script>
    <scripy src="js/bookList.js"></script>
</body>
</html>
EOS
