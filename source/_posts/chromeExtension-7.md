title: Chrome Extension 開發與實作 07
date: 2016-12-21 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---
# 內容腳本(content script)之臉書下雪了
## 什麼是內容腳本

內容腳本是在網頁的上下文中運行的JavaScript文件，它們可以通過標準的文檔對像模型（DOM）來獲得瀏覽器訪問的網頁的資訊，甚至可以對其DOM物件作出增刪除修改的動作，也能監聽來自網頁中的事件。

擴充功能籍由內容腳本的注入，便可間接與使用者載入的網頁溝通，進而提供與網頁內容相關的功能。

<!--more-->

## 內容腳本的限制

*   只能存取以下API：  
    *   [extension](https://crxdoc-zh.appspot.com/extensions/extension)（[getURL](https://crxdoc-zh.appspot.com/extensions/extension#method-getURL)、[inIncognitoContext](https://crxdoc-zh.appspot.com/extensions/extension#property-inIncognitoContext)、[lastError](https://crxdoc-zh.appspot.com/extensions/extension#property-lastError)、[onRequest](https://crxdoc-zh.appspot.com/extensions/extension#event-onRequest)、[sendRequest](https://crxdoc-zh.appspot.com/extensions/extension#method-sendRequest)）  
    *   [i18n](https://crxdoc-zh.appspot.com/extensions/i18n)  
    *   [runtime](https://crxdoc-zh.appspot.com/extensions/runtime)（[connect](https://crxdoc-zh.appspot.com/extensions/runtime#method-connect)、[getManifest](https://crxdoc-zh.appspot.com/extensions/runtime#method-getManifest)、[getURL](https://crxdoc-zh.appspot.com/extensions/runtime#method-getURL)、[id](https://crxdoc-zh.appspot.com/extensions/runtime#property-id)、[onConnect](https://crxdoc-zh.appspot.com/extensions/runtime#event-onConnect)、[onMessage](https://crxdoc-zh.appspot.com/extensions/runtime#event-onMessage)、[sendMessage](https://crxdoc-zh.appspot.com/extensions/runtime#method-sendMessage)）  
    *   [storage](https://crxdoc-zh.appspot.com/extensions/storage)  

*   **不能**存取extension裡其他類型腳本組件的方法  
*   **不能**存取定義在網頁中其他JS中的變數跟方法  

> content Script雖然無法直接跟完整的chrome.* APIs溝通，但他能使用runtime AP裡的訊息API進行間接的溝通，我們稍晚在別的章節討論到訊息溝通的時後，會一併討論。  

## 內容腳本可以作什麼

Content Script雖然只能在非常小的限度下存取Chrome提供的Extension API，但能作到其他腳本作不到的事：  

*   操作網站的DOM物件，CSS。  
*   使用Native的JS的messageAPI，接收來自網頁腳本的訊息。  
*   可以設定插入的條件。  
*   除了在安裝檔中指定網址外，也能由腳本來動態插入內容腳本。



內容腳本可以實現的一些功能的例子： 
* 在網頁中找到未鏈接的URL，並將它們轉換為超鏈。
* 接增加字體大小，使文本更具有可讀性。
* 發現並處理DOM中的微格式數據(data-*=””)
* 搜尋網站中的所有link下載所有的檔案。 




## 安裝檔中的定義

以下程式碼展示了，我們定義內容角本在指定的網址底下，載入JS檔與CSS檔。  

```
"content_scripts" : [  
    {  
        "matches" : ["http://www.google.com/*"],  
        "css" : ["mystyles_A.css"],  
        "js" : ["jquery.js","myscript_A.js"]  
} ]
```

`content_scripts`項目可以包含以下屬性：  



*   matches 拼配的網址([Matches Patterns](https://developer.chrome.com/extensions/match_patterns))  

*   exclude_matches 排除的網址([Matches Patterns](https://developer.chrome.com/extensions/match_patterns))  

*   match_about_blank 是否要在是否在 `about:blank` (註1)以及`about:srcdoc`(註2) 中插入內容腳本。  

*   css 插入的css  

*   js 插入的腳本   

*   run_at 插入時機，可為 "document_start"、"document_end" 或 "document_idle"，預設值 為 "document_idle"。  

*   all_frames 是否在頁面嵌套的iframe中插入腳本   

*   include_globs 包含的URL， 模擬 Greasemonkey(註3) 中的[`@include`](http://wiki.greasespot.net/Metadata_Block#.40include) 關鍵字  

*   exclude_globs 排除的URL， 模擬 Greasemonkey 中的[`@include`](http://wiki.greasespot.net/Metadata_Block#.40include) 關鍵字  



以上只是簡介，完整說明可參考[這裡](https://crxdoc-zh.appspot.com/extensions/content_scripts#registration)  

還有一點要提醒的，許多擁有**matches**作為關鍵字的屬性，大多許都適用官網提供的匹配表達示[Matches Patterns](https://developer.chrome.com/extensions/match_patterns)，想看匹配表達範例的可以看[這裡](https://crxdoc-zh.appspot.com/extensions/content_scripts#match-patterns-globs)  

> 註1 about:srcdoc：HTML5 **only**
> 该属性值可以是HTML代码，这些代码会被渲染到iframe中，如果同时指定了src属性，srcdoc会覆盖src所指向的页面。该属性最好能与sandbox和seamless属性一起使用。([引用處](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/iframe))

> 註2 about:blank
> 打開瀏覽器空白指令

> 註3
> **Greasemonkey**，簡稱**GM**，中文俗稱為「**油猴子**」，是[Mozilla Firefox](https://zh.wikipedia.org/wiki/Mozilla_Firefox)的一個附加元件。它讓使用者安裝一些[腳本](https://zh.wikipedia.org/wiki/%E8%85%B3%E6%9C%AC%E8%AA%9E%E8%A8%80)使大部分HTML為主的[網頁](https://zh.wikipedia.org/wiki/%E7%B6%B2%E9%A0%81)於使用者端直接改變得更方便易用。隨著Greasemonkey腳本常駐於瀏覽器，每次隨著目的網頁開啟而自動做修改，使得執行腳本的使用者印象深刻地享受其固定便利性。([](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/iframe)[引用處](https://zh.wikipedia.org/wiki/Greasemonkey))

## 動態插入內容腳本

也許你希望使內容腳本不要立刻載入，而是當使用者點擊瀏覽器按鈕時才動態插入，你可以使用以下方法：  

```
chrome.tabs.insertCSS(integer tabId, object details, function callback)  
chrome.tabs.executeScript(integer tabId, object details, function callback)
```

> 當你的內容腳本必需經由某些特定的事件(例如點擊page action按鈕)，使用程式載入css跟js就會非常有用。

以chrome官方提供的[make_page_red](https://src.chromium.org/viewvc/chrome/trunk/src/chrome/common/extensions/docs/examples/api/browserAction/make_page_red/)為例：這個例子顯示了當使用者點擊瀏覽器按鈕時，載入頁面的背景會變成紅色  

```
  
chrome.browserAction.onClicked.addListener(function(tab) {  
    chrome.tabs.executeScript({  
        code: 'document.body.style.backgroundColor="red"'  
    });  
});
```

記得要求權限`activeTab`  

```
 "permissions" : ["activeTab"],
```

通常狀態下，你會把`chrome.tabs.executeScript`的code放在一個文件裡，利用Path載入  

```
chrome.tabs.executeScript(null, {file: "content_script.js"});
```

## 執行緒：頁面腳本與內容腳本 平行的兩個世界 two isolated worlds

內容腳本雖然可以操作網頁內容的dom物件，但基本上跟網頁的腳本是完全隔離的，內容腳本不能存取網頁腳本的方法跟變數。開發人員可以放心在內容腳本內使用自己定義的方法跟變數，而不用擔心跟網頁腳本衝突。  

以下面這段程式碼為例：  

假設這是使用者載入的Hello.html頁面  

```
<html>  
  <button id="mybutton">點我</button>  
  <script>  
    var greeting = "你好";  
    var button = document.getElementById("mybutton");  
    button.person_name = "Bob";  
    button.addEventListener("click", function() {  
      alert(greeting + button.person_name + "。");  
    }, false);  
  </script>  
</html>
```

將內容腳本注入到Hello.html  

```
var greeting = "你好";  
var button = document.getElementById("mybutton");  
button.person_name = "Roberto";  
button.addEventListener("click", function() {  
  alert(greeting + button.person_name + "。");  
}, false);
```

最後的結果你會看到兩個Alert  

> 這種隔離的運行環境，被稱為[isolated world](http://stackoverflow.com/questions/36137194/run-javascript-in-an-isolated-world-chrome)

內容腳本可以自由的操作頁面的DOM物件，看起來好像是與頁面腳本共用，但事實上兩個運行環境擁有各自的DOM副本(如下圖)。  

兩個腳本之間甚至可以嵌入不同版本的Jquery而不會彼此干擾。  

![](https://quip.com/blob/MDBAAAs8nYU/Zaq-1venkl4IVxuKTveHLQ?a=ha8uQnBN7iXloCKCZjdKH5cjX815kXdNdmVmfWHQvgAa)

## 安全性的問題

### 注意跨站腳本的惡意攻擊：



*   例如：當你的內容腳本，使用[XMLHttpRequest](https://crxdoc-zh.appspot.com/extensions/xhr)來載入部份html，首選 innerText而不是 innerHTML。  

*   在https中，獲取來自http的內容要特別小心，因為http可能會經由[中間人攻擊](https://zh.wikipedia.org/wiki/%E4%B8%AD%E9%97%B4%E4%BA%BA%E6%94%BB%E5%87%BB)而遭到破壞。  



### 注意來自網頁內容的惡意攻擊：不要直接使用網頁提供的內容運行腳本，下面是不安全的例子：

```
var data = document.getElementById("json-data")  
//警告！data可能會是惡意腳本！  
var parsed = eval("(" + data + ")")
```

```
var elmt_id = ...  
//警告！elmt_id可能會故意加入 "); ~惡意腳本~"  
window.setTimeout("animate(" + elmt_id + ")", 200);
```

安全的作法：  

```
var data = document.getElementById("json-data")  
// JSON.parse 讓data不會變成可運行的腳本  
var parsed = JSON.parse(data);
```

```
var elmt_id = ...  
// 使用方法作為setTimeout的回調  
window.setTimeout(function() {  
  animate(elmt_id);  
}, 200);
```

> 中間人攻擊：(引用維基)一個中間人攻擊能成功的前提條件是攻擊者能將自己偽裝成每一個參與對談的終端，並且不被其他終端識破。中間人攻擊是一個（缺乏）相互[認證](https://zh.wikipedia.org/wiki/%E8%AE%A4%E8%AF%81)的攻擊。大多數的加密協定都專門加入了一些特殊的認證方法以阻止中間人攻擊。例如，[SSL](https://zh.wikipedia.org/wiki/SSL)協定可以驗證參與通訊的一方或雙方使用的憑證是否是由權威的受信任的[數位憑證認證機構](https://zh.wikipedia.org/wiki/%E6%95%B0%E5%AD%97%E8%AF%81%E4%B9%A6%E8%AE%A4%E8%AF%81%E6%9C%BA%E6%9E%84)頒發，並且能執行雙向身分認證。

## 在內容腳本裡使用來自擴充目錄底下的檔案

```
//將img的網址，指定成 <擴充功能目錄>/images/myimage.png 的代码：  

var imgURL = chrome.extension.getURL("images/myimage.png");  
document.getElementById("someImage").src = imgURL;
```

> 開頭有介紹到，除了插入內容腳本外，也能注入指定的樣式檔。我有試著去尋找能否在此樣式檔內引入擴充功能裡的圖片檔。我找到一個討論串([連結](http://stackoverflow.com/questions/3559781/google-chrome-extensions-cant-load-local-images-with-css))在討論這件事。雖然有人說可以，下面還稱讚聲一片，但似乎不是正確答案。  
>   
> 總之我無法成功的在注入頁面的樣式檔中使用 [predefined message](https://developer.chrome.com/extensions/i18n#overview-predefined)，來插入擴充檔案裡的圖片。如果有網友知道怎麼作，請告訴我，如果確定沒有其他方法，那我只能說：請儘量少用圖片作為畫面的layout。

## 動手作看看

安裝這個插件後，將在臉書的個人檔案封面出現下雪的場景(要重新整理)。  

安裝檔  

```
{  
    "manifest_version" : 2,  
    "name" : "鐵人賽-ContentScript範例",  
    "description" : "到臉書的個人檔案,會下雪",  
    "version" : "2.0",  
    "browser_action" : {  
        "default_title" : "到臉書的個人檔案,會下雪",  
        "default_icon" : "icon.png"      
    },  
    "content_scripts" : [  
        {  
            "matches" : ["*://www.facebook.com/*"],  
            "js" : ["content.js"],  
            "css" : ["content.css"]  
        }  
    ],  
    "permissions" : ["activeTab"]  
}
```

CSS  

```
canvas {  
    position: absolute;  
    top: 0;  
    left: 0;  
    right: 0;  
    bottom: 0;  
}  

@keyframes zboing {  
    0% {  
        transform: scale3d(1, 1, 1)  
    }  
    30% {  
        transform: scale3d(1.2, 0.75, 1)  
    }  
    40% {  
        transform: scale3d(0.85, 1.25, 1)  
    }  
    50% {  
        transform: scale3d(1.05, 0.85, 1)  
    }  
    65% {  
        transform: scale3d(0.95, 1.05, 1)  
    }  
    75% {  
        transform: scale3d(1.05, 0.95, 1)  
    }  
    100% {  
        transform: scale3d(1, 1, 1)  
    }  
}  

#snow-button {  
    background: url('https://lh3.googleusercontent.com/nTqfRkzDUd9qFhLs2aN-ZgxiNc3QqAi4Zk5ChrCpC0KKMUzfSAfnE-kRwUItDR--m-m7s5c4z-wkm0C0cctForQUFJBWDjo=w10240-h5760-rw-no') no-repeat 0 0;  
    width: 200px;  
    height: 200px;  
    background-size: 100% auto;  
    -webkit-animation: zboing 1.3s infinite 1s;  
    position: absolute;  
    top: 30px;  
    left: 40%;  
}
```

內容腳本  

```
var canvas = document.createElement("canvas");  
var cover = document.getElementsByClassName("coverBorder");  
canvas.id = "canvasLaLa2016";  
cover[0].appendChild(canvas);  

var button = document.createElement("div");  
button.id = "snow-button";  
cover[0].appendChild(button);
```

> 下雪的程式碼引用了[CodePen的作品](https://codepen.io/loktar00/pen/CHpGo)，在上面不討論

> 圖片來源：[http://www.flaticon.com/packs/christmas-28](http://www.flaticon.com/packs/christmas-28)

結果  

![](http://i.imgur.com/JP3mbTf.gif)

> 完整範例在：[Github](https://github.com/lauraluo/ExtensionSample/tree/master/ContentScript)

## 小結：


*   你可以使用指定的網址來設定載入內容腳本的條件  

*   也可以使用事件腳本，動態的決定插入內容腳本的時機  

*   內容腳本可以自由的操作網頁的dom物件，並且跟網頁的腳本完全是兩個平行的世界，不會彼此干擾  

*   注意跨網域的惡意攻擊，以及來自網頁內容本身的惡意腳本。  

*   範例很應景XD  

> 我們也可以使用[createElement()](http://www.w3schools.com/jsref/met_document_createelement.asp) ，籍由內容腳本在頁面中插入一個按鈕與使用者進行互動，這就是在前面提到過的Content UI/內容UI輸入組件，當使用點擊一個內容UI時，內容腳本組件要依靠Chrome的訊息API才能跟事件腳本溝通，我們在稍後幾篇文章將會介紹到。  


## 花絮

完了愈寫愈長 / v \ 我到底能不能堅持下去，其實我覺得腳本介紹完剩下的API自已看就好(捂臉)。

## 參考資料 

*   [https://crxdoc-zh.appspot.com/extensions/content_scripts](https://crxdoc-zh.appspot.com/extensions/content_scripts)  

*   [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  

