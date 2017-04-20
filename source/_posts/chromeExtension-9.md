title: Chrome Extension 開發與實作 09
date: 2016-12-23 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 啟用頁面按鈕

本篇請與[上一篇](http://ithelp.ithome.com.tw/articles/10187070)一起服用。  

<!--more-->

## 什麼是頁面按鈕(Page Action)

頁面按鈕在啟用前，在右上角呈現黑白的狀態，在開發者設計的情景下才會啟用。對使用者來說，這樣可以減少干擾。對開發者來說，可以減少不必要的錯誤。  

## 頁面按鈕能作什麼：

* 當你擴充功能，只作用在提供RSS訂閱功能的網站時，你會用到它。  
* 當你的擴充功能，在有密碼輸入框的網頁才會有作用，你會用到它。  
* 當你的擴充功能，只有在Facebook的網址下才作用，例如：檔住右側廣告，換成好看的照片，你會用到它。  

一言以蔽之，你的按鈕如果不是在任何頁面都有作用，請使用頁面按鈕，否則請使用瀏覽器按鈕。  

按鈕的啟用方式需要工程師自己實作及設定，以下介紹兩種啟用頁面按鈕的方式。  

## 啟用按鈕方法一：使用chrome.pageAction.show(tabId)

首先來看以下這段設定檔以及事件腳本  

設定檔：  

```
{  
    "manifest_version" : 2,  
    "name" : "鐵人賽-Page-Action1",  
    "description" : "啟用方法一：只有在主機是：www.google.com.tw的網域底下啟用此頁面按鈕",  
    "version" : "2.0",  
    "page_action" : {  
        "default_title" : "啟用方法一",  
        "default_icon" : "icon.png",  
        "default_popup": "popup.html"          
    },  
    "background" : {  
        "scripts" : ["event.js"],  
        "persistent" : false  
    },  
    "permissions" : ["tabs"]  
}
```

事件腳本  

```
//指定比對的url：不允許片段表達式   
//例如： *://*.google.com.tw/* 作為查詢字串不被接受因為host是一個片段表達式  
var urlPattern = '*://www.google.com.tw/*';  

//利用 tabs.query api 查找畫面上的所有tab  
function queryTabsAndShowPageActions(queryObject) {  
    chrome.tabs.query(queryObject,  
        function(tabs) {  
            if (tabs && tabs.length > 0) {  
                for (var i = 0; i < tabs.length; i++) {  
                    //在加載完畢的tab上，使用chrome.pageAction.show 啟用按鈕  
                    if (tabs[i].status === "complete") chrome.pageAction.show(tabs[i].id);  
                }  
            }  
        }  
    );  
}  

//第一次的初始化  
chrome.runtime.onInstalled.addListener(function() {  
    queryTabsAndShowPageActions({  
        "active": false,  
        "currentWindow": true,  
        "url": urlPattern  
    });  
});  

//每次tab有變動，檢查現在這個current tab是否在指定的 url pattern底下  
chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {  
    queryTabsAndShowPageActions({  
        "active": true,  
        "currentWindow": true,  
        "url": urlPattern  
    });  
});  


```

上面這段腳本描述了兩段處理邏輯：  

其一：處理已開啟的Tabs，使用query api來繞遍所有的已開的網址，並在載入完畢的tab中啟用頁面按鈕  

```
//第一次的初始化  
chrome.runtime.onInstalled.addListener(function() {  
    queryTabsAndShowPageActions({  
        "active": false,  
        "currentWindow": true,  
        "url": urlPattern  
    });  
});
```

其二：處理新開啟的Tabs，查詢是否為指定網域，並啟用tab中的頁面按鈕。  

```
//每次tab有變動，檢查現在這個current tab是否在指定的 url pattern底下  
chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {  
    queryTabsAndShowPageActions({  
        "active": true,  
        "currentWindow": true,  
        "url": urlPattern  
    });  
});
```

這樣就完成了一個，只有在`*://www.google.com.tw/*`底下會啟用的頁面按鈕。  

> 完整範例在：[Github](https://github.com/lauraluo/ExtensionSample/tree/master/PageAction/pageAction1)

> 所以說其實也是可以偷吃步在所有tab開啟頁面按鈕，不過這樣作並沒有太大的意義。

> 除了使用url，應該也能籍由內容腳本來偵測有無特定的DOM物件，然後通知事件腳本處理。不過如果只是這樣有更方便的方式，讓我們繼續往下看方法二。

#### 方法一的補充：  

[chrome.tabs.query](https://crxdoc-zh.appspot.com/extensions/tabs#method-query)允許使用者用物件作為第一個參數查詢使用者目前開啟的所有書籤，在上面的程式碼中示範了在目前使用的視窗下，取得目前瀏覽的頁籤。回傳值會是一個[tab](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab)物件，內含了網站url、title、等有用資訊。

使用`tabs.query`來查詢頁籤，可以使用[Matches Patterns](https://developer.chrome.com/extensions/match_patterns)來過瀘取得的頁籤，但有一個很重要的限制，tabs.query不允許你使用片段表達式。  

例如：  

錯誤：會回傳不合規則的網址表達式  

```
chrome.tabs.query({  
        "active": false,  
        "currentWindow": true,  
        "url":  `*://www.google.com.*/*`   
    },  
    function(tabs) {  
});
```

糾正結果：使用陣列指定多國家的google網域  

```
chrome.tabs.query({  
        "active": false,  
        "currentWindow": true,  
        "url":  ['`*://www.google.com.tw/*','`*://www.google.com.hk/*'`]`  
    },  
    function(tabs) {  
});
```

## 啟用按鈕方法二：使用 申明式內容api (DeclarativeContent API )來啟用按鈕(从 Chrome 33 开始支持。)

接下來我們來討論另一種啟用頁面按鈕的方式，使用申明式內容(DeclarativeContent API)來啟用頁面按鈕。  

### 先來快速的查看一下，什麼是申明式內容api？

> 以下截錄自chrome.declarativeContent API的非官方中文文件：[https://crxdoc-zh.appspot.com/extensions/declarativeContent](https://crxdoc-zh.appspot.com/extensions/declarativeContent)

### 描述：

使用chrome.declarativeContent API根據網頁內容進行某些操作，而不需要讀取網頁內容的權限。  

### 用法：

聲明式內容API允許您根據網頁的URL和它的內容匹配的CSS選擇器來顯示您的擴展程序的頁面按鈕，而不需要擁有主機權限或插入內容腳本。為了在用戶單擊您的頁面按鈕後能夠與網頁交互，請使用activeTab權限。  

如果您需要更精確地控制什麼時候顯示您的頁面按鈕，或者需要在用戶單擊它之前更改它的外觀以匹配當前標籤頁，您還是需要繼續使用頁面按鈕API。  

### 操作步驟：


*   首先，你必需定義一個批配的規則：使用 [PageStateMatcher](https://crxdoc-zh.appspot.com/extensions/declarativeContent#type-PageStateMatcher)。  
*   使用事件腳本，把規則註冊到 [onPageChanged](https://crxdoc-zh.appspot.com/extensions/declarativeContent#event-onPageChanged)事件之上。  
*   然後指定當規則批配時，要採取什麼動作：只能是被允許的動作：除了啟用頁面按鈕，其他還有像設定按鈕icon...等(要注意有些重作還是Beta版)。  

### 步驟演練 

#### 步驟演練 Step1 設定權限

設定檔  

```
{  
    "manifest_version" : 2,  
    "name" : "鐵人賽-Page-Action2",  
    "description" : "啟用方法二：只有在主機是：www.google.com.tw 的網域底下啟用此頁面按鈕",  
    "version" : "2.0",  
    "page_action" : {  
        "default_title" : "啟用方法二",  
        "default_icon" : "icon.png",  
        "default_popup": "popup.html"          
    },  
    "background" : {  
        "scripts" : ["event.js"],  
        "persistent" : false  
    },  
    //記得宣告declarativeContent權限  
    "permissions" : ["tabs","declarativeContent"]  
}
```


#### 步驟演練 Step2 設定規則

以下程試碼展示了，當`https://www.google.com/`上的頁面存在密碼字段時，為該頁面啟用頁面按鈕。注意：所有條件(conditions)跟動作(actions)都使用new建構式。  

```
//事件腳本  
var rule = {  
    //條件  
    conditions: [  
        new chrome.declarativeContent.PageStateMatcher({  
            //url的匹配指定  
            pageUrl: { hostContains: 'www.google.com.tw' },  
            //必需擁有此dom物件, 以css選擇器的行形式宣告  
            css: ["img"]  
        })  
    ],  
    //動作：啟用頁面按鈕  
    actions: [new chrome.declarativeContent.ShowPageAction()]  
};
```

規則的條件可以多個，以下為例：  

```
  var rule = {  
    conditions: [  
      new chrome.declarativeContent.PageStateMatcher({  
        pageUrl: { hostContains: 'www.google.com'},  
        css: ["img"]  
      }),  
      new chrome.declarativeContent.PageStateMatcher({  
        css: ["video"]  
      })  
    ],  
    actions: [ new chrome.declarativeContent.ShowPageAction() ]  
  };
```

#### 步驟演練 Step3 註冊/註消規則

然後最重要的一點，記得在瀏覽器重啟時，去註消或是重新註冊規則：  

```
//刪除規則，並重新註冊  
chrome.runtime.onInstalled.addListener(function(details) {  
    //移除所有舊規則  
    chrome.declarativeContent.onPageChanged.removeRules(undefined, function() {  
        //註冊新規則  
        chrome.declarativeContent.onPageChanged.addRules([rule]);  
    });  
});
```
*   官網認為你應該在規則的新增跟移除上，一律採用批次執行(因為效能問題)。  
*   只宣告規則是沒用的，記得使用onPageChange.addRules來註冊規則  
*   記得配合declarativeContent權限一起使用。  
*   注意這個範例要在有`img tag`的畫面，按鈕才會啟用。例如：[https://www.google.com.tw/#q=haha](https://www.google.com.tw/#q=haha)  



> 完整範例在：[Github](https://github.com/lauraluo/ExtensionSample/tree/master/PageAction/pageAction2)

## 小結

* 有兩個方式可以啟用頁面按鈕，請選擇你覺得適合的方式，但要注意方法二要配合Chrome33以上的版本。
* 方法一中，除了網址，事實上你可以使用所有能直接或間接從Chrome API中拿到的資訊來決定啟用邏輯，也能利用內容腳本來偵測畫面中的DOM物件，但記得這些都需要設定對應的權限。   
* 除了網址，方法二提供了CSS選擇器來讓你使用DOM當作過瀘條件。  



資源：  

*   [https://developer.chrome.com/extensions/declarativeContent](https://developer.chrome.com/extensions/declarativeContent)  

 

