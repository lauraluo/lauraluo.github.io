title: Chrome Extension 開發與實作 13
date: 2016-12-27 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 腳本組件之間訊息的傳遞(上)

就像在腳本組件與擴充功能的執行階段，這段章節所提到的，腳本組件之間無法直接進行溝通，要依靠事件趨動的原理來處理各種操作邏輯，接下來我們就來探討這部份的實作細節及原理。  

<!--more-->

## 一次性請求

### 訊息的發送 

相關API： [runtime.sendMessage](https://crxdoc-zh.appspot.com/extensions/runtime#method-sendMessage) 及 [tabs.sendMessage](https://crxdoc-zh.appspot.com/extensions/tabs#method-sendMessage)  

```
chrome.runtime.sendMessage(string extensionId, any message, object options, function responseCallback)
```

```
chrome.tabs.sendMessage(integer tabId, any message, function responseCallback)
```

兩個API的使用方法類似，以下是用法歸納：  


*   `runtime.sendMessage`：向擴充功能內的其他部件傳送訊息(!! **但內容腳本除外)**，此外使用這個方法也可以向其他的擴充功能傳遞訊息，此時需附上另一個擴充功能的ID，如果省略ID，則消息只會在擴充功能內部傳送。  
*   `tabs.sendMessage`：把訊息傳送給`內容腳本`的專屬API，需附上tabID作為參數，讓Chrome知道他要傳送訊息的對像是哪個內容腳本。(注意不同頁籤之間並不共享內容腳本，內容腳本在每個頁籤都會單獨注入)。  
*  回調在接收到訊息的回傳時，會將回傳時作為參數提供。 


以下程式碼範例，示範了從內容腳本發送單次請求。並且在回調中可使用`response`參數接收訊息的回傳。  

```
chrome.runtime.sendMessage({greeting: "你好"}, function(response) {  
    console.log(response);  
});
```

如果從內容腳本向擴充功能執行緒發送請求，與上面的作法類似，唯一的差別就是需指定發送對象，所以要把tabID作為參數傳入。  

以下程式碼示範了，利用`chrome.tabs.query`取得當前tabID(`tabs[0].id`)，並向目前使用者Focus的頁籤發送請求。  

```
chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
    chrome.tabs.sendMessage(tabs[0].id, { greeting: "你好" }, function(response) {  
        console.log(response.farewell);  
    });  
});
```

> [chrome.tabs.query](https://crxdoc-zh.appspot.com/extensions/tabs#method-query)允許使用者用物件作為第一個參數查詢使用者目前開啟的所有書籤，在上面的程式碼中示範了在目前使用的視窗下，取得目前瀏覽的頁籤。回傳值會是一個[tab](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab)物件，內含了網站url、title、等有用資訊。

### 訊息的接收

相關API：  [runtime.onMessage](https://crxdoc-zh.appspot.com/extensions/runtime#event-onMessage)  

```
chrome.runtime.onMessage.addListener(function callback)
```

設置`chrome.runtime.onMessage.addListener`來接收訊息：  


*   訊息的接收方式是所有腳本共用的，內容腳本也可以使用此方法得到訊息。  
*   回調事件會回傳sender，sender內含資訊根據腳本的不同也會有所不同，如果sender中包含tab資訊，代表他來自內容腳本，其他則是來自擴充功能執行階段的訊息。  



```
chrome.runtime.onMessage.addListener(  
  function(request, sender, sendResponse) {  
    console.log(sender.tab ?   
        "取得到tab，這是來自內容腳本的訊息：" + sender.tab.url   
        : "沒有tab，這是來自擴充功能內部的訊息");  
    if (request.greeting == "你好")  
      sendResponse({farewell: "再見"});  
  });
```

> 如果有多個訂閱的設置(onMessage)同時都回傳訊息，只有其中一個`sendResponse()`能發送成功。

## 動手作看看:一次性請求

實作功能說明：  


*   實作一個頁面按鈕，點擊後跳出彈出視窗，並且畫面上擁有兩個按鈕。  
*   點擊【向事件腳本發送訊息】，彈出視窗腳本將傳送訊息給事件腳本，並接收回傳。  
*   點擊【向內容腳本發送訊息】，彈出視窗腳本將傳送訊息給內容腳本，接收回傳。並且內容腳本在接收到訊息的時後，會改變載入網頁的顏色。  



彈出視窗腳本：  

```
document.addEventListener('DOMContentLoaded', function(dcle) {  
    var dButtonEvent = document.getElementById("button1");  
    var dButtonContent = document.getElementById("button2");  

    //點擊按鈕，向事件腳本發送訊息  
    dButtonEvent.addEventListener('click', function(ce) {  
        chrome.runtime.sendMessage({ content: "你好，此訊息來自彈出視窗腳本" }, function(response) {  
            console.log(response);  
        });  
    });  

    //點擊按鈕，向內容腳本發送訊息  
    dButtonContent.addEventListener('click', function(ce) {  
        chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
            chrome.tabs.sendMessage(tabs[0].id, { content: "你好，此訊息來自彈出視窗腳本" }, function(response) {  
                console.log(response);  
            });  
        });  
    });  
});
```

事件腳本：  

```
chrome.runtime.onMessage.addListener(function(message, sender, sendResponse) {  
    console.log(message);  
    console.log(sender);  
    sendResponse({content: "來自事件腳本的回覆"});  
});
```

內容腳本：  

```
console.log("內容腳本注入");  

var toggleBg = true;  

chrome.runtime.onMessage.addListener(function(message, sender, sendResponse) {  
    console.log(message);  
    console.log(sender);  
    sendResponse({ content: "來自內容腳本的回覆" });  
    if (toggleBg) {  
        document.body.style.backgroundColor = "red";  
        toggleBg = !toggleBg;  

    } else {  
        document.body.style.backgroundColor = "black";  
        toggleBg = !toggleBg;  
    }  
});
```

結果展示：向事件腳本發送訊息 (右下為彈出視窗腳本，左下為事件腳本) 
![](http://i.imgur.com/U2fQRfl.gif)

結果展示：向內容腳本發送訊息 (右下為彈出視窗腳本，左下為內容腳本)  
![](http://i.imgur.com/0WVCNtb.gif)

> 完整範例在[Github](https://github.com/lauraluo/ExtensionSample/tree/master/MessageAPI/exp_1)

## 長時間連接

如果上個段落討論的一次性溝通，比喻為信件往來，那麼我們可以把長時間的連接當成打電話。  

長時間連接的好處，在於通話其間雙方能共享狀態，另一方面也能讓訊息的傳遞具有針對性。讓我們來探討一個使用情境：如果你想要實作一個「表單自動填充功能」，擴充套件在內容腳本偵測到表單元素時，開啟了"表單填寫"的通話，事件腳本在接受通話的請求後，內容腳本可以在使用者聚焦到不同的表單元件時，將表單元件的訊息傳送給事件腳本，事件腳本可以判斷有無符合的資料並回傳給內容腳本自動填入。 

### 長時間訊息的發起

相關API：[runtime.connect](https://crxdoc-zh.appspot.com/extensions/runtime#method-connect) 及  [](https://crxdoc-zh.appspot.com/extensions/tabs#method-sendMessage) [tabs.connect](https://crxdoc-zh.appspot.com/extensions/tabs#method-connect)  

```
chrome.runtime.connect(string extensionId, object connectInfo)
```

```
chrome.tabs.connect(integer tabId, object connectInfo)
```

不管是發送還是接收，腳本都會獲得一個回傳的 [runtime.Port](https://crxdoc-zh.appspot.com/extensions/runtime#type-Port)物件，我們將通過他來接收跟發送訊息。  

以下腳本示範如何從內容腳本建立連接，並且發送及監聽訊息。  

```
var dButtonConnect1 = document.getElementById("button1");
var dButtonConnect2 = document.getElementById("button2");


var port = chrome.runtime.connect({ name: "一通電話" });

port.onMessage.addListener(function(response) {
    console.log(response);
    switch (response.msg) {
        case "是的，他在":
            port.postMessage({ msg: "請幫我把電話她" });
            break;
        case "不，他不在":
            port.postMessage({ msg: "請幫我留言給他，留言是XXXXXX" });
            break;
        default:
            break;
    }
});


dButtonConnect1.addEventListener('click', function(event) {
    port.postMessage({ msg: "請問羅拉拉在嗎" });
});

dButtonConnect2.addEventListener('click', function(event) {
    port.postMessage({ msg: "請問王小明在嗎" });
});  

```

與上面提到的一次性連接範例類似，如果你是向容容腳本接立長時間連結，可以把[runtime.connect](https://crxdoc-zh.appspot.com/extensions/runtime#method-connect)，提換成 [tabs.connect](https://crxdoc-zh.appspot.com/extensions/tabs#method-connect)，並使用`tabs.query`附上tabID。  

### 長時間訊息的接受

使用 [runtime.onConnect](https://crxdoc-zh.appspot.com/extensions/runtime#event-onConnect)  

```
chrome.runtime.onConnect.addListener(function callback)
```

通訊發生時，回調會回傳port物件，供你接收及發送訊息。  

```
chrome.runtime.onConnect.addListener(function(port){
	if(port.name == "一通電話"){
	    port.onMessage.addListener(function(response) {
	        console.log(response);
		    switch (response.msg) {
		        case "請問羅拉拉在嗎":
		            port.postMessage({ msg: "是的，他在" });
		            break;
		        case "請問王小明在嗎":
		            port.postMessage({ msg: "不，他不在" });
		            break;
	        	default:
		            port.postMessage({ msg: "好的" });
                    port.disconnect();
		            break;
		    }
	    });		
	}
});
```

如果你想知道某個通話的連線狀態，可以調用[runtime.Port.onDisconnect](https://crxdoc-zh.appspot.com/extensions/runtime#property-Port-onDisconnect)方法，當通話其中一方使用[runtime.Port.disconnect  ](https://crxdoc-zh.appspot.com/extensions/runtime#property-Port-disconnect)結束對話或是通訊的頁面被關閉，就會收到通知。  

上面的範例結果展示：右上為背景頁面，右下為彈出視窗腳本  

![](https://quip.com/blob/deYAAAJj2JO/Uj7gGtnaPHLeCwvyIRQ7Qw?a=awHXfKaHadXeUaEPB2YPVJKOrChdvffamGJJ53zFba4a)

> 完整範例在[Github](https://github.com/lauraluo/ExtensionSample/tree/master/MessageAPI/exp_2)

## 小結


*   一次性的訊息發送，請使用 [runtime.sendMessage](https://crxdoc-zh.appspot.com/extensions/runtime#method-sendMessage) 或[tabs.sendMessage](https://crxdoc-zh.appspot.com/extensions/tabs#method-sendMessage)。  
*   一次性訊息的接收，請使用 [runtime.onMessage](https://crxdoc-zh.appspot.com/extensions/runtime#event-onMessage)  
*   長時間通訊，請使用 [runtime.connect](https://crxdoc-zh.appspot.com/extensions/runtime#method-connect) 或 [tabs.connect](https://crxdoc-zh.appspot.com/extensions/tabs#method-connect)，此API會回傳一個[rutime.port](https://developer.chrome.com/extensions/runtime#type-Port)物件，你可以使用他的onMessage以及postMessage接收及發送訊息。  
*   長時間通訊事件的接收，請使用[runtime.onConnect](https://crxdoc-zh.appspot.com/extensions/runtime#event-onConnect)，同上回調中會提供你[rutime.port](https://developer.chrome.com/extensions/runtime#type-Port)物件，供你發送及接收訊息。  
*   注意要對`內容腳本`傳遞訊息，都要使用tabs底下的API([tabs.sendMessage](https://crxdoc-zh.appspot.com/extensions/tabs#method-sendMessage) 以及[tabs.connect](https://crxdoc-zh.appspot.com/extensions/tabs#method-connect) )，並且使用[tabs.query](https://crxdoc-zh.appspot.com/extensions/tabs#method-query)取得想發送的頁籤ID。至於內容腳本的訊息接收跟其他腳本組件並無差異(內容腳本可以正常使用[runtime.onMessage](https://crxdoc-zh.appspot.com/extensions/runtime#event-onMessage)以及[runtime.onConnect](https://crxdoc-zh.appspot.com/extensions/runtime#event-onConnect) )。 
*   腳本之間的溝通我覺得是開發擴充功能的一個大重點，所以我想把範例作細一點，因此拆成上下章，下一個章節我們將繼續探討各種腳本之間的溝通議題。 



## 參考


*   [https://crxdoc-zh.appspot.com/extensions/runtime](https://crxdoc-zh.appspot.com/extensions/runtime)  

*   [https://crxdoc-zh.appspot.com/extensions/tabs](https://crxdoc-zh.appspot.com/extensions/tabs)  

