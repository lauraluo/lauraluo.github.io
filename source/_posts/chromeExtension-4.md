title: Chrome Extension 開發與實作 04
date: 2016-12-18 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 名詞定義：架構的組成部份

前面兩篇都是官網的新手教學，而這篇跟上一篇文章討論的東西(官網的overview)有點重複，我們將探索**Creating  Google Chrome Extensions**一書中，作者對Extension的架構歸納，有助於我們在接下來的討論中取得共識。  

<!--more-->

**一個Chrome Extension組的元素，被作者分為以下幾項**  

## 輸入組件 / input component

Chrome提供給Extension開發者與使用者互動的元素，要注意的是這個組件並不一定有看得見的UI元素(EX Shortcut-Key)。以下是書中邏列的類型以及圖示。  


*   Browser-Action 瀏覽器按鈕  

*   Page-Action 頁面按鈕  

*   Shortcut-Key 快捷鍵  

*   Context-Menu-Item 右鍵功能選單  

*   Omnibox-Input 網址列輸入  

*   Content-UI 網頁內容UI 

<!--more-->

![](https://quip.com/blob/QSMAAAodKwg/-kiESpJ6p6vbGkRlA2Uf3A?a=Y4RcJVladzN2r7yiOxl05WFztGZiIJRaJYKwG4cCNaUa)

> 一個extension能擁有多個輸入組件，例如google字典就同時結合了Browser-Action, Content-UI,Shortcut-Key多個輸入元件。但Browser-Action 與Page-Action只要選一個就好了。因為他們兩個之間只是出現時機上的不同，其他差異性很小。

> 頁面按鈕及瀏覽器按鈕在某次chrome的改版後，已經統一外觀，只是出現時機不同，但舊版的瀏覽器會將頁面按鈕放置在網址列裡面的右邊，這裡採用新版的長相。

## 腳本相關的組件/script component

負責描述Extension的運作邏輯，下列是不同時機所需的腳本類型：  



*   Event scripts (Background scripts)/事件腳本：在安裝檔中定義，在一個看不見的背景頁面中執行，負責處理大部份的Extension邏輯．   

*   Popup scripts/彈出視窗腳本：彈出視窗的腳本，負責處理彈出視窗里的操作及維護。  

*   Content scripts/內容腳本：在安裝檔中定義，作為Extension與網頁溝通的橋樑，被注入到網頁裡。  



不同的腳本類型之間有獨立的scope，例如Popup Script沒辦法**直接存取**Event Script的方法跟變數，反之亦然。同樣的狀況也包含了，Content Scripts與Popup Script，或者Content Script與Event Scripts。他們三者之間唯一的溝通方式就是使用Chrome提供的**messaging APl**來溝通。  

## 彈出視窗組件 / Popup component

彈出視窗是Browser-Action以及 Page-Action中獨有的界面(見下圖)。有很多功能的實作都可以經由彈出視窗來完成，並且使用者不用離開他原本操作的頁面，也因為他的通用性，所以我們把他獨立成一個組件來討論：  

*   開發者雖然不能直接修改彈出視窗的外觀，但可以指定 Popup html的內容。  

*   關於彈出視窗與 pupup script  

*   pup Script就是負責處理彈出視窗組件的腳本。  

*   Popup Script只會在彈出視窗運行的時後才會被載入並且執行。  

*   PopupScript不能直接放置在Popup html裡，只能用資源的方式在HTML裡載入。EX:  
    `<script src="popup_script.js"></script> `

*   PopupScript可以多個  

*   PopupScript除了可以使用Chrome Extension API之外，還能像一般網頁中的Script去操作Popup html裡的DOM物件。  

![](https://quip.com/blob/QSMAAAodKwg/cXWBPmdU0WDOudtdx0XNqw?a=lKr67Gaq2ZShHSHnRxau1HmQFrXg3bVWTakmmI6lA94a)

## 安裝檔：Manifest component

安裝檔作為擴件的資源安裝依據，記載著許多重要的定義，自然也是一個擴件中的重要部份，除了上一篇文章中提到的部份，作者特別邏列出一個安裝檔一定要有的必要欄位：  



*   manifest_version：設定檔的格式版本，通常使用的都是最新的第二版。  

*   name：extension名稱  

*   version：extension 版本  



一個安裝檔的範例  

```
{  
  "name": "My Extension",  
  "version": "2.1",  
  "description": "Gets information from Google.",  
  "icons": { "128": "icon_128.png" },  
  "background": {  
    "persistent": false,  
    "scripts": ["bg.js"] //事件腳本  
  },  
  "permissions": ["http://*.google.com/", "https://*.google.com/"],  
  "browser_action": { //瀏覽器按鈕  
    "default_title": "",  
    "default_icon": "icon_19.png",  
    "default_popup": "popup.html" //彈出視窗組件(裡面可能引入彈出視窗腳本 <script src="popup_script.js"></script>)  
  },  
  "content_scripts" : [ //內容腳本  
    {  
        "matches" : ["*://*/*"],  
        "js" : ["content.js"],  
        "css" : ["content.css"]  
    }  
   ]  
}
```

> 更多安裝檔的完整資訊可參考[官方文件 ](https://developer.chrome.com/extensions/manifest)

## 小結



*   我們再次review了一個Extension的建構元素，並且對其附予了一些認知上的定義。  
*   注意這裡的component並不是具體的類別(class)或物件，官網也沒有這個說法，而是作者對於extension的API的歸納，有助於大家理解他們之間扮演的角色，請不要混肴。  
*   接下來會使用上面的各種定義一一介紹各組成部份的細節，所以煩請大家花時間吸收，看不懂的地方可以先略過，但名詞要弄清楚，以便接下來比較容易進入狀況。(因為我就迷路很久)  



參考資料

* http://www.apress.com/us/book/9781484217740
* https://developer.chrome.com/extensions
