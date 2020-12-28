const url0 = "./cgi/book_list.rb";
const url1 = "./cgi/test1.rb";
//const url = "./cgi/book_list.rb";

window.addEventListener("load", function(){
    getUserNameFromStorage();
    changeUser();
}, false);

let userName;

function setUserNameToStorage() {
    if (window.localStorage) {
        let user = document.getElementById("userID").value;
        localStorage.setItem("userID", user);
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
      let i;
      let html = "";
      let stat;
      for (i = 0; i < lists.length; i++) {
	let list;
        list = lists[i];
        html += '<div id="bookList" class="menu-box0">' + "\n";
        html += '<form action="./BookInfo.rb" method="post">'
        html += '<input type="submit" class="submit-book" name="book_list" alt="' + list.name + '" value="' + list.ID + '">';
	html += '<input type="hidden" name="book_user" value="' + userName +'">'
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
	console.log(html)
	document.getElementById("list").innerHTML = html;
     };
  };
  xmlHttpReq.send(sendData);
};





