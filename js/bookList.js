const url = "./cgi/book_list.rb";
let list;

function getJSON() {
  let xmlHttpReq =  new XMLHttpRequest();
  xmlHttpReq.open('GET', url, true);
  xmlHttpReq.onreadystatechange = function() {
    if (xmlHttpReq.readyState==4) {
      list = JSON.parse(xmlHttpReq.responseText);
      let i;
      let html = "";
      let stat;
      for (i = 0; i < list.length; i++) {
        o = list[i];
        html += '<div id="bookList' + String(i+1) + '" class="menu-box0">' + "\n";
        html += '<form action="./BookInfo.rb" method="post">'
        html += '<input type="submit" class="submit-book" name="book_list" alt="' + o.name + '" value="' + String(i+1) + '">';
        html += '<div class="relative-txt">' + "\n";
        html += '<h2>' + o.name + '</h2>' + "\n";
        switch (o.status) {
          case "0": stat = "未着手"; break;
          case "1": stat = "読書中"; break;
          case "2": stat = "読了"; break;
          case "3": stat = "部分読了"; break;
          default: stat = "エラー"; break;
        }
        html += '<p>状態: ' + stat + '</p>';
        html += '<p>' + o.reviewName + ':' + o.reviewPoint + '</p>';
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
    let test = document.getElementById("test");
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
