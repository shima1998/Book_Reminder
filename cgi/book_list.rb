#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql2'
require 'cgi'
require 'date'
require '../storage'

data=CGI.new()


#パスはサーバーで入れてね
client = Mysql2::Client.new(host: $_dbPath["host"], username: $_dbPath["username"], password: $_dbPath["password"], :encoding => 'utf8', database: $_dbPath["database"][0])

client.query("set @index=0;")
client.query("update test_book set ID=(@index := @index + 1);")
productResults = client.query("SELECT * FROM test_book;")

print <<-EOS
Content-type: text/html\n\n
EOS

#!重要!　TEXT型で保存しているImpressionsはJSON.不具合が起きるためとりあえず使用を控えること!!!!!
#データの中に改行がある、データ自体が大きいなど原因は様々考えられるが、確認したところ\rや\nといった文字がデータ内に含まれていることがJSONに良くない影響をもたらしているようだ。

print "[\n"
productResults.each do |productResult|
    print "{\n"
    print "\"ID\": " + "\"" + productResult["ID"].to_s + "\",\n"
    print "\"name\": " + "\"" + productResult["Name"].to_s + "\",\n"
    print "\"status\": " + "\"" + productResult["Status"].to_s + "\",\n"
    print "\"reviewName\": " + "\"" + productResult["ReviewName"].to_s + "\",\n"
    print "\"reviewPoint\": " + "\"" + productResult["ReviewPoint"].to_s + "\",\n"
    print "\"date\": " + "\"" + productResult["Date"].to_s + "\"\n"
    print "},\n"
    #  "\"name\": " はシングルクオートでくくって '"name": 'と書いてもよい
    #  ruby の文字列に関する記述をしらべてみること
end
# できればヒアドキュメント使いたかったけどヒアドキュメントの中だと演算子使いにくいっぽいからナシで
print "{}]\n"

