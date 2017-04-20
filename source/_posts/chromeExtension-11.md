title: Chrome Extension 開發與實作 11
date: 2016-12-25 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 輸入組件 右鍵功能選單(chrome.contextMenus)

## 什麼是右鍵功能選單輸入組件

Chrome提供開發者可以跟使用者正在關注的上下文進行互動(圖片，連結，選取文字)，而使用者可以在按下滑鼠右鍵時，看見擴充功能項目。  

![](https://quip.com/blob/FUGAAASxqG3/d9sLx4sA1MpG6afCKz350A?a=1nOTU5cZBwzPafx155MLUxqOA6dKcSz9sejeXclYllUa)

<!--more-->

## 可以作到什麼事情

*   可取到使用者正在瀏覽以及他所關注的元素資訊，例如：圖片的網址、連結的網址、頁面的網址，選取的文字，frame的網址等資訊。  
*   選單可以是巢狀的  
*   可以使用分割線，去群組你的項目(如下圖)  
*   可以以各別指定在哪些媒體元素上，點擊右鍵才啟用你的選單項目(例如：圖片、影片)  

![](https://quip.com/blob/FUGAAASxqG3/bgWDMPCes4_CgSEUYZWoHw?a=p3ybealrp70CYnPeqMncuekofMaIkhZ1LsxYVTLBIkEa)

這樣的模式可以應用在以下功能：  

*   字典：將使用選取的文字進行中英查詢  
*   圖片的收集：將使用者focus的圖片網址，收集到收集冊  
*   筆記的收集：將使用者選段的文字片段，收枈到線上筆記本  
*   連結的分析：按下右鍵分析使用者focus的連結是否為惡意網址。  


## 使用方法

### 定義你的右鍵選單

```
{  
    "manifest_version": 2,  
    "name": "HelloContextMenuItem",  
    "description": "Extension to demonstrate a Context-Menu-Item",  
    "version": "2.0",  
    //取得contextMenus權限  
    "permissions": ["contextMenus"],  
    //指定功能選單項目的icon 16X16，注意不要跟broswer與page action的宣告方式搞混  
    "icons": { "16": "icon.png" },  
    "background": {  
        "scripts": ["event.js"],  
        //將persistent設定為true  
        "persistent": false  
    }  
}
```
*   需設定contextMenus的權限  
*   注意設定icon的方式不要跟頁面按鈕或瀏覽器按鈕搞錯。  
*   如果不把persistent設定為true：他會要求你自己使用字串指定項目的id，而且不可以重複，另外點擊事件的綁定也會變的相對複雜，在這裡為了讓大家把重點聚焦，我們先不理會前面說的效能問題。  

> 補充：前面有說過事件腳本會在需要時載入，閒置時御載，所以如果不把persistent設定成true，工程師要注意因為腳本的重複載入，導致選單元素重複生成的問題。

### 創造選單元素

使用以下方法創造元素，一次只能創建一個項目，提供創建完成的回調。  

     chrome.contextMenus.create(createProperties, callback) 

以下程式碼示範創建一個基本項目：變數` normal` 將接收項目的ID必儲存。  

```
var normal = chrome.contextMenus.create({  
    "title": "通常項目",  
    "type": "normal",  
    "contexts": ['all'],  
    "parentId": parent,  
    "onclick": genericOnClick  
});  

```

創建項目必需是特定的物件格式，我們來看完整的物件設定資訊：  

```
{  
    "type" : "normal",  
    "id" : "item1-1",  
    "title" : "使用者選擇了'%s'",  
    "contexts" : ["all", "page", "frame", "selection", "link", "editable", "image", "video", "audio", "launcher", "browser_action","page_action"],  
    "documentUrlPatterns" : ["https://*.google.com/foo*bar"],  
    "targetUrlPatterns" : [],  
    "enabled": true,  
    "onclick": function(info,tab){},  
    "parentId": "item1",  
    "checked" : false  
};
```

*   `type` 選單的格式 有以下類型可以選擇  
    -   "normal"  
    -   "checkbox"  
    -   "radio"  
    -   "separator”(分割線)  
*   `id` 識別字串，在同一個extension中必需是唯一值，對於事件腳本是必要的存在。  
*   `title` 項目顯式的文字，使用字符變數`%S`將取得使用者在右鍵狀態中選擇的文字  
*   `content` 在哪些特定的內容上啟用項目  
*   `documentUrlPatterns` 指定在哪些特定的網域會啟用這個項目, 使用[匹配表達式](https://crxdoc-zh.appspot.com/extensions/match_patterns)  
*   `targetUrlPatterns` 跟上面類型，但允許使用相對路徑”/”  
*   `enabled` 該項目是否啟用，可以覆蓋掉上想所有相關的設定  
*   `onClick`項目被點擊時的回調方法  
*   `parentId` 指定巢狀項目的父層項目  
*   `checked` 如果type為radio或checkbox，可指定他的預設狀態是否勾選(預設值為false)。  

> 我試著翻閱有沒有一次插入多個項目的方法，但文件中`createProperties`不允許以陣列的方式傳入，所以如果你需要打造多個項目，除了用each 或是 for 用迴圈的方式進行，應該沒有別的方法。

> 除了創建項目外，chrome也提供項目刪修等操作，完整的方法可參考 [這裡](https://developer.chrome.com/extensions/contextMenus#summary)

### 監聽點擊事件

方法一：針別每個項目，在創建時綁定事件。  

```
function genericOnClick(info, tab) {  
    //根據你點選右鍵的狀況不同，可以得到一些跟內容有關的資訊  
    //例如 頁面網址，選取的文字，圖片來源，連結的位址  
    console.log(  
        "ID是：" + info.menuItemId + "\n" +  
        "現在的網址是：" + info.pageUrl + "\n" +  
        "選取的文字是：" + (info.selectionText ? info.selectionText : "") + "\n" +  
        "現在hover元素的圖片來源：" + (info.srcUrl ? info.srcUrl : "") + "\n" +  
        "現在hover的連結：" + (info.linkUrl ? info.linkUrl : "") + "\n" +  
        "現在hover的frame是：" + (info.frameUrl ? info.frameUrl : "") + "\n"  
    );  
}  
var item = chrome.contextMenus.create({  
    "title": "你選擇了%s",  
    "contexts": ['all'],  
    "onclick": genericOnClick  
});
```

方法二：另外綁定，這個作法會監聽所有項目，開發者要自己從回傳的資訊(也許是id)去判斷要處理的操作邏輯。  

```
chrome.contextMenus.onClicked.addListener(function(info,tab) {  
    console.log("id: %s, selection: %s, url: %s",info.menuItemId,info.selectionText,tab.url);  
});
```

請視狀況選擇適合你自己的方案。  

## 可選項目的補充

前面有說到創建項目時可指定元素的類型，其中的checkbox以及radio可以供使用者進行勾選及取消勾選。(如下圖)勾選項目與其他項目的差別在於以下：  

*   可以在創建時使用checked指定預設定  
*   當可選項目被點擊的時後，事件回調的回傳資訊包含了以下資訊供開發者操作：  
    *   checked: 目前狀態  
    *   wasChecked：之前的狀態  
*   另外還有比較特別的一點是，當Radio的選項元素使用分割線項目元素(separator)分開時，會形成一個只能單選的群組，如下圖：注意被分割線隔開的兩個群組形成了單選的狀態。  

![](https://quip.com/blob/FUGAAASxqG3/DQeikDMS-rCvkKUX5mx7dA?a=sus74Ojtm0ciFRPs4wBaRO1Fatiqol5RuuSC0oeATToa)

## 動手作看看

這次的範例目的是為了幫助大家完整的了解右鍵功能選單輸入組件，所以我會實作以下功能：  

*   創建所有類型的選單項目。  
*   將所有的項目收納在一個根項目裡，以達成巢狀收納。  
*   在發生點擊時，將一些有用的資訊顯示在背景頁面的console裡。  

設定檔：

```
{  
    "manifest_version": 2,  
    "name": "HelloContextMenuItem",  
    "description": "Extension to demonstrate a Context-Menu-Item",  
    "version": "2.0",  
    //取得contextMenus權限  
    "permissions": ["contextMenus"],  
    //指定功能選單項目的icon 16X16，注意不要跟broswer與page action的宣告方式搞混  
    "icons": { "16": "icon.png" },  
    "background": {  
        "scripts": ["event.js"],  
        //如果不把persistent設定為true：他會要求你自己使用字串指定項目的id，而且不可以重複，另外點擊事件的綁定也會變的相對複雜，為了讓大家把重點聚焦，所以才這麼作。  
        "persistent": true  
    }  
}
```

事件腳本   

```
function genericOnClick(info, tab) {  
    //根據你點選右鍵的狀況不同，可以得到一些跟內容有關的資訊  
    //例如 頁面網址，選取的文字，圖片來源，連結的位址  
    console.log(  
        "ID是：" + info.menuItemId + "\n" +  
        "現在的網址是：" + info.pageUrl + "\n" +  
        "選取的文字是：" + (info.selectionText ? info.selectionText : "") + "\n" +  
        "現在hover元素的圖片來源：" + (info.srcUrl ? info.srcUrl : "") + "\n" +  
        "現在hover的連結：" + (info.linkUrl ? info.linkUrl : "") + "\n" +  
        "現在hover的frame是：" + (info.frameUrl ? info.frameUrl : "") + "\n"  
    );  
}  

function checkableClick(info, tab) {  
    //checkbox 以及 radio 這兩種類型的項目，除了上面的程式碼提到的資訊外，還會用布林值來告訴你使用者點選前，及點選後的狀態。  
    console.log(  
        "ID是：" + info.menuItemId + "\n" +  
        "現在的網址是：" + info.pageUrl + "\n" +  
        "選取的文字是：" + (info.selectionText ? info.selectionText : "") + "\n" +  
        "現在hover元素的圖片來源：" + (info.srcUrl ? info.srcUrl : "") + "\n" +  
        "現在hover的連結：" + (info.linkUrl ? info.linkUrl : "") + "\n" +  
        "現在hover的frame是：" + (info.frameUrl ? info.frameUrl : "") + "\n" +  
        "現在的狀態是：" + info.checked + "\n" +  
        "之前的狀態是：" + info.wasChecked  
    );  
}  

function createMenus() {  
    var parent = chrome.contextMenus.create({  
        "title": "你選擇了%s",  
        "contexts": ['all'],      
        "onclick": genericOnClick  
    });  

    var normal = chrome.contextMenus.create({  
        "title": "通常項目",  
        "type": "normal",  
        "contexts": ['all'],  
        "parentId": parent,  
        "onclick": genericOnClick  
    });  

    var checkbox = chrome.contextMenus.create({  
        "title": "checkbox",  
        "type": "checkbox",  
        "contexts": ['all'],  
        "parentId": parent,  
        "onclick": checkableClick  
    });  

    //被separator分隔的radio項目會自動形成一個只能單選的group  
    var line1 = chrome.contextMenus.create({  
        "title": "Child 2",  
        "type": "separator",  
        "contexts": ['all'],  
        "parentId": parent  
    });  

    var radio1A = chrome.contextMenus.create({  
        "title": "group-1 的A選項(單選)",  
        "type": "radio",  
        "contexts": ['all'],  
        "parentId": parent,  
        "onclick": checkableClick  
    });  
    var radio1B = chrome.contextMenus.create({  
        "title": "group-1 的B選項(單選)",  
        "type": "radio",  
        "contexts": ['all'],  
        "parentId": parent,  
        "onclick": checkableClick  
    });  
    //被separator分隔的radio項目會自動形成一個只能單選的group  
    var line2 = chrome.contextMenus.create({  
        "title": "Child 2",  
        "type": "separator",  
        "contexts": ['all'],  
        "parentId": parent  
    });  

    var radio2A = chrome.contextMenus.create({  
        "title": "group-2 的A選項(單選)",  
        "type": "radio",  
        "contexts": ['all'],  
        "parentId": parent,  
        "onclick": checkableClick  
    });  
    var radio2B = chrome.contextMenus.create({  
        "title": "group-2 的B選項(單選)",  
        "type": "radio",  
        "contexts": ['all'],  
        "parentId": parent,  
        "onclick": checkableClick  
    });  

    // 使用chrome.contextMenus.create的方法回傳值是項目的id  
    console.log(parent);  
    console.log(normal);  
    console.log(checkbox);  
    console.log(line1);  
    console.log(line2);  
    console.log(radio1A);  
    console.log(radio1B);  
    console.log(radio2A);  
    console.log(radio2B);  
}  

createMenus();  
```

運行結果：  
![http://i.imgur.com/vSYIDA5.gif](http://i.imgur.com/vSYIDA5.gif)

> 完整範例在[Github](https://github.com/lauraluo/ExtensionSample/tree/master/ContextMenus)

## 參考資料

[https://crxdoc-zh.appspot.com/extensions/contextMenus](https://crxdoc-zh.appspot.com/extensions/contextMenus)  
[http://stackoverflow.com/questions/38190701/why-does-chrome-contextmenus-create-multiple-entries](http://stackoverflow.com/questions/38190701/why-does-chrome-contextmenus-create-multiple-entries)