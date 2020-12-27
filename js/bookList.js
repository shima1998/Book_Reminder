const url0 = "./cgi/book_list.rb";
const url1 = "./cgi/test1.rb";
//const url = "./cgi/book_list.rb";

function getJSON() {
  let lists;
  let xmlHttpReq =  new XMLHttpRequest();
  xmlHttpReq.open('GET', url0, true);
  xmlHttpReq.onreadystatechange = function() {
    if (xmlHttpReq.readyState==4) {
      lists = JSON.parse(xmlHttpReq.responseText);
      let i;
      let html = "";
      let stat;
      for (i = 0; i < lists.length; i++) {
	let list;
        list = lists[i];
        html += '<div id="bookList' + String(i+1) + '" class="menu-box0">' + "\n";
        html += '<form action="./BookInfo.rb" method="post">'
        html += '<input type="submit" class="submit-book" name="book_list" alt="' + list.name + '" value="' + String(i+1) + '">';
        html += '<div class="relative-txt">' + "\n";
        html += '<h2>' + list.name + '</h2>' + "\n";
        switch (list.status) {
          case "0": stat = "未着手"; break;
          case "1": stat = "読書中"; break;
          case "2": stat = "読了"; break;
          case "3": stat = "部分読了"; break;
          default: stat = "undefined"; break;
        }
        html += '<p>状態: ' + stat + '</p>';
        html += '<p>' + list.reviewName + ':' + list.reviewPoint + '</p>';
        html += '</div>';
        html += '</form>';
        html += '</div>';
      }
	document.getElementById("list").innerHTML = html;
     };
  };
  xmlHttpReq.send(null);
};

function getData() {
  getJSON();
};

function login(){
    let userID = document.getElementById("user");    
    console.log(userID)
    let sendData = new FormData(userID);
    console.log(sendData.gets('user_id'))
    let lists;
    let xmlHttpReq =  new XMLHttpRequest();

    xmlHttpReq.open('post', url1, true);
    xmlHttpReq.send(sendData);

    xmlHttpReq.onreadystatechange = function() {
	if (xmlHttpReq.readyState==4) {
	            lists = JSON.parse(xmlHttpReq.responseText);
		    let i;
		    let html = "";
		    let stat;
		    for (i = 0; i < lists.length; i++) {
			let list;
			list = lists[i];
			html += '<div id="bookList' + String(i+1) + '" class="menu-box0">' + "\n";
			html += '<form action="./BookInfo.rb" method="post">'
			html += '<input type="submit" class="submit-book" name="book_list" alt="' + list.name + '" value="' + String(i+1) + '">';
			html += '<div class="relative-txt">' + "\n";
			html += '<h2>' + list.name + '</h2>' + "\n";

			switch (list.status) {
			case "0": stat = "未着手"; break;
			case "1": stat = "読書中"; break;
			case "2": stat = "読了"; break;
			case "3": stat = "部分読了"; break;
			default: stat = "エラー"; break;
			}

			html += '<p>状態: ' + stat + '</p>';
			html += '<p>' + list.reviewName + ':' + list.reviewPoint + '</p>';

			html += '</div>';
			html += '</form>';
			html += '</div>';
		    };
		    document.getElementById("list").innerHTML = html;
		};
    };
};


function changeUser(){
 let test = document.getElementById("user");
    console.log(test)

    test2 = {"Key":"Value"}

//    console.log(test2["Key"])
    let res = "fax";
    let XHR =  new XMLHttpRequest();
    let sendData = new FormData(test);//渡せる値はformに限る
//    sendData.append('key0','vux');
  //  sendData.append('key1','vu');
    //sendData.append('key2','vx');
    console.log(sendData.get('key2'));//中身はこの関数でしか見られない
  XHR.open('POST', "./cgi/test0.rb", true);
  //XHR.setRequestHeader("Content-Type", "application/json")

  XHR.send(sendData);
  XHR.onreadystatechange = function() {
    if (XHR.readyState==4) {
	res += XHR.responseText;
     };
   console.log(res)
   document.getElementById("test").innerHTML = res;
  };
//   document.getElementById("test").innerHTML = test;
};

function changeUser1(){
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
      let i;
      let html = "";
      let stat;
      for (i = 0; i < lists.length; i++) {
	let list;
        list = lists[i];
        html += '<div id="bookList' + String(i+1) + '" class="menu-box0">' + "\n";
        html += '<form action="./BookInfo.rb" method="post">'
        html += '<input type="submit" class="submit-book" name="book_list" alt="' + list.name + '" value="' + String(i+1) + '">';
        html += '<div class="relative-txt">' + "\n";
        html += '<h2>' + list.name + '</h2>' + "\n";
        switch (list.status) {
          case "0": stat = "未着手"; break;
          case "1": stat = "読書中"; break;
          case "2": stat = "読了"; break;
          case "3": stat = "部分読了"; break;
          default: stat = "undefined"; break;
        }
        html += '<p>状態: ' + stat + '</p>';
        html += '<p>' + list.reviewName + ':' + list.reviewPoint + '</p>';
        html += '</div>';
        html += '</form>';
        html += '</div>';
      }
	document.getElementById("list").innerHTML = html;
     };
  };
  xmlHttpReq.send(sendData);
};





