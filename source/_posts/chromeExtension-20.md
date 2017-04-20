title: Chrome Extension 開發與實作 20
date: 2017-1-3 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 操作瀏覽器歷史紀錄 chrome.history


使用`chrome.history API`和瀏覽器的歷史記錄交互，您可以添加，刪除，通過URL查詢瀏覽器的歷史記錄。如果您想要使用您自己的版本替換默認的歷史記錄頁面，請參見[替代頁面](https://crxdoc-zh.appspot.com/extensions/override)。

<!--more-->

## 設定檔權限設置

```
{
    "name": "My extenstion",
    ...
    "permissions": [
        "history"
    ],
    ...
}
```

## 紀錄項目 HistoryItem

歷史紀錄的查詢(query)結果對象

* string id 該項目的唯一標識符。
* string （可選）url 用戶訪問的 URL。
* string （可選）title 上一次加載時該頁面的標題。
* double （可選）lastVisitTime 頁面最後一次訪問的時間，表示為從 1970 年 1 月 1 日午夜開始所經過的毫秒數。
* integer （可選）visitCount 用戶訪問此頁面的次數。
* integer （可選）typedCount 用戶通過在地址來中輸入 URL 的方式訪問此頁面的次數。

## 訪問項目 VisitItem

某個URL，某一次訪問的對象

* tring id  這次訪問所屬紀錄的ID(這裡要搞清楚的是，多個訪問項目如果網址相同，會有共同的ID)。
* string visitId  這次訪問的識別符。
* double （可選）visitTime 訪問時間，表示為從 1970 年 1 月 1 日午夜開始所經過的毫秒數。
* string referringVisitId 引用者的訪問所對應的標識符(看字面上的意思應該是指，他是從哪次"訪問"點進這個頁面來，不過官網的資料很少，並沒說明如果上次訪問不是從頁面來會是什麼結果)。
* enum of "link", "typed", "auto_bookmark", "auto_subframe", "manual_subframe", "generated", "auto_toplevel", "form_submit", "reload", "keyword", or "keyword_generated" transition 這一次訪問相對引用者的過渡型別([TransitionType](https://developer.chrome.com/extensions/history#type-TransitionType))。

> 過度型別用來描述一個URL是從何途徑被訪問：例如：link(點擊頁面上的連結)、typeed(從網址列輸入)、form_submit(表單提交後轉頁) 等，完整列表請查看[TransitionType](https://developer.chrome.com/extensions/history#type-TransitionType)。



> HistoryItem 跟 VisitItem的非常像，差別在於如果方法使用query的手段取得某HistoryItem物件(紀錄項目)，其物件包含了最後一次訪問的資訊以及一些統計結果。而VisitItem謹謹只代表某次特定的訪問，在抽象的關系上多個VisitItem物件可被歸屬於同一筆紀錄項目底下。

## 查詢

### 查詢訪問紀錄/取得所有訪問紀錄

```
chrome.history.search(object query, function C)
```

參數說明：

一個查詢參數(query)包含以下資訊：

* string text 向歷史記錄服務發出的查詢文字，如果為空則獲取所有紀錄。
* double （可選）startTime 將結果限制為此日期之後的訪問，表示為從 1970 年 1 月 1 日午夜開始所經過的毫秒數。
* double （可選）endTime 將結果限制為此日期之前的訪問，表示為從 1970 年 1 月 1 日午夜開始所經過的毫秒數。
* integer （可選）maxResults 要獲得的最大結果數目，默認為 100。

回調方法：回傳一個陣列，裝載著`HistoryItem`的實列

使用範例：

```
var query = {
    "text" : "example",
    "startTime" :  new Date().getTime() - 6 *  new Date().getTime(),
    "endTime" :  new Date().getTime(),
    "maxResults" : 10
};
chrome.history.search(query,function(results) {
    results.forEach(function(result) {
        //result is of type HistoryItem
        console.log(result);
    }); 
});
```

> 注意查詢的text傳入空值可取得所有的紀錄

## 取得指定網址的訪問

```
chrome.history.getVisits(object details, function callback)
```

參數說明：


* object details第一個參數傳入物件，物件中需包含`"url"` 屬性
* 回調中傳入裝載著`VisitItem`實例物件的陣列


使用範例：

```
chrome.history.getVisits({"url" : "http://www.example.org"},function(results) {
    results.forEach(function(result) {
        //result is of type VisitItem
        console.log(result);
    }); 
});
```

比較一下使用history.search以及history.getVisits回傳物件的不同，幫助大家釐清一下`HistoryItem`以及`VisitItem`之間的關係：

程式碼：

```
var query = {
    "text": "example",
    "startTime" :  new Date().getTime() - 6 *  new Date().getTime(),
    "endTime" :  new Date().getTime(),
    "maxResults": 10
};

chrome.history.search(query, function(results) {
    console.log("search");
    console.log(results);
    if (results.length > 0) {
        chrome.history.getVisits({ "url": results[0].url }, function(result) {
            console.log("getVisits");

            console.log(result);

        });
    }
});
```

![http://ithelp.ithome.com.tw/upload/images/20170103/20079450F8Xql7wdiq.png](http://ithelp.ithome.com.tw/upload/images/20170103/20079450F8Xql7wdiq.png)

* 綠框：注意比對會發現使用history.search取得的`HistoryItem物件`其`leastVisitTime`正代表最後一次訪問的時間
* 紅框：要注意getVisits取得的`VisitItem物件`id是會重覆的，表示這多個訪問屬於同一比紀錄。



## 新增及移除URLS

### 新增URL

向歷史紀錄後以當前時間新增一比URL，過度型別將被設定為`link`

```
chrome.history.addUrl(object details, function callback)
```

參數說明：

* object details第一個參數傳入物件，物件中需包含`"url"` 屬性
* 回調中無傳入任何參數

示範：

```
chrome.history.addUrl({ "url": "http://www.example.org" }, function() {
    console.log("addUrl");
});
```

### 移除指定的紀錄

根據網址刪除某比紀錄

```
chrome.history.deleteUrl(object details, function callback)
```

參數說明：

* object details第一個參數傳入物件，物件中需包含`"url"` 屬性
* 回調中無傳入任何參數

示範：

```
chrome.history.deleteUrl({"url" : "http://www.example.org"},function() {
    console.log("deleteUrl");
});
```

### 批次刪除指定時間區間的紀錄

```
chrome.history.deleteRange(object range, function callback)
```

參數說明：

* range： 傳入物件可設定時間區間的開始(double startTime)及結束(double endTime)，以豪秒的方式傳入從紀元到指定的時間。
* 回調中無任何傳入參數

### 刪除全部的紀錄

```
chrome.history.deleteAll(function callback)
```

> 官網有提供所有ＡＰＩ的測試範例，https://src.chromium.org/viewvc/chrome/trunk/src/chrome/test/data/extensions/api_test/history/

## 相關事件

* onVisited：當一個網址訪問產生，回調中會傳入HistoryItem物件
* onVisitRemoved ：當一個或多個URL訪問紀錄從紀錄清單中刪除時產生，當該網址紀錄底下的所有訪問都被刪除，則該比紀錄將從歷史紀錄清單中清除。回調中提供一個Object此Object包含兩個屬性
    * boolean allHistor：此事件是來自刪除所有歷史紀錄的動作。是的話為true
    * array of string urls: 代表刪除事件觸發刪除的網址，如果allHistor是true則url為空。

## 小結
來想想經由這個API能作到什麼事情：
＊你可以開發擴充功能，為特定的綱域設定自動刪除紀錄的功能。
＊取代原本的歷史紀錄頁面，詳情參考[替代頁面](https://crxdoc-zh.appspot.com/extensions/override)。除了改善界面外，也能在歷史清單紀錄上提供額外的資訊，例如網頁的瀏覽時間。
＊提供細節的刪除紀錄區間的功能，例如可以設定開始及結束的時間等複雜資訊的刪除。


## 參考
* https://crxdoc-zh.appspot.com/extensions/history
* https://developer.chrome.com/extensions/history
* http://www.apress.com/us/book/9781484217740





