title: Chrome Extension 開發與實作 08
date: 2016-12-22 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 輸入組件:瀏覽器按鈕與頁面按鈕
### 什麼是按鈕Action

Chrome允許你設定一個icon在網址列的右側，當使用者點擊icon時，會展開一個由開發者自訂內容的彈出介面，來與使用者互動。而根據使用時機的不同，有兩個類似的輸入組件分別是瀏覽器按鈕(Browser Acction) 與 頁面按鈕(Page Action)。  

![](https://quip.com/blob/TPLAAAdxn1T/LnotS2qYdC1BId_Ci6r1rw?a=iPhLt7ITv0aODM5RNjj43K2C1WApHrgm3XPwcta5aska)


在眾多輸入組件中，是最直觀的UI元素，也是許多開發者的第一選擇，接下來比較看看兩者的差別，幫助你挑選適合的方案。  

<!--more-->

## 按鈕(Action)能作到什麼事情

*   作為一個最容易跟使用者接觸的互動元素，是許多擴充功能開發者者的第一選擇。  
*   提供預設的彈出視窗，讓開發者可以快速的打造功能UI。  
*   彈出視窗不一定是必需的，也有些擴充功能選擇與內容腳本結合，在網頁中插入自己打造的UI元素，這時的按鈕僅僅只是作為一個觸發器而存在。  



## Browser-Action and Page-Action 的共同點

*   都可以設定彈跳視窗(非必要)，
*   彈出視窗腳本可以籍由彈出視窗引入，並且使用一些Chrome的API  
*   使用點擊右上角的圖示與之互動  
    *   chrome. browserAction.onClicked  
    *   chrome.pageAction.onClicked  


## Browser-Action and Page-Action 的差異點

*   Browser-Action在瀏覽器開敵時便是啟用狀態  
*   Page-Action 必需在指定的條件符合的狀況才會啟用  
*   你需要自已撰寫過瀘條件。  
    *   啟動頁面按鈕的方法  
        *   使用`chrome.declarativeContent` API來指定啟動pageAction的匹配條件  
        *   使用`chrome.pageAction.show(tabId)`來啟用pageAction的icon  
        *   與之對應的`chrome.pageAction.hide(integer tabId)`則用來關閉按鈕  

> 在chrome裡每個tab都有獨特的ID, 跟tab有關的資訊，可以用chrome.tabs相關的功能作存取，更多細節請參考：[https://developer.chrome.com/extensions/tabs#type](https://developer.chrome.com/extensions/tabs#type)

> 從啟用的時機上來看，Browser-Action跟Page-Action基本是互斥的，開發者只需擇其一。

## 安裝檔的宣告方式

要注意在宣告上，Chrome是分為兩個不同的物件。  

```
"browser_action" : {  
    "default_title" : "HelloBrowserAction",  
    "default_icon" : "icon.png",  
    "default_popup" : "popup.html"  
}  
```

```
"page_action" : {  
    "default_title" : "HelloPageAction",  
    "default_icon" : "icon.png",  
    "default_popup" : "popup.html"  
}  
```

## 有哪些方法可以用 

*   chrome.pageAction.setTitle( details)  
*   chrome.pageAction.setIcon(details,funccallback)  
*   chrome.pageAction.setPopup(details)  
*   其他參見  [broswerAction](https://crxdoc-zh.appspot.com/extensions/browserAction)  



*   hrome.browserAction.setTitle(details)  
*   chrome.browserAction.setIcon(details,funccallback)  
*   chrome.browserAction.setPopup( details)  
*   其他參見   [ pageAction](https://crxdoc-zh.appspot.com/extensions/pageAction)  



> 補充：browserAction中當你指定的tab關閉時，利用腳本改掉的設定會換回預設值。

## 動手作看看

在這裡我們先展示一段**瀏覽器按鈕**，**頁面按鈕**在下一個章節中再進行討論。我們將設定一個瀏覽器按鈕，使用者點擊後會看見一個彈出視窗。點擊視窗的按鈕，將用指定網址開啟一個新的Chrome視窗。  

## 設定檔 

```
{  
    "manifest_version": 2,  
    "name": "鐵人賽-Browser-Action",  
    "description": "就來作作第一個Browser-Action",  
    "version": "1.2",  
    "browser_action": {  
        "default_title": "羅拉拉的第一個擴充套件",  
        "default_icon": { // optional  
            "16": "icon.png", // optional  
            "24": "icon24.png", // optional  
            "32": "icon32.png" // optional  
        },  
        "default_popup": "popup.html"// optional  
    }  
}
```

### HTML：個人喜好 ，在樣式上引入了CSS Framework [FlatUI](http://designmodo.github.io/Flat-UI/) 

```
//popup.html  
<!DOCTYPE html>  
<html>  

<head>  
    <meta charset="utf-8">  
    <meta http-equiv="X-UA-Compatible" content="IE=edge">  
    <title></title>  
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/flat-ui/2.3.0/css/flat-ui.css">  
    <link rel="stylesheet" type="text/css" href="extension.css">  
</head>  

<body>  
    <div class="row demo-tiles">  
        <div class="col-xs-3">  
            <div class="tile">  
                <img src="https://scontent-tpe1-1.xx.fbcdn.net/v/t1.0-9/562816_461226470562299_1003308049_n.jpg?oh=036b256fa260df0b165672bc2dd0e7ff&oe=58EC4C54" alt="Compas" class="tile-image big-illustration">  
                <h3 class="tile-title">羅拉拉的Extension</h3>  
                <p>我是前端我驕傲</p>  
                <a class="btn btn-primary btn-large btn-block" href="https://github.com/lauraluo"><span class="fui-home"></span>羅拉拉的GitHub</a>  
              
          
      
    <script type="text/javascript" src="popup.js"></script>  
</body>  
</html>
```

彈出視窗腳本  

```
//popup.js  
document.addEventListener('DOMContentLoaded', function(dcle) {  
    var dButton = document.getElementById("button");  

    dButton.addEventListener('click', function(ce) {  
        //使用Chrome API開啟視窗  
        chrome.windows.create({ "url": "https://github.com/lauraluo" });  
    });  
});
```

### CSS：設定了視窗寬度

```
   body {  
      width: 500px;//可定義視窗寬度  
  }  

  .demo-tiles {  
      margin: 20px;  
  }
```

### 運行結果
![](https://quip.com/blob/TPLAAAdxn1T/7mRB2qheZYOG0Zgw8EqDMw?a=m53zaiyBoDH13qNDTaakOqz9B91RnLuv1SpVyN91VDga)

> 程式碼範例: [Github](https://github.com/lauraluo/ExtensionSample/tree/master/BroswerAction)  

## 補充：介面顯示的版本問題

無論是電子書或是官網中提到的範例，都顯示chrome會將 Page-Action的icon放置在網址列裡面並靠齊右邊。  
書中的圖例  
![](https://quip.com/blob/TPLAAAdxn1T/77cUOrQe1FaKI51v5bGjbA?a=exDdlc5aQAUoE1uNa111Nsu6l7gv8dyrzPNUgELhQ8sa)
新版本狀況會發現兩個按鈕被統一了：請注意右上角的頁面按鈕，在一開始載入並沒有馬上啟用 (灰色)，而是在我進入新的網站時才啟動按鈕(彩色)，這就是新版的PageAction。  
![](https://quip.com/blob/TPLAAAdxn1T/resPTG83j-K8LC6f_LdBCQ?a=ybKKvrgTtLdXxc5r2NjsaB8FwdQJmYqIQyhqkKPsMYMa)

## 小結

*   頁面按鈕以及瀏覽器按鈕，是許多開發者的優先選擇。  
*   如果你的擴充功能每一頁都必需載入，請你選擇瀏覽器按鈕。  
*   如果你的擴充功能，在特定的條件才需載入，請你選擇頁面按鈕。  
*   在舊版本中，這兩個按鈕的長相有所分別，但在新版本的Chrome外觀已經統一。  
*   彈出視窗組件不是必需的，你可以選擇頁面/瀏覽器作為你的擴充功能入口，再利用內容腳本打造自已的UI(evernote就這麼作)。  
*   如果你設定了彈出視窗組件，事件腳本將接收不了按鈕的點擊事件。  
*   我們的範例，簡單的示範一個瀏覽器按鈕如何實作，展示了彈出視窗腳本可以直接使用一些Chrome提供的API。  
*   對工程師來說，頁面按鈕跟瀏覽器按鈕最大的不同之處，除了安裝檔中使用的關鍵字不一樣之外，還有一點最重要的，開發者需要實作啟動頁面按鈕的邏輯，我們將在下一個段落討論。  



## 參考資料

*   完整的 pageAction 中文文件： [https://crxdoc-zh.appspot.com/extensions/pageAction](https://crxdoc-zh.appspot.com/extensions/pageAction)  
*   完整的 BrowserAction 中文文件：  [https://crxdoc-zh.appspot.com/extensions/browserAction](https://crxdoc-zh.appspot.com/extensions/browserAction)  
*   電子書：[http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  

