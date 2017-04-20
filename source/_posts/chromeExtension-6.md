title: Chrome Extension 開發與實作 06
date: 2016-12-20 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---
# 事件腳本與背景頁面

## 什麼是事件腳本

Extension的功能實作由於腳本之間無法直接進行溝通，所以非常依靠事件趨動來傳送訊息，處理操作邏輯，事件腳本可以被視為是Extension的Controller，所有的事件最後都會回到事件腳本身上集中處理。  

<!--more-->

## 事件腳本可以作到什麼事情



*   監聽來自輸入組件的事件，例如：點擊瀏覽器按鈕或是頁面按鈕、快捷鍵的輸入、網址列的輸入事件、等等，幾乎與所有的輸入組件交手。  

*   監聽來自extension自身的事件，包含了：onMessage, onConnect, onInstalled, onUpdateAvailable等…。他們都經由chrome.runtime物件存取。(訊息的發生，通訊的連結，擴充功能的安裝結束，或更新)  

*   經由Chrome Extension 的messageAPI，間接跟內容腳本溝通，以便控制網頁內容。  

*   能監聽來自瀏覽器的事件：  

    *   頁籤新增，移除，更新。 chrome.tabs—onCreated, onUpdated, onRemoved等…  

    *   瀏覽器的通知 chrome.alarms—onAlarm  

    *   瀏覽器的localStorage變更 chrome.storage—onChanged  

    *   書籤的創造，移除…等。chrome.bookmarks—onCreated, onRemoved, onChanged, onImportBegan, onImportEnded等…  

    *   紀錄的新增及移除 chrome.history—onVisited, onVisitRemoved  


在實作應用上，幾乎所有的Eextension實作都會需要用到事件腳本，大部份的邏輯也在事件腳本中進行實作。  

## 事件腳本與背景頁面

當你在設定檔中宣告事件腳本，Chrome其實會自動幫你產生一個背景頁面，一個看不見的頁面來載入事件腳本。如果想查看(由其是debug)事件腳本，你可以從擴充工具管理頁面來展開他的debug界面，如下圖：  

開啟擴充功能管理頁面，點擊套件清單中的，背景頁面字樣。  

![](https://quip.com/blob/STWAAAUvuiE/MKTfM2_VDHwqSQtUddkh3g?a=Bpe9tr5QfM9aDjMA7eAiMSMCgiH1kjaGd81MQvFZyOAa)

便會打開Developer Tool，在這裡可以對事件腳本進行調適的動作。  

![](https://quip.com/blob/STWAAAUvuiE/e3utv80RkyJ0_H8du9ZPLA?a=QRQJ6SrwPGKaC1vKQ6kSo7gJazkpFVe1qNtGAt9a94Ia)

## 背景頁面(Background Page)的狀態

事件腳本只會在需要的時後保持運行，當閒置時，Chrome會暫停他(要注意這不是立刻發生)。下面以page action為例，當目前瀏覽的頁面非指定的網址，你可以看見他的背景頁面狀態顯示無法使用(要注意得等上一陣子)：  

![](https://quip.com/blob/STWAAAUvuiE/sYZEw--kXE6V1ffKSFEDtA?a=6z7a7OVTh47fJ21DLIbTZIbuhNPyw8kIWd87oZ7tvTga)

## 事件腳本的生命周期

下面是一些可能觸發**背景頁面加載**的例子：  



*   應用或擴展程序第一次安裝或更新到新版本。( onInstalled, onUpdateAvailable)  

*   事件頁面監聽的某個事件觸發。(onMessage, onConnect)  

*   內容腳本或其他擴展程序發送消息。(onMessageExternal )  

*   擴展程序中的其他視圖調用了runtime.getBackgroundPage。  


背景頁面在加載後，直到所有的視圖(view)及發送訊息的端口(script or extension)關閉，才會卸載背景頁面。而新的視圖的加入並不會造成背景頁面的重載，只是讓他保持運行的狀態。  

一旦背景頁面保持一段時間（幾秒鐘）的空閒狀態，將觸發runtime.onSuspend事件。背景頁面在強制卸載之前，還有幾秒鐘的時間來處理該事件。如果在這段時間內產生了通常 會話事件頁面載入的事件，卸載操作將取消，並產生runtime.onSuspendCanceled事件。  

## 安裝中的定義

```
"background" : {  
    "scripts" : ["event_script.js","another_event_script.js"],  
    "persistent" : false  
}
```



*   事件腳本可以拆分成多個JS檔，幫助你將邏輯模組化  


## 維持事件腳本的運行

在某些特定的狀況，你可能希望無論腳本閒置與否，事件腳本都維持運行，這可以經由把`persistent"`設定成true，來作到。  

```
"background" : {  
    "scripts" : ["event_script.js","another_event_script.js"],  
    "persistent" : true  
}
```

但這樣容易造成效能問題，所以官方並不建議我們這麼作。  

## 動手作看看：事件註冊

下面的程式碼展示了，當使用者點擊瀏覽器按鈕時，事件腳本會接收到通知，並且執行Alert，Alert內容會包含該頁的標題(title)。  

設定檔：  

```
{  
    "manifest_version": 2,  
    "name": "鐵人賽-事件腳本範例",  
    "description": "羅拉拉的事件腳本範例",  
    "version": "2.0",  
    "browser_action": {  
        "default_title": "羅拉拉的事件腳本範例",  
        "default_icon": {   
            "16": "icon.png",   
            "24": "icon24.png",   
            "32": "icon32.png"   
        }  
        // "default_popup": "popup.html"  
        // 如果彈出視窗有設定的話，會檔掉瀏覽器的點擊事件(chrome.browserAction.onClicked)，故這次的範例中我們不使用彈出視窗  
    },  
    "background" : {  
        "scripts" : ["event.js"],  
        "persistent" : false  
    }  
}  


```

事件腳本：  

```
console.log("background page ready");  

chrome.browserAction.onClicked.addListener(function(tab) {  
    // console.log(tab);  
    alert("使用者在"+tab.title+ "中點擊了瀏覽器按鈕");  

});
```

結果展示：
![http://i.imgur.com/na0VJ1J.gif](http://i.imgur.com/na0VJ1J.gif)


> 完整範例在：[Github](https://github.com/lauraluo/ExtensionSample/tree/master/EventScript)

## 補充:用詞上的差別

官方教學卻將事件腳本的加載頁面分為兩類  



*   [persistent background pages](https://developer.chrome.com/extensions/background_pages) /永久背景頁面：就跟他的名字一樣，永遠是開啟的狀態。  

*   [event pages](https://developer.chrome.com/extensions/event_pages) /事件頁面：在需要的時後才會開啟。  


但這兩個頁面事實在Chrome的擴充功能管理頁面上，字面的顯示都是背景頁面( background page)。  

大概是因為這樣很令人混肴，所以**Creating  Google Chrome Extensions**一書中，作者故意避開了這個名稱，認為只是事件腳本(event script)上的不同設定。而無論腳本的設定如何，加載他的頁面都稱之為背景頁面(background page)。  

因為我也覺得容易誤會，所以我會採用書中的說法，在這裡列出來是幫助大家查看官方文件。  

> 你可以這樣記憶它，根據`persistent`的設定不同，我是一律以事件腳本稱呼，而官方則以載入腳本的頁面為主體分為[persistent background pages](https://developer.chrome.com/extensions/background_pages)與[event pages](https://developer.chrome.com/extensions/event_pages)。

## 小結

*   事件腳本可以被視為是Extension的Controller。  

*   事件腳本是經由自動生成的背景頁頁載入，並且使用者看不見這個頁面。  

*   想要調適(debug)背景頁面，可以籍由擴充功能選單來打開他。  

*   事件在需要的時後加載，在閒置的時後被移除，並且在擴充功能頁面會顯示其狀態，這個狀況是有延遲性的。  

*   想要讓事件腳本閒置時也保持運行，就要使用` "persistent"`屬性。（但官方不健議）  


## 資料來源


*   [https://crxdoc-zh.appspot.com/extensions/event_pages](https://crxdoc-zh.appspot.com/extensions/event_pages)  

*   [https://developer.chrome.com/extensions/event_pages](https://developer.chrome.com/extensions/event_pages)  

