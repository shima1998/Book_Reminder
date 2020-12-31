#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require '../storage'

# 取得した値を使い、本の詳細情報を変更するＣＧＩ

data=CGI.new()

bookIndex = data['book_index']
bookId = data['book_user']

#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])



client.query("delete from test_book1 where ID=#{bookIndex} AND USER='#{bookId}';")

print <<-EOS
Content-type: text/html\n\n

<!DOCTYPE html>
<html lang="ja">
<head>
     <meta name="viewport" content="width=device-width,initial-scale=1">
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Update</title>
 <link rel="stylesheet" type="text/css" href="../css/style.css" />
 <link rel="stylesheet" type="text/css" href="../css/home-menu.css" media="screen"/>
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
<h2>完了</h2>

<br>
<a href="../BookList.html"><button>メニューに戻る</button></a>
</p>
</div>
</body>
</html>
EOS
