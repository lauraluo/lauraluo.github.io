title: Chrome Extension 開發與實作 12
date: 2016-12-26 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 網址列輸入組件(chrome.omnibox)


## 什麼是網址列輸入組件

![](https://quip.com/blob/MbAAAAo03Q4/dRu1N2RTihqiOTpmHUKuvg?a=raaSd5W6OWEWFaiBvtV4QXyBkr5h0asAy0w9NtdAqwMa)

omnibox輸入組件，主要是允許使用者在網址列，輸入特定的關鍵字(並按下tab)，來啟動你的Extension，接著你能籍由監聽使用者的輸入行為來實作操作邏輯。  

<!--more-->

## 能作到什麼事情


* 優化搜尋體驗，例如：一個Vue的API查詢擴充，當使用者啟動輸入組件時，推荐出跟字母相關的API名稱(並且自動完成)然後開啟Vue文件中相關的說明頁面。  
* 允許開發者提供建議輸入的清單並且自動完成。  
* 其實除了搜尋也可以綁定其他操作邏輯(例如：FB發文，Trello新增卡片)，但比較少人會這麼作，我推論是因為不夠直覺。  


## 使用方法

### 安裝檔的設定

```
{  
    "name": "Aaron's omnibox extension",  
    "version": "1.0",  
    //必需指定一個啟用你擴充功能的關鍵字  
    "omnibox": { "keyword" : "OI" },  

    "icons": {  
      "16": "16-full-color.png"  
    },  
    "background": {  
      "persistent": false,  
      "scripts": ["background.js"]  
    }  
}
```


* Chrome允許你設定個關鍵字(case-insensitive 大小寫沒差)  

* 使用者在輸入關鍵字後, 按下`tab`鍵，網址列便會顯示安裝檔中址定的icon與你的app名稱，以提示使用者進入Extension的輸入模式。(如下圖)  


![](https://quip.com/blob/MbAAAAo03Q4/KoWQSTN9BdN5TgDLR5lYoQ?a=1ccxy2r5Un3pXdJ3BahiugWbJ4B0n1cWSVeYFiKadn8a)

### 利用事件腳本處理使用者的輸入

Chrome提供以下事件供我們使用：  

* chrome.omnibox.onInputStarted  使用者進入輸入介面，發生在 onInputChanged事件前。  
* chrome.omnibox.onInputChanged 使用者更改了輸入框的內容  
* chrome.omnibox.onInputEntered 按下enter，送出輸入框的內容  
* chrome.onibox.onInputCancelled 按下esc，退出輸入框  

> 關於事件的完整操作，可以查看[中文文件](https://crxdoc-zh.appspot.com/extensions/omnibox#event)


### 提供建議輸入的清單

為了增加使用者的互動經驗，Chrome允許我們在使用者開始輸入內容的時後，提供健議的輸入清單，如下圖  

![](https://quip.com/blob/MbAAAAo03Q4/BTXlOW9AtA4ReIXDKsv8Vg?a=2f1lDf7S4GcF10uBXhZxxVAMY7Pawjks4noLkSnvRhEa)

程式的實作邏輯上，便是利用`onInputChanged`裡的回調方法，回調方法中將提供使用者目前的輸入結果，以及最重要的`suggestion() `方法，供你回傳建議的輸入清單。我們來看看以下事件角本的程式碼片段：  

```
chrome.omnibox.onInputChanged.addListener(function(text,suggest) {  
    suggest(suggestResults);  
});
```

要特別注意的事，`suggestion()`的輸入參數是一個陣列，而這個陣列中的所有子元素，是擁有content以及description屬性的物件，就像這樣：  

```
var suggestResultOne = {  
    "content" : "Some content",  
    "description" : "Description"  
};  

var suggestResults = [suggestResultOne];
```

但僅僅是這樣還不夠，我們希望上上面的示圖以樣，能針對使用者的輸入，去推荐不同的輸入清單，那要怎麼實作能？讓我們看一下完整的範例。  

### 實作自動完成的建議輸入

事件腳本的程式碼片段：  

```
//預設值  
var suggestResultOne = {  
    "content" : "Some content",  
    "description" : "Description"  
};  
var suggestResults = [suggestResultOne];  

//先列出使用者可能會輸入的字母  
var descriptions = {  
    "a" : ["actions","alarms","apps",],  
    "b" : ["background-page","bookmarks","browser-action"],  
    "c" : ["commands","content-script","context-menu"],  
    "d" : ["dashboard","declarativeContent"],  
    "e" : ["event-script","examples"],  
    "h" : ["history"],  
    "i" : ["incognito","inject"],  
    "m" : ["management page","manifest","match pattern","messaging"],  
    "o" : ["omnibox"],  
    "p" : ["page-action","permissions","plugins","popup"],  
    "r" : ["resources panel","runtime"],  
    "s" : ["sources panel","store","storage"],  
    "t" : ["tabs","themes"]  
};  

//當使用者輸入的字符合上列時，將所有的建議清單裝成一個陣列回傳  
//如果沒有符合就回傳預設值  
function getSuggestResults(key) {  
    var results = [];  
    if(!descriptions[key] || !key) return suggestResults;  
    for(var i=0;i<descriptions[key].length;i++) {  
        var suggestResult = {};  
        suggestResult["content"] = descriptions[key][i];  
        suggestResult["description"] = "Search '" + descriptions[key][i] + "' on developer.chrome.com";  
        results[i] = suggestResult;  
    }  
    return results;  
}  

//監聽事件，處理建議清單  
chrome.omnibox.onInputChanged.addListener(function(text,suggest) {  
    suggest(getSuggestResults(text));  
});
```

這樣以來當使用輸入a 時，我們在介面上顯示可搜尋以a為首的相關字串，並協助使用者自動完成輸入。  

![](https://quip.com/blob/MbAAAAo03Q4/FOvyOZsl3nIgTHmR_HWSrw?a=DlJDC7iNXsRVE4gBhzCVG9avDA0hvqF339tHlrbPyxIa)

接著我們來實作當使用者完成輸入並按下enter的操作邏輯，請看以下事件腳本的程式碼片段：  

```
var searchService = "https://www.google.com/search?q=chrome+extensions+developers+";  
//方法：用指定網址打開新視窗  
function CreateWindow(url) {  
    var windowCreateData = {"url" : ""};  
    windowCreateData.url = url;  
    chrome.windows.create(windowCreateData);  
}  
//當使用者按下Enter，將使用者的輸入給果組合成google搜尋的網址(作為網址參數)，並用新視窗打開  
chrome.omnibox.onInputEntered.addListener(function(text,disposition) {  
    console.log("<InputEntered> Text: " + text);  
    CreateWindow(searchService + text);  
});
```

注意到上面的程式碼中使用了`chrome.windows.create`，開啟一個新的視窗，並將新視窗的網址，指定成想要搜尋的關鍵字作用網址參數的方式給google查詢。  

結果展示：  

![](https://quip.com/blob/MbAAAAo03Q4/AgOTBso8XHRBb-QJgc1o6A?a=W9cs8Kq8jASEXcdaShP6AwcOOc4azwCmQCQLcvaYHf0a)

> 這裡使用的是[電子書](http://www.apress.com/us/book/9781484217740)中的範例，完整的範例參考第三章節的[HelloOmniboxInput](https://github.com/Apress/creating-google-chrome-extensions/tree/master/9781484217740)

## 小結


* 網址列輸入組件允許使用者輸入一個指定關鍵字，並按下tab啟動擴充功能的輸入模式。  
* 籍由這個輸入模式，開發者可以監聽使用者的輸入，來實作各種操作邏輯。  
* 開發者可以提供建議輸入的清單，協助使用者完成操作。  
* 主觀來說，我覺得他的應用範圍不廣，除了搜尋功能的優化外，以字典查詢為例：已經有更好用的右鍵功能選單，而作為一個功能的觸發，也比不上快捷鍵輸入組件來來的快速或是比彈出視窗顯示操作UI來的直覺。  

* 就像在[組成部份](http://ithelp.ithome.com.tw/articles/10186466)中我們提到的，還有一個內容UI的輸入組件還沒介紹到，但因為內容UI組件的實作，牽扯到了腳本之間的溝通，所以在介紹最後一個輸入組件之前，下一個段落我們將先探討腳本之間的訊息溝通方式。  


## 參考資料 


* [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  
* [https://crxdoc-zh.appspot.com/extensions/commands](https://crxdoc-zh.appspot.com/extensions/commands)  
* [https://crxdoc-zh.appspot.com/extensions/omnibox](https://crxdoc-zh.appspot.com/extensions/omnibox)  
