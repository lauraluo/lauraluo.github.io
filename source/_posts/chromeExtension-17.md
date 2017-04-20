title: Chrome Extension 開發與實作 17
date: 2016-12-31 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# chrome.alarms 定時器API

## 描述

安排程式碼在指定時間一次或週期性執行。


<!--more-->

## 創建定時器

```
ccome.alarms.create(string name, object alarmInfo)
```

* String `name`：定時器的識別名稱，預設為空字串
* Object `alarmInfo`：描述定時器的觸發設定
    * 觸發的時間： 
        * 設定when指定絕對時間
        * 設定 delayInMinutes指定相對於現在的時間
        * 以上二選一
    * 執行周期：設定該periodInMinutes屬性，在觸發之後每隔periodInMinutes再執行一次。

Chrome有規定定時器的觸發周期`最多每分鐘一次`，而且為了效能還有可能會被推遲任意長度，所以delayInMinutes以及periodInMinutes屬性如果設定小於1的值`不被認可`，會產生警告。而When雖然可以設置小於一分鐘之內的未來時間，但定時器至少在一分鐘內不會被執行。

如果你還在地端進行開發，是不會收到定時器的限制頻率警告，但正式發佈的時後就會，這點要注意。

## 取得定時器

```
chrome.alarms.get(string name, function callback)
```

### 取得所有定時器

```
chrome.alarms.getAll(function callback)
```

## 清除定時器

```
chrome.alarms.clear(string name, function callback)
```

### 清除所有定時器

```
`chrome.alarms.clearAll(function callback)`
```

## 事件

當一個定時器到到指定時間時，對於事件腳本很有用(應該是因為可以將閒制時被御載的背景頁面重新載入)。

```
chrome.alarms.onAlarm.addListener(function callback)
```

### Alarm 型別

許多Alarm API都會回傳此型別實例，實例包含以下資訊：

* string name：定時器名稱
* double scheduledTime：該定時器計畫觸發時間這個時間並`不一定等於真正執行的時間`，執行的時間可能因為性能問題被推遲。
* double periodInMinutes：如果不是null的話，代表這個定時器將以該值為間隔觸發。

## 範例

設定檔：

```
{
    "manifest_version" : 2,
    "name" : "API 範例: alarms API",
    "description" : "周期性的執行通知",
    "version" : "2.0",
    "background" : {
        "scripts" : ["event.js"],
        "persistent" : false
    },
    "permissions" : [
        "alarms"
    ]
}
```

事件腳本：

```
var msg = "Hello World!";
var count = 0;
var alarmInfo = {
    //1分鐘之後開始(該值至少大於1) 
    delayInMinutes: 1, 
    //與上方等同的寫法是 
    //when : Date.now() + 6000,
    //開始後每一分鐘執行一次(該值至少大於1) 
    periodInMinutes : 1 
};

//每次加載就清空定時器
chrome.alarms.clearAll();

chrome.alarms.onAlarm.addListener(function(alarm) {
    //計算定時器觸發次數
    console.log("onAlarm-" + ++count);
});
//創造定時器
chrome.alarms.create('testAlarm',alarmInfo);
```


結果：
![http://ithelp.ithome.com.tw/upload/images/20161231/20079450LCrwzhGSqF.png](http://ithelp.ithome.com.tw/upload/images/20161231/20079450LCrwzhGSqF.png)

> 完整程式碼在[Github](https://github.com/lauraluo/ExtensionSample/tree/master/AlarmsAPI)

## 小結

不要搞混javascript內健的setTimeout以及setinterval方法，chrome.alarmsAPI是將程式碼委派給Chrome執行，所以不受限腳本運行的階段。

我們可以用利用chrome.alarmsAPI打造以下服務：

* 定時詢問有沒有新的郵件並且使用Chrome的通知提醒使用者。
* 番茄工作用的時鐘。
* 在指定的時間內鎖定及解鎖特定的網站幫助你專心工作。

## 參考

* https://crxdoc-zh.appspot.com/extensions/alarms
* https://developer.chrome.com/extensions/alarms



