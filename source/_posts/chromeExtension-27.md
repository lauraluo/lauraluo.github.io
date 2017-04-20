title: Chrome Extension 開發與實作 27
date: 2017-1-10 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 替代頁面 Override Pages

替代頁面是一種使用來自您的擴展程序的 HTML 文件替換 Google Chrome 預定提供頁面的方式。除了 HTML，替代頁面通常還包含 CSS 和 JavaScript 程式碼。(基本上就是完整的網頁，能使用chrome提供的API)

<!--more-->

擴充功能可以替換以下任一頁面：


* 書籤管理器：當用戶選擇 Chrome 菜單中（或 Mac 系統上的書籤菜單中）的書籤管理器菜單項時出現的頁面。您也可以輸入 URL `chrome://bookmarks `進入該頁面。

* 歷史記錄：當用戶選擇 Chrome 菜單中的歷史記錄（或者 Mac 系統上歷史記錄菜單中的顯示所有歷史記錄）時出現的頁面。您也可以輸入 URL `chrome://history `進入該頁面。

* “打開新頁籤”頁面：當用戶創建新標籤頁或新窗口時出現的頁面。您也可以輸入 URL` chrome://newtab `進入該頁面。

> 一個擴充功能能替換一個頁面。例如，一個擴充功能不能既替換書籤管理頁面，又替換歷史記錄頁面。

## 隱身模式

“打開新頁籤”頁無無法在隱身模式 的窗口替換。其他兩個頁面如果需要替摸，則需在設定檔裡將[incognito](https://crxdoc-zh.appspot.com/extensions/manifest/incognito)屬性設定為 "spanning"(預設值)。

## 設定檔的權限設定

```
{
  "name": "我的擴充功能",
  ...

  "chrome_url_overrides" : {
    "bookmarks": "myPage.html"
    // "newtab": "myPage.html"
    // "history": "myPage.html"
  },
  ...
}
```

 `pageToOverride`可替換成以下值 ：

* `bookmarks`
* `history`
* `newtab`

## 注章事項

* 你的替代頁面應該小而快：使用者期望內置的頁面，能夠立即打開，請不要進行任何花費過長時間的操作：例如不要同步獲取網路數據：
* 你的替代頁面應該包含標題：避免使用者困惑
* 不要假定網頁是focus的狀態：因為打開新頁面時，最先獲得焦點的是網址列
* 不要試圖模仿默認的“打開新頁籤”頁面：因為能打造預定頁面功能的API不存在。

## 書中範例

### 設定檔

這裡實作的是替代“打開新頁籤”頁面，並且使用上一個段落提到的選項頁為擴充功能提供設置。當使用者打開新頁籤時，會看見他的書籤清單。

```
{
    "name" : "My New-Tab",
    "version" : "1.2",
    "manifest_version" : 2,
    "chrome_url_overrides" : {
        /*newtab,history,bookmarks*/
        "newtab" : "myNewTab.html"
    },
    "permissions" : ["bookmarks","storage"],
    /*Using an options page*/
    "options_ui" : {
        "page" : "myOptionsPage.html",
        /*Use Chrome stylesheet*/
        "chrome_style" : true
    }
}
```

### 替代頁面

```
<!DOCTYPE html>
<html>

<head>
    <title>My New-Tab</title>
    <script src="myNewTab_1.js"></script>
    <style>
    body {
        background-color: #eee;
    }
    
    h2 {
        width: 50%;
        margin: auto auto;
        text-align: center;
        color: #555;
    }
    
    ul {
        padding: 0px;
        width: 60%;
        margin-left: auto;
        margin-right: auto;
        margin-top: 100px;
        text-align: center;
        border: 2px dashed #555;
    }
    
    li {
        overflow: hidden;
        list-style-type: none;
    }
    
    a {
        text-decoration: none;
    }
    
    a:hover {
        text-decoration: underline;
    }
    </style>
</head>

<body>
    <h2>My New-Tab: Chrome Developer Bookmarks</h2>
    <ul id="list"></ul>
</body>

</html>
```

### 替代頁面腳本


腳本實作功能為：

* 取得書籤樹
* 取得完後，到storage裡去查詢，使用者有沒有設置只顯示匹配的網頁，如果有的話，將在新開啟頁面只展示匹配的網址清單
* 如果沒有設置，就列出所有的清單。

```
//region {variables and functions}
var folders = [];
var listName = "list";
var host = "developer.chrome.com";
var itemBorderRightStyle = "5px solid #666";
var itemBoxShadowStyle = "0px 0px 2px #333";
var itemBackgroundColor = "#ccc";
var storageKey = "APPEND_MATCHING_ONLY";

function appendItem(listElement, nodeURL, nodeParentTitle) {
    var li = document.createElement("li");
    var a = document.createElement("a");
    a.href = nodeURL;
    a.innerText = nodeURL + " (" + nodeParentTitle + ")";
    li.appendChild(a);
    if (nodeURL.indexOf(host) != -1) {
        li.style.borderRight = itemBorderRightStyle;
        li.style.boxShadow = itemBoxShadowStyle;
        li.style.backgroundColor = itemBackgroundColor;
    }
    listElement.appendChild(li);
}

function appendMatchingItem(listElement, nodeURL, nodeParentTitle) {
    if (nodeURL.indexOf(host) != -1) appendItem(listElement, nodeURL, nodeParentTitle);
}


function populateListV2(listElement) {
    chrome.storage.sync.get(storageKey, function(items) {
        if (!chrome.runtime.lastError && items[storageKey]) {
            folders.forEach(function(folder) {
                folder.children.forEach(function(bookmarkTreeNode) {
                    if (bookmarkTreeNode.url)
                        appendMatchingItem(listElement, bookmarkTreeNode.url, folder.title);
                });
            });
        } else {
            folders.forEach(function(folder) {
                folder.children.forEach(function(bookmarkTreeNode) {
                    if (bookmarkTreeNode.url)
                        appendItem(listElement, bookmarkTreeNode.url, folder.title);
                });
            });
        }
    });
}
//end-region



//region {calls}
document.addEventListener("DOMContentLoaded", function(dcle) {
    var listElement = document.getElementById(listName);
    chrome.bookmarks.getTree(function(bookmarkTreeAsArray) {
        var bookmarkTree = bookmarkTreeAsArray[0];
        if (bookmarkTree.children) {
            bookmarkTree.children.forEach(function(node) {
                if (node.children.length > 0) folders.push(node);
            });
        }
        populateListV2(listElement);
    });
});
//end-region
```

### 選項頁

```
<!DOCTYPE html>
<html>

<head>
    <title>My Options-Page</title>
    <script src="myOptionsPage_1.js"></script>
    <style>
    div.left {
        float: left;
    }
    
    div.right {
        float: right;
    }
    
    p.clear {
        clear: both;
    }
    </style>
</head>

<body>
    <p>
        <div class="left">
            Only display matching bookmarks?
        </div>
        <div class="right">
            <form>
                <input type="radio" name="highlight" value="1"> Yes
                <input type="radio" name="highlight" value="0" checked="checked"> No
            </form>
        </div>
    </p>
    <br>
    <p class="clear">
        <input type="button" id="save" value="Save">
    </p>
</body>

</html>
```

```
//region {variables and functions}
var storageKey = "APPEND_MATCHING_ONLY";
var items = {};
var saveButtonID = "save";
function logSuccess(task) {
    console.log("%s Successful!",task);
}
//end-region



//region {calls}
document.addEventListener("DOMContentLoaded",function(dcle) {
    var saveButton = document.getElementById(saveButtonID);
    saveButton.addEventListener("click",function(ce) {
        if(document.forms[0].highlight.value == "1") {
            items[storageKey] = true;
            chrome.storage.sync.set(
                items,
                function(){if(!chrome.runtime.lastError)logSuccess("Set-Storage");}
            );
        } else {
            items[storageKey] = false;
            chrome.storage.sync.set(
                items,
                function(){if(!chrome.runtime.lastError)logSuccess("Set-Storage");}
            );
        }
    });
});
//end-region
```

> 這裡使用的是[電子書](http://www.apress.com/us/book/9781484217740)中的範例，完整的範例參考第四章節的[OverridePages](https://github.com/Apress/creating-google-chrome-extensions/tree/master/9781484217740)

## 參考

* https://developer.chrome.com/extensions/override
* https://crxdoc-zh.appspot.com/extensions/override
* https://github.com/apress/creating-google-chrome-extensions







