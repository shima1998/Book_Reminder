#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'

data=CGI.new()


#パスはサーバーで入れてね
client = Mysql2::Client.new()

client.query("set @index=0;")
client.query("update test_book set ID=(@index := @index + 1);")
productResults = client.query("SELECT * FROM test_book;")

print <<-EOS
Content-type: text/html\n\n

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <title>BookList</title>
    <link rel="stylesheet" type="text/css" href="./css/style.css">
    <link rel="stylesheet" type="text/css" href="./css/home-menu.css">
</head>
<body>

<header>
    <div class="global-menu">
        <ul>
            <li style="color: coral; background-color:rgb(241, 241, 241);">Home</li>
            <a href="./BookChart.html"><li>Datas</li></a>
            <a href="./BookChart.html"><li>Helps</li></a>
        </ul>
    </div>
</header>

<div id="bookLists" class="default">
EOS

productResults.each do |productResult|
    print <<-EOS
        <div id="bookList#{productResult["ID"].to_s}" class="menu-box0">
        <form action="./BookInfo.rb" method="post">
        <input type="submit" class="submit-book" name="book_list" alt="#{productResult["Name"].to_s}" value="#{productResult["ID"].to_s}">
        <div class="relative-txt">
            <h2>#{productResult["Name"].to_s}</h2>
    EOS
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
        <p>#{productResult["ReviewName"].to_s}:#{productResult["ReviewPoint"].to_s}</p>
        </div>
        </form>
        </div>
        
        
    EOS
end

print <<-EOS
</div>
<footer>
</footer>
</body>
</html>
EOS

# <script text="text/javascript" src="./js/homeMenu.js"></script>
# <script text="text/javascript" src="./js/bookList.js"></script>
# できればヒアドキュメント使いたかったけどヒアドキュメントの中だと演算子使いにくいっぽいからナシで
#!重要!　TEXT型で保存しているImpressionsはJSON.不具合が起きるためとりあえず使用を控えること!!!!!
#データの中に改行がある、データ自体が大きいなど原因は様々考えられるが、確認したところ\rや\nといった文字がデータ内に含まれていることがJSONに良くない影響をもたらしているようだ。
