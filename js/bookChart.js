// 配列に関して、基本はドット記法を使用するが、keyが数字、または変数だった場合はブラケットを使用すること。
let ctx0 = document.getElementById("bookChart0").getContext('2d');
//let ctx1 = document.getElementById("bookChart1").getContext('2d');
// let ctx2 = document.getElementById("bookChart2").getContext('2d');

let bookChart0 = new Chart(ctx0, {
    type: 'bar',
    data: {
        labels: [],
        datasets: [{
            label: 'ページ数',
            data: [],
            backgroundColor: [
            ],
            borderColor: [
            ],
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,//固定アスペクト比の設定
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero:true
                }
            }]
        }
    }
});

/*
let bookChart1 = new Chart(ctx1, {//円グラフ
    type: 'doughnut',
    data: {
        labels: ["a","b","c"],
        datasets: [{
            label: 'ページ数',
            data: [10,10,10,20],
            backgroundColor: [
                'rgb(255, 0, 0)'
            ],
            borderColor: [
            ],
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }//使わないならない方がいい
});*/

function insertArrayForChart(chart, arrayValues, keyLabels, keyValues, bgColor, bdColor){
    //for "Chart.js"
    //DBから送られてくるJSON要素の最後は"{}"という未定義の要素の想定である。
    //グラフの色は、現状最初に引数で設定した1色で固定になります。
    //頻繁に間に挟まっているコメントアウトされたconsole.logは、挙動確認用に残してあります。
    
    let accumulateLabels = [];//最初にすべてのラベル名を格納するための配列

    // arrayValues.forEach(element => {
    //     console.log(element);
    // });
    
    arrayValues.forEach(element => {//#1 最初にlabelを取得
        accumulateLabels.push(element[keyLabels]);
    });

    // console.log(accumulateLabels);

    let refreshLabels = accumulateLabels.filter((element, index, thisElement) =>//#2 重複を削除
						thisElement.findIndex(elm =>
								      elm === element 
								     ) === index
					       );

    refreshLabels.pop();//#3 最後にあるであろう未定義の要素"{}"を削除

    // console.log(refreshLabels);

    refreshLabels.forEach(element => {//#4 ラベルを追加、またラベルの数だけ色も設定する。現状同じ色しか指定できません。
        chart.data.labels.push(element);
        chart.data.datasets[0].backgroundColor.push(bgColor);
        chart.data.datasets[0].borderColor.push(bdColor);
    });

    // console.log(chart.data.labels);
    
    chart.data.datasets[0].data = new Array(chart.data.labels.length).fill(0);//#5 グラフのデータ格納先の確保。 ラベルの数の分要素を作り、全要素を0にする。

    // console.log(chart.data.datasets[0].data.length);
    // console.log(chart.data.datasets[0].data);

    arrayValues.forEach(element => {//#6 グラフにする値のラベルと先ほど格納したラベルを比較し、一致したラベルに対応する位置に値を追加していく。
        chart.data.labels.forEach((elm, idx) => {
            if(element[keyLabels] === elm){//ラベルの比較
                chart.data.datasets[0].data[idx] += Number(element[keyValues]);
                chart.update();
            };
        });  
    });

    // console.log(chart.data.datasets[0].data);


    //要素追加の基本形　ここから色々な追加方法に発展させられるはず
    // arrayValues.forEach(element => {
    //     chart.data.labels.push(element[keyLabels]);
    //     chart.data.datasets[0].data.push(Number(element[keyValues]));
    //     chart.data.datasets[0].backgroundColor.push(bgColor);
    //     chart.data.datasets[0].borderColor.push(bdColor);
    //     chart.update();
    // });

}

function refreshChart(chart){
    let lgh = chart.data.datasets[0].data.length;
    let count;
    for(count = 0; count < lgh; count++){
	chart.data.labels.pop();
	chart.data.datasets.forEach((dataset) => {
            dataset.data.pop();
	});
    };
    chart.update();
};

function averageChart(chart){
    let lgh = chart.data.datasets[0].data.length;
    let count;
    let sum = 0;
    for(count = 0; count < lgh; count++){
	sum+=chart.data.datasets[0].data[count];
    };
    let avg = sum / lgh;
    return avg;
}
function showChart0(){
    setUserNameToStorage();
    refreshChart(bookChart0)
    let userID = document.getElementById("user");
    let sendData = new FormData(userID);
    let XHR = new XMLHttpRequest();

    XHR.open("post", "./cgi/get_progress.rb", true);//タダの設定　
    XHR.send(sendData);
    XHR.onreadystatechange = function(){//データが帰ってきたらどうするか
	if(XHR.readyState == 4){
            // GETした結果を表示する?
            let strXml0 = XHR.responseText;
            let progressData = JSON.parse(strXml0);//date,pages String型で格納されている

            // document.getElementById("test1").innerHTML = progressData[0].date;

            // document.getElementById("test0").innerHTML = progressData[0].pages;

            insertArrayForChart(bookChart0, progressData, 'date', 'pages', 'rgba(75, 192, 192, 0.2)', 'rgba(75, 192, 192, 1)');
            // insertArrayForChart(bookChart1, progressData, 'date', 'pages', 'rgba(75, 192, 192, 0.2)', 'rgba(75, 192, 192, 1)');
            document.getElementById("bookAverage").innerHTML =  averageChart(bookChart0);
	    
	};
    };//最初は素通り　帰ってくるタイミングはこちらで決められない
};

window.addEventListener("load",function(){
    getUserNameFromStorage();
    showChart0();
}, false); 

let userName;

function setUserNameToStorage() {
    if (window.localStorage) {
        let name = document.getElementById("userID").value;
        localStorage.setItem("userID", name);
    }
    userName = getUserNameFromStorage();
    return user;
};


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
};
