title: Chrome Extension 開發與實作 03
date: 2016-12-17 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 官網導讀：架構總覽Architecture Overview

進一步的說明什麼是Chrome Extension

*   extension是一個HTML、CSS、JS、images，以及你extension中需要的任何東西，打包成的一個壓縮檔，事實上extension就是一個web pages app。  

*   這個APP可以使用[Broswer提供的API](https://developer.chrome.com/extensions/api_other)，諸如：Standard JavaScript APIs、XMLHttpRequest、HTML5  等，跟一般的web APP無異。  

*   extension可以經由 [content scripts](https://developer.chrome.com/extensions/content_scripts) 或 [cross-origin XMLHttpRequests](https://developer.chrome.com/extensions/xhr)與頁面或伺服器互動。  

*   extension也可以用JS與Chrome的功能互動，例如：[bookmarks](https://developer.chrome.com/extensions/bookmarks) 及 [tabs](https://developer.chrome.com/extensions/tabs).  


<!--more-->

## Extensions 的 UI元素 

![](https://quip.com/blob/UScAAA2xiSA/5g8b9JFZYUz6kXSvkQdTfw?a=2YoqfZWiamhM6uHUsASfV2j0fSvhb3HC24Y8wGZj4owa) 如上圖所示，有很多的Extension(但不是全部)會實作在Chrome界面上添加UI元素，有兩個最常使用的UI元素：browser action 以及 page actons，你的extension可以擇其一。 下面是官方建議的選擇方案：  

*   選擇 [browser actions](https://developer.chrome.com/extensions/browserAction)：當你的extension跟大部份的網址都會有所互動的時後 。  

*   選擇 [page actions](https://developer.chrome.com/extensions/pageAction) ： 當你的extension需要在特定的網域底下才需要啟動。  

> Extenstion還有其他添加UI的方式，詳細的資訊可以參考官網的 [Developer's Guide](https://developer.chrome.com/extensions/devguide)，我們會在後面繼續討論。


## 檔案結構 

所有的extension擁有下列檔案：  

*   一個安裝檔 ：**manifest file**  

*   一個或多個 HTML檔 ：除了Chrome佈景的extension。   

*   非必要：一個或多個JS檔  

*   非必要： 所有其他你需要的靜態檔案，例如 圖片檔 、.css檔   

所以的檔案都放置在一個目錄底下，當你經由 [Chrome Developer Dashboard](https://chrome.google.com/webstore/developer/dashboard)發佈，他會為打包成一個.crx包裝檔。關於發佈的詳情教學，我們會在後面討論。   

### 引用資源路徑：

方案一 ：使用相對路徑來引用你extension裡的資源，例如下面這段HTML用來引進你extension根目錄底下的圖片  

```
<img src="images/myimage.png">
```

方案二：使用絕對路徑來引用資源(還記得上一篇debug的時後我們可以經由這個路徑直接進到popup.html嗎)  

```
chrome-extension://<extensionID>/<pathToFile>
```

但`<extensionID>`在載入不同的資料夾時是會變，想像一下你有可能在不同的電腦工作，又或者是多人協同往發extension。為了避免寫死ID，你可以使用[predefined message](https://developer.chrome.com/extensions/i18n#overview-predefined)裡提供的`@@extension_id`來動態取得 extension ID。  

使用情境如下 CSS檔：  
```
body {  
    background-image:url('chrome-extension://__MSG_@@extension_id__/background.png');  
}
```

當你正式方佈你的extension時(經由 [Chrome Developer Dashboard](https://chrome.google.com/webstore/developer/dashboard)發佈)，你會得到一個永久的ID，你可以考慮替換它。  

> 這裡有一點要提醒： `@@extension_id` 只能用html中使用的 JS或CSS等外部資源中，無法直接使用在HTML裡。例如使用它在HTML中直接指定img tag的src是無效的。

### 安裝檔：`manifest.json`

提供一切extension的資訊，提供哪些檔案，功能。下面是一個典型的安裝檔 ：  

```  
{  
  "name": "My Extension",  
  "version": "2.1",  
  "description": "Gets information from Google.",  
  "icons": { "128": "icon_128.png" },  
  "background": {  
    "persistent": false,  
    "scripts": ["bg.js"]  
  },  
  "permissions": ["http://*.google.com/", "https://*.google.com/"],  
  "browser_action": {  
    "default_title": "",  
    "default_icon": "icon_19.png",  
    "default_popup": "popup.html"  
  }  
}
```

> 更多資完整資訊可參考[官方文件 ](https://developer.chrome.com/extensions/manifest)


## extension的架構

*   The background page：大多extension擁有一個`background page`(一個看不見的頁面)，來處主要的邏輯。  

*   UI pages：extension也能擁有多個頁面去呈現與使用者互動的界面。  

*   如果extension需要與使用者正在瀏覽的頁面進行互，這個extension必需使用`content script`。  

### 背景頁面 The background page

使用background.html來定義，可以包含JS來處理extension的行為。有兩種類型的bacnground pages：  

*   [persistent background pages](https://developer.chrome.com/extensions/background_pages)：就跟他的名字一樣，永遠是開啟的狀態。  

*   [event pages](https://developer.chrome.com/extensions/event_pages)：在需要的時後才會開啟。  

除非你很確定background page 總是需要運行，否則官方建議你一律優先考慮event pages。我們會在後面討論細節。  

### 介面元素頁頁面 UI pages

*   extension可以包含普通的html來呈現UI，例如前面提到的broswer action 借由html來實作popup。  

*   [options page](https://developer.chrome.com/extensions/optionsV2)：用來讓使用者設定extension的參數(如果你允許的話)。  

*   <span data-section-style="11" style="max-width:73%">![](https://quip.com/blob/UScAAA2xiSA/_P6g0SahvDlAWn2lM11S_A?a=vCZIAOG9WKUg6PJEWcILakr8Y7VU11k34wPYngWoRVIa)</span>
*   [override page](https://developer.chrome.com/extensions/override)：用來替換點chrome新開TAB時的預設頁面、或是書籤管理頁面、或瀏覽紀錄頁(三擇一)

*   <span data-section-style="11" style="max-width:100%">![](https://quip.com/blob/UScAAA2xiSA/JxdlZBl_lgCS9yI_xJw0Mg?a=MxvUOFuwwL6e6Z0ZUQ6DBJZWpMtAKs9oPCdg8bPgD0Aa)</span>
*   其他：你可以使用 [tabs.create](https://developer.chrome.com/extensions/tabs#method-create) 或是` window.open()`開啟你extenstion裡的任何html檔   

在extension裡的所有的介面元素頁面可以存取彼此的DOM還有調用彼此的方法。下圖展示了一個基本架構：這個架構中popup可以直接調用background page的方法 。關於頁面間的溝通詳請，稍後我們會繼續探討。  

### Content scripts

如果你需要與使用者正在載入的頁面互動，那麼你就需要使用content script。請把content script想像成是載入頁面的一部份，而不是extension的一部份。  

content script 可以讀取及維護目前瀏覽頁面的細節。如下圖所示：我們可以籍由content script讀取並且更新使用者正在瀏覽頁面的DOM物件。  

![](https://quip.com/blob/UScAAA2xiSA/bJL0HoB8QvKM2qNTtr3NKQ?a=wDho7na9qljiP9HduBQG9Dawq9OgownSw80BF9a1zRsa) content script完全切離你的extension，它負責與extension本體傳遞訊息。如下圖所示：我們可以在content script找到頁面中有RSS feed時通知extension本體，又或者反過來由extension本體請求content script改變載入頁面的外觀。  
![](https://quip.com/blob/UScAAA2xiSA/amyeZO-yPOdWsDQGLtyMtQ?a=Vuf3CuqYEuIQjZbc7sMq1NGZjo3DsnBSwvzUMlJHHnga)  

> content script的細節，請參考[官方文件](https://developer.chrome.com/extensions/content_scripts)

## Using the chrome.* APIs

### extension裡有兩個種類的 Browser API

*   一種是網頁平常使用的瀏覽器API(諸如：Standard JavaScript APIs、XMLHttpRequest、HTML5  和 other emerging APIs)，  

*   另一種是，Chrome獨有的，特別提供extension來調用的API。我們稱之為： `chrome.* APIs`  

例如，你可以使用window.open()來開啟新的URL，但如果你要在Chrome中指定使用哪個視窗來打開也，你就需要Chrome獨有的[tabs.create](https://developer.chrome.com/extensions/tabs#method-create)方法。  

### 同步與非同步 

**大多數的chrome.* APIs都是非同步的**，他不等操作結束而是立即執行，所以我們使用callback的方式來取得執行的結果。下面是一個非同步API的調用格式：  

```
chrome.tabs.create(object createProperties, function callback)
```

其他同步的**chrome.* APIs**，不提供callback的傳入，因為JS的執行序一定會等到處理完畢，才回傳值。下面是個同步API的調用格式：  

```
string chrome.runtime.getURL()//`string` 則代表了這個方法回傳值的類型。
```

> 這裡補充一個JS的非同步概念：JS是一個單執行緒的語言，每當他需要跟伺服器或是Browser的API溝通時，他會發送請求，通常這個服務在接受或是處理完畢時，會告知瀏覽器執行回調。所以說JS的非同步通常都發生在需要跟其他服務溝通的時後。(例如：AJAX、WebGL、Canvas、Video、doucment ready等)

範例：callback的調用  

一個錯誤的程式碼：因為chrome.tabs.query是一個非同步方法  

```
/THIS CODE DOESN'T WORK  
var tab = chrome.tabs.query({'active': true}); //WRONG!!!  
chrome.tabs.update(tab.id, {url:newUrl});  
someOtherFunction();
```

官方文件中記載的正確使用格式 ：  

```
chrome.tabs.query(object queryInfo, function callback)
```

修正後的程式碼：  

```
//THIS CODE WORKS  
chrome.tabs.query({'active': true}, function(tabs) {  
  chrome.tabs.update(tabs[0].id, {url: newUrl});  
});  
someOtherFunction();
```

* * *

## extension裡的不同(html)頁面間的交流 ：Communication between pages

頁面間經常需要交流，因為不同頁面間的執行發生在同一個**執行緒(extension的執行序)。頁面間可以宣告方法來直接呼叫彼此的方法或操作對方的DOM物件。**  

如果需要取得extension的其他page，可以使用 [`chrome.extension`](https://developer.chrome.com/extensions/extension)的各種方法(例如`getViews()`、`getBackgroundPage()`)。一旦這個page被參照到，你便可以使用其中的方法，也可以維護其他頁面中的DOM物件。  

> 不確定這裡的頁面交流包不包括 背景頁面 ，還是特指前面討論到的介面元素頁頁面/ UI pages(屬於extension的視圖)，因為背景頁面其實是很特別的存在並不會被使用者看見，開發者也不會直接操作到html，後面有時間我再去証實。

## 保存數據以及無痕模式 ：Saving data and incognito mode

所有的extension都可以使用[storage](https://developer.chrome.com/extensions/storage) API, 也就是 HTML5 [web storage API](http://dev.w3.org/html5/webstorage/) (就像是`localStorage`)，也可以把數據送到伺服器端去作儲存。當你要儲存任何東西，第一個要考慮到的便是無痕模式。  

通常的狀況下，extension是不會在無痕模式下被啟用(要特地在擴充功能的管理介面開啟)，你要考慮到你使用者在無痕模式下，期望你的extension如何運行。  

無痕模式承諾不會留下任何資料的追蹤，所以請發揮你的功德心保証你會尊守這個承諾。例如：如果你的extension會把所有的瀏覽記錄都傳送到雲端。那麼在無痕模式下你不能這麼作。  

要在程式中判斷是否為無痕模式，你可以使用 [tabs.Tab](https://developer.chrome.com/extensions/tabs#type-Tab) 或是[windows.Window](https://developer.chrome.com/extensions/windows#type-Window) 物件，來檢查 `incognito` 屬性。以下是範列：  

```
function saveTabData(tab, data) {  
  if (tab.incognito) {  
    chrome.runtime.getBackgroundPage(function(bgPage) {  
      bgPage[tab.url] = data;      // Persist data ONLY in memory  
    });  
  } else {  
    localStorage[tab.url] = data;  // OK to store data  
  }  
}
```

## 資料來源

官方教程：https://developer.chrome.com/extensions 
* 快速連結- 入門  https://developer.chrome.com/extensions/getstarted
* 快速連結- 概述 https://developer.chrome.com/extensions/overview

