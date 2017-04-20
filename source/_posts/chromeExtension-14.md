title: Chrome Extension 開發與實作 14
date: 2016-12-28 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 腳本組件之間訊息的傳遞(下)

請與[上一篇](http://ithelp.ithome.com.tw/articles/10187744)一起服用。要真的弄懂擴充功能的事件系統，請先對擴充功能的組成有清楚的概念。如果你覺得自己在理解上有困難，是時後回到前面複習一下：[Chrome Extension 開發與實作 04-名詞定義：架構的組成部份](http://ithelp.ithome.com.tw/articles/10186466)

<!--more-->

## 跨擴充功能之間的溝通

Chrome允許擴充功能接受其他擴充功能傳送的訊息，你可以提供一個公用的API，讓其他擴充功能使用。  

### 外部訊息的發送：

相關API： [runtime.sendMessage](https://crxdoc-zh.appspot.com/extensions/runtime#method-sendMessage) 以及 [runtime.connect](https://crxdoc-zh.appspot.com/extensions/runtime#method-connect)   

與擴充功能的其他部份並無差別(請參考[上一篇](http://ithelp.ithome.com.tw/articles/10187744))，記得使用擴充功能的ID作為傳入`extensionId`參數，以指定發送對象。  

一次性請求  

```
chrome.runtime.sendMessage(string extensionId, any message, object options, function responseCallback)
```

長時間連接  

```
chrome.runtime.connect(string extensionId, object connectInfo)
```

### 外部訊息請求的接受：

相關API：[runtime.onMessageExternal](https://crxdoc-zh.appspot.com/extensions/runtime#event-onMessageExternal) 以及 [runtime.onConnectExternal](https://crxdoc-zh.appspot.com/extensions/runtime#event-onConnectExternal)   

一次性接收  

```
chrome.runtime.onMessageExternal.addListener(function callback)
```

長時間連接的接受：同樣的回調中會提供[runtime.port](https://crxdoc-zh.appspot.com/extensions/runtime#type-Port)物件供你發送及接收訊息  

```
chrome.runtime.onConnectExternal.addListener(function callback)
```

> 內容腳本不能存取外部訊息，如果有此需求需經由內部的事件腳本將訊息傳遞給內部的內容腳本。

## 動手作看看(1):跨擴充功能之間的溝通

### 實作功能說明：



*   載入擴充功能A，實作頁面按鈕，並且一開始不啟用此按鈕。  

*   載入擴充功能B，此功能實作瀏覽器按鈕，按下按鈕打開彈出視窗，視窗中有一顆按鈕。  

    * 按下擴充功能B的彈出視窗上的按鈕，啟用擴充功能A的頁面按鈕，再按一次關閉擴充功能A的頁面按鈕。  



### 擴充功能A的事件腳本：

```
var toggle = false;  
//可以列出禁止防問的黑名單ID  
var blockList = [];  

chrome.runtime.onMessageExternal.addListener(function(message, sender, sendResponse) {  
    console.log(sender);  

    //如果訪問在黑名單，就不作任何動作  
    if (blockList.indexOf(sender.id) != -1) {  
        return;  
    }  

    if (message.name != "切換頁面按鈕") {  
        return;  
    }  

    //如果按鈕是啟用的狀態則開，否則關  
    if (!toggle) {  
        chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
            chrome.pageAction.show(tabs[0].id);  
            toggle = !toggle;  
        });  
    } else {  
        chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
            chrome.pageAction.hide(tabs[0].id);  
            toggle = !toggle;  

        });  
    }  

    sendResponse("來自擴充功能A的訊息：操作完成");  

});
```

### 擴充功能B的彈出視窗腳本  

```
document.addEventListener('DOMContentLoaded', function(dcle) {  
    var dButton = document.getElementById("button");  
    //注意擴充功能A的ID在開始狀態是會變的，如果你要在你的地端跑這個範例  
    //請自行在擴充功能管理頁面查看ID  
    //一旦正式發佈你的擴充功能，你可以得到一組固定ID  
    var extensionID = "fhggngpimllbngfbjdbiplgmhdppiiop";  

    //點擊按鈕，向擴充功能A發動訊息  
    dButton.addEventListener('click', function(e) {  

        console.log("click");  

        chrome.runtime.sendMessage(  
            extensionID,   
            { name: "切換頁面按鈕" },  
            function(response) {  
                console.log(response);  
            });  

    });  

});
```

> 注意：擴充功能A的ID在是會變的，如果你要在你的地端跑這個範例，請自行在擴充功能管理頁面查看ID， 一旦正式發佈你的擴充功能，你可以得到一組固定ID

### 結果展示：

右下擴充功能A的事件頁面，右上擴充功能B的彈出視窗腳本  

![](http://i.imgur.com/nat1o59.gif)

> 完整範例在：[Github](https://github.com/lauraluo/ExtensionSample/tree/master/MessageAPI/exp_3)

## 續跨擴充功能之間的溝通-來自網頁的外部訊息

就像上面跨擴充功能溝通的例子雷同，事實上擴充功能也能接收並且響應來自普通網頁的訊息，要能讓網站可以用使用Chrome的訊息API，首先你得在設定檔中列出允許傳遞訊息的網域。  

```
"externally_connectable": {  
  "matches": ["*://*.example.com/*"]  
}
```

網址的匹配表執式必需至少包含一個[二級域名](https://zh.wikipedia.org/wiki/%E4%BA%8C%E7%BA%A7%E5%9F%9F)，也就是禁止使用“*”、“*.com”、“*.co.uk”以及“*.appspot.com”之類的主機名作為匹配表達式。  

## 動手作看看(2): 接收來自網站腳本的訊息

### 實作功能說明：

*   實作一個網站，網頁上有一個按鈕。  
*   實作一個擴充功能，擁有頁面按鈕，非啟用的狀態。  
*   按一下網頁上的按鈕，擴充功能的頁面按鈕即啟用，再按一下關閉。  

### 設定檔

```
{  
    "manifest_version": 2,  
    "name": "訊息範例-頁面腳本向事件腳本發送訊息",  
    "description": "頁面腳本向事件腳本發送訊息",  
    "version": "2.0",  
    "page_action": {  
        "default_title": "頁面腳本向事件腳本發送訊息",  
        "default_icon": "icon.png",  
        "default_popup": "popup.html"  
    },  
    "background": {  
        "scripts": ["event.js"],  
        "persistent": false  
    },  
    "externally_connectable": {  
        "matches": ["*://localhost/*"]  
    },  
    "permissions": ["tabs"]  
}
```

### 事件腳本

```
var toggle = false;  
//可以列出禁止防問的黑名單網址  
var blockList = [];  

chrome.runtime.onMessageExternal.addListener(function(message, sender, sendResponse) {  
    console.log(sender);  

    //如果訪問在黑名單，就不作任何動作  
    if (blockList.indexOf(sender.url) != -1) {  
        return;  
    }  

    if (message.name != "切換頁面按鈕") {  
        return;  
    }  

    //如果按鈕是啟用的狀態則開，否則關  
    if (!toggle) {  
        chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
            chrome.pageAction.show(tabs[0].id);  
            toggle = !toggle;  
        });  
    } else {  
        chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
            chrome.pageAction.hide(tabs[0].id);  
            toggle = !toggle;  

        });  
    }  

    sendResponse("來自擴充功能的訊息：操作完成");  

});
```

### 網頁HTML

```
<!DOCTYPE html>  
<html itemscope itemtype="http://schema.org/Article" ng-app="markup" debug="false">  
  <!--page default Information-->  
  <!--html head-->  
  <head>  
    <meta charset="utf-8">  
    <meta http-equiv="X-UA-Compatible" content="edge,chrome=1">  
    <title>首頁</title>  
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/flat-ui/2.3.0/css/flat-ui.css">  
  </head>  
  <!--html body-->  
  <body class="l-index">  
    <section class="index">  
      <p style="padding:100px;"><a id="button" href="#" class="btn btn-primary btn-large btn-block">切換擴充功能的頁面按鈕</a></p>  
    </section>  
  </body>  
  <script src="../js/page.js"></script>  
</html>
```

### 網頁腳本

```
var dButton = document.getElementById("button");  
var extensionID = "ampdcffgccbnfionpljcpncpcjfbhbag";  

//點擊按鈕，向擴充功能A發動訊息  
dButton.addEventListener('click', function(e) {  

    console.log("click");  

    chrome.runtime.sendMessage(  
        extensionID,   
        { name: "切換頁面按鈕" },  
        function(response) {  
            console.log(response);  
        });  

});  

```

### 結果展示

![](https://quip.com/blob/DWdAAATWVtD/IABEy4FDD6wqpJCBwfiFUg?a=wL1hWasXAGL8y2qUJozif0Ph153GiPklAWH2ACLSNDAa)

> 完整範例：[Github](http://i.imgur.com/gtR4oBl.gif)

## 內容腳本以及頁面腳本的溝通

前面已經提過，內容腳本沒辦法存取runtime.onMessageExternal 以及 runtime.onConnectExternal API，因此內容腳本當然沒辦法像上面的案例一樣使用這個途勁與網頁的腳本溝通。  

作為替代方案，內容腳本可以使用標準的網頁Javascript API。(注意：非chrome *API)  

### 訊息的發起：

相關API：[Window.postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage)

```
window.postMessage(message, targetOrigin, [transfer]);
```

下面示範內容腳本在頁面插入一個按鈕，當使用者按下按鈕時，對頁面腳本發送訊息  

```
//region {variables and functions}  
var consoleGreeting = "Hello World!";  
var targetOrigin = window.location.origin;  
var message = "Test message X";  
function createButton() {  
    var button = document.createElement("button");  
    button.style.width = "70px";  
    button.style.height = "40px";  
    button.style.position = "fixed";  
    button.style.top = "10px";  
    button.style.right = "10px";  
    button.innerText = "Send Message";  
    document.body.appendChild(button);  
    return button;  
}  
//end-region  

//region {calls}  
console.log(consoleGreeting);  
var button = createButton();  
button.addEventListener("click",function() {  
    console.log("Button clicked!");  
    window.postMessage(message,targetOrigin);  
});
```

訊息的接收：  

相關API：[Window.addEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener)

    window.addEventListener("message", listener[, options]);

下面示範一個網頁腳本接收來自頁面腳本的訊息  

```
//region {variables and functions}  
var sendMessageButtonID = "send_message";  
var greeting = "Hello World!";  
//var targetOrigin = window.location.origin;  
//var message = "Test message Y";  
//end-region  

//region {calls}  
console.log(greeting);  
document.addEventListener("DOMContentLoaded",function(dcle) {  
    var buttonID = document.getElementById(sendMessageButtonID);  
    buttonID.addEventListener("click",function(ce) {  
        //window.postMessage(message,targetOrigin);  
    });  
});  
window.addEventListener("message",function(me) {  
    console.log("message: " + me.data);  
});  
//end-region
```

> 本來想作範例，但我想了一下覺得這種使用情景實在不多，這裡就不示範了。  
> 如果大家對這個段落的範例有興趣，這裡使用的是[電子書](http://www.apress.com/us/book/9781484217740)中的範例，完整的範例參考第三章節的[CSandWS](https://github.com/Apress/creating-google-chrome-extensions/tree/master/9781484217740)範例

## 補充(1)：腳本訊息傳遞的安全性

要小心[跨站腳本攻擊](http://en.wikipedia.org/wiki/Cross-site_scripting)，避免使用以下API：  

```
chrome.tabs.sendMessage(tab.id, {greeting: "hello"}, function(response) {  
  // 警告：可能會執行惡意腳本  
  var resp = eval("(" + response.farewell + ")");  
});
```

```
chrome.tabs.sendMessage(tab.id, {greeting: "hello"}, function(response) {  
  // 警告：可能會插入惡意腳本  
  document.getElementById("resp").innerHTML = response.farewell;  
});
```

首選以下API：  

```
chrome.tabs.sendMessage(tab.id, {greeting: "hello"}, function(response) {  
  // JSON.parse 不會攻擊者的執行腳本。  
  var resp = JSON.parse(response.farewell);  
});
```

```
chrome.tabs.sendMessage(tab.id, {greeting: "hello"}, function(response) {  
  // innerText 不會插入攻擊者的html (因為可能會包含惡章腳本)。  
  document.getElementById("resp").innerText = response.farewell;  
});
```

## 補充(2)：釐清標準JS API 與 Chrome JS API的事件系統

不要混肴chrome extension API提供的事件監聽系統，跟JS的DOM事件監聽系統。 寫法不同，用法不同：  

Chrome Etension 的 事件監聽API：(chrome.* API)  

```
chrome.commands.onCommand.addListener(function(command) {  
    chrome.browserAction.setIcon(  
        details,  
        function() {/**/}  
    );  
});
```

```
chrome.tabs.onUpdated.addListener(function(tabId,changeInfo,tab) {  
    console.log(tabId);  
    chrome.pageAction.show(tabId);  
});
```

JS的DOM物件事件監聽API： (Javascript API)  

```
el.addEventListener("click", modifyText, false);
```

## 小結



*   事件腳本及彈出視窗腳本，可以使用[runtime.onMessageExternal](https://crxdoc-zh.appspot.com/extensions/runtime#event-onMessageExternal) 以及 [runtime.onConnectExternal](https://crxdoc-zh.appspot.com/extensions/runtime#event-onConnectExternal) 接收來自擴充功能外部的訊息，至於訊息的發起請參考上一個章節。  
*   對其他擴充功能發起訊息，要提供擴充功能的ID，這個ID可以在擴充功能管理界面找到(請參考03- [官網導讀：架構總覽Architecture Overview](http://ithelp.ithome.com.tw/articles/10186334) )。要注意ID在換檔案路徑之後是會變的，如果你正式發佈你的擴充功能，你可以得到一個固定的ID。  
* `網頁腳本`也能使用Chrome.runtime API 對擴充功能發起訊息，你必需在安裝檔設定網域。  
* 內容腳本`不能使用`[runtime.onMessageExternal](https://crxdoc-zh.appspot.com/extensions/runtime#event-onMessageExternal) 以及 [runtime.onConnectExternal](https://crxdoc-zh.appspot.com/extensions/runtime#event-onConnectExternal) API，作為替代方案，你可以使用標準的網頁訊息API與載入頁面的腳本溝通。  
* 事實上作業系統的應用程式也可以跟擴充功能交換訊息，但我覺得有點複雜，而且脫離了前端領域，所以這裡就不介紹了。  
* 下一個章節我們將嚐試使用訊息機制打造一個內容UI輸入組件。  



## 花絮

訊息系統真的是繞的我蠻暈的，每次寫訊息相關的系統都覺得自己人格分裂的應該不只我一人。

## 參考

*   [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  
*   [https://crxdoc-zh.appspot.com/extensions/messaging](https://crxdoc-zh.appspot.com/extensions/messaging)  
*   [https://crxdoc-zh.appspot.com/extensions/runtimme](https://crxdoc-zh.appspot.com/extensions/runtimme)  

  

