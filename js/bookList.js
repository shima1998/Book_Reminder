const url0 = "./cgi/book_list.rb";
const url1 = "./cgi/test1.rb";
const url2 = "./cgi/save_books.rb";

let books = 0;

window.addEventListener("load", function(){
    getUserNameFromStorage();
    changeUser();
}, false);

let userName;

function setUserNameToStorage() {
    if (window.localStorage) {
        let name = document.getElementById("userID").value;
        localStorage.setItem("userID", name);
    }
    userName = getUserNameFromStorage();
    return user;
}


function getUserNameFromStorage() {
    let name = null;

    // ますはストレージから読む
    if (window.localStorage) {
        name = localStorage.getItem("userID");
        if (document.getElementById("userID")) {
            document.getElementById("userID").value = name;
        }
	userName = name;
        return name;
    }

    // 登録がなければ画面からデータをとってセットする
    if (name == null) {
        if (document.getElementById("userID")) {
            name = document.getElementById("userID").value;
        }
        localStorage.setItem("userID", name);
	userName = name;
    }

    return name;
}

function changeUser(){
    let user = setUserNameToStorage();
    console.log(user)
    let test = document.getElementById("user");
    console.log(test)
    let sendData = new FormData(test);
    console.log(sendData.get('user_id'));

    let lists;
    let xmlHttpReq =  new XMLHttpRequest();
    xmlHttpReq.open('post', url1, true);
    xmlHttpReq.onreadystatechange = function() {
	if (xmlHttpReq.readyState==4) {
	    lists = JSON.parse(xmlHttpReq.responseText);
	    lists.pop();
	    //lists = listSave.pop();
	    console.log(lists);
	    let clear = 0;
	    let sum = 0;
	    let i;
	    let html = "";
	    let stat;
	    books = lists.length;
	    console.log(books);
	    for (i = 0; i < lists.length; i++) {
		let list;
		list = lists[i];
		switch (list.status) {
		case "0": html += '<div id="bookList' + String(i+1) + '"class="menu-box0" style="background-color: rgb(255, 0, 0, 0.25)">' + "\n"; break;
		case "1": html += '<div id="bookList' + String(i+1) + '"class="menu-box0" style="background-color: rgb(255, 255, 0, 0.25)">' + "\n"; break;
		case "2": html += '<div id="bookList' + String(i+1) + '"class="menu-box0" style="background-color: rgb(0, 255, 0, 0.25)">' + "\n"; break;
		case "3": html += '<div id="bookList' + String(i+1) + '"class="menu-box0" style="background-color: rgb(0, 255, 0, 0.25)">' + "\n"; clear++;break;
		default: stat = "undefined"; break;
		};
		//html += '<div id="bookList' + String(i+1) + '"class="menu-box0">' + "\n";
		html += '<form action="./BookInfo.rb" method="post">'
		html += '<input type="submit" class="submit-book" name="book_list" alt="' + list.name + '" value="' + list.ID + '">';
       		html += '<input type="hidden" name="book_user" value="' + userName +'">'
		html += '</form>';
		html += '<div class="relative-txt">' + "\n";
		html += '<h2>' + list.name + '</h2>' + "\n";
		switch (list.status) {
		case "0": stat = "未着手"; break;
		case "1": stat = "読書中"; break;
		case "2": stat = "読了"; clear++; break;
		case "3": stat = "部分読了"; clear++;break;
		default: stat = "undefined"; break;
		};
		html += '<p>状態: ' + stat + '</p>';
		html += '<p>' + list.reviewName + ':' + list.reviewPoint + '</p>';
		html += '</div>';
		html += '</div>';
		sum++;
	    };
	    console.log(html)
	    document.getElementById("list").innerHTML = html;
	    document.getElementById("clear").innerHTML = clear;
	    document.getElementById("sum").innerHTML = sum;
	    /*for(i = 1; i < lists.length + 1; i++) {
	      let bookId = document.getElementById("bookList" + String(i+1));
	      bookId.addEventListener("click", function(){
	      console.log("クリックされた" + String(i+1));
	      },false);
	      };*/
	};
    };
    xmlHttpReq.send(sendData);
};

function save(){
    let user = getUserNameFromStorage();
    //    let test = document.getElementById("user");
    let save = "";

    save+='<form action="./cgi/save_books.rb" id="addBook" method="post">';
    save+='<input type="text" name="book_user" value="' + user  + '" style="visibility: hidden;" readonly>';
    save+='<p>タイトル:<input type="text" name="book_name" size="40"></p>';

    save+='<p>';
    save+='状態:<select name="book_status">';
    save+='<option value="0">未着手</option>';
    save+='<option value="1">読書中</option>';
    save+='<option value="2">読了</option>';
    save+='<option value="3">部分読了</option>';
    save+='</select>';
    save+='</p>';

    save+='<p>';
    save+='<h2>評価</h2>';
    save+='評価名:<input type="text" name="book_review_name" size="40"><br>';
    save+='評価値(0~5):<input type="number" min="0" max="5" name="book_review" value="0">';
    save+='</p>'

    save+='<p>';
    save+='感想:<br>';
    save+='<textarea name="book_impression" rows="4" cols="40"></textarea>';
    save+='</p>';
    save+='</form>';
    save+='<button type="button" id="sendData" onclick="bookAdd();">送信</button>';
    console.log(save);
    document.getElementById("bookSave").innerHTML = save;
};


function bookAdd(){
    let add = document.getElementById("addBook");
    let sendData = new FormData(add);

    let xmlHttpReq =  new XMLHttpRequest();
    xmlHttpReq.open('post', url2, true);
    xmlHttpReq.send(sendData);
    xmlHttpReq.onreadystatechange = function() {
	if (xmlHttpReq.readyState==4) {
	    document.getElementById("bookSave").innerHTML = xmlHttpReq.responseText;
	};
    };
    changeUser();
};
