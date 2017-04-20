title: Chrome Extension 開發與實作 22
date: 2017-1-5 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# Storage API 優化過的地端儲存API
擁有[localStorage API ](https://developer.mozilla.org/zh-TW/docs/Web/API/Window/localStorage)相同的能力，允許你使用腳本在地端用資料庫的形式存取資料，但針對擴充功功能的開發特別優化，以下是Chrome Storage API特有的功能：

<!--more-->

* 使用者的數據可以通過 Chrome 瀏覽器的同步功能自動同步（使用 `storage.sync`）。
* 擴充功能裡的內容腳本可以直接訪儲存的數據(不需要背景頁面)。
* 效能上作過優化，Storage API是異步的，並且能夠進行大量的讀寫操作，因此比阻塞和串行化的 localStorage API 更快。
* 用戶數據可以存儲為物件的型式（localStorage API 以字串的方式儲存數據）。
* 其他：下面這部份電子書直接略過，以下僅作為我自己的心得筆記。

    * 即使是隱身分離行為(split incognito behavior)，使用者的擴充功能設置也能被保留(`註一`)。
    * 可以讓擴充功能讀取設定檔，這個設定檔描述了由管理員設定的企業政策(`註二`)。(使用storage.managed與schema檔  )

> 註一：隱身分離行為(split incognito behavior)指是是，擴充功能的設角檔中可以使用關鍵字 `"incognito"`指定隱身模式下運行的行為是什麼，詳情看[這裡](https://developer.chrome.com/extensions/manifest/incognito)。就字面上來看：隱身分離行為，指是是將其值指定為 `"split"`，代表如果開發著設置了背景頁面，則在隱身模式下也會運行另一個背景頁面，但擁有自己的cookie(在記憶體中)。兩者之前並不互通。所以我推測文件中指的，隱身模式下設定的保留應該指的是即始隱身模式的所有視窗關閉，下一次開啟時擴充功能的一些設置還是能被保留。



> 註二：有關企業政策(Enterprise policies)，這裡我稍微爬了一下文，似乎是指單一擴充功能的相關設定，可以放在一個單獨的檔案裡(schema 檔)，並且籍由讓腳本讀取這個檔案，可以對該擴充功能作預先設定，用於你有大批電腦要作相關設定的時後用。根據範例來看：可能可以用於讓擴充功能鎖定這個設定檔裡的網站，而且後面會介紹到storage.managed是唯讀的，不過這只是我的推測，並不是十分確定。有興趣看細節的人可以參考[官網的教程](https://developer.chrome.com/extensions/manifest/storage)。



## 安裝檔

```
{
    "name": "My extension",
    ...
    "permissions": [
        "storage"
    ],
    ...
}
```

## 選擇你的儲存方案

* storage.local：資料只存取在這部本機的地端
*  storage.sync：使用`storage.sync`所有資料會同步到使用者已登入的Chrome瀏覽器，如果使用者關閉同步，或是沒有網路狀態，他的功能與storage.local無異。
* storage.managed：唯讀的，在安裝檔中可以指定讀取的來源檔案，以下為例：

```
{
  "name": "My enterprise extension",
  "storage": {
    "managed_schema": "schema.json"
  },
  ...
}
```


`注意*`：不該儲存使用者的機密信息，因為儲存區沒有加密。

`注意*`：考慮到效能問題，不同的儲存方案有其儲存大小及操作頻率的限制，當超過這個限制，你會收到[runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)。有關於每種類型的儲存的操作限制可以參考[官網的文件](https://crxdoc-zh.appspot.com/extensions/storage#property-sync)。

## 設定及取得數據

### 設定數據

```
StorageArea.set(object items, function callback)
```

參數說明：

* items：只需輸入要更新的 key/value Object，其他已設置舊數據不會被其影響。
* 失敗時回調中會設置 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)，協助你判斷成功還是失敗。

### 取得數據

```
StorageArea.get(string or array of string or object keys, function callback)
```

參數說明：


* 想取得的key，可以傳入單個鍵、多個鍵的陣列或者指定默認值的Dictionary Object。想取得整個儲存物件請傳入`null`。
* 失敗時回調中會設置 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)，協助你判斷成功還是失敗。

### 範例

```
chrome.storage.sync.set({"color":"red"},function() {
    console.log("set");
    //string or array of string or object keys
    chrome.storage.sync.get("color",function(items) {
        console.log("get");
        console.log(items);
    });
});
```

## 刪除數據

### 刪除指定的數據

```
StorageArea.remove(string or array of string keys, function callback)
```

參數說明：

* keys:：表示想刪除的內容：可以是單個鍵或是鍵的陣列。
* 失敗時回調中會設置 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)，協助你判斷成功還是失敗。

### 刪除全部的數據

```
StorageArea.clear(function callback)
```

* 失敗時回調中會設置 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)，協助你判斷成功還是失敗。

## 其他

### 取得目前項目使用的空間大小 (in bytes) 

```
StorageArea.getBytesInUse(string or array of string keys, function callback)
```

參數說明：

* keys:：表示想刪除的內容：可以是單個鍵或是鍵的陣列，想獲得全部儲存物件的大小請傳入`null`
* 成功時回調中會傳入integer的方式傳入bytes數，失敗時會設置 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)。

## 數據改變的事件

```
chrome.storage.onChanged.addListener(function callback)
```

回調形式如下：

```
function(object changes, string areaName) {...};
```

回調傳入參數說明：

changes物件結果如以下範例所示：

```

chrome.storage.onChanged.addListener(function(changes,areaName) {
    console.log(changes);
});

chrome.storage.sync.set({"color":"balck","color2":"yellow"},function() {});

chrome.storage.sync.set({"color":"","color2":""},function() {});
```

結果如下：注意change事件只有在已有的欄位變更時才會觸發，新增欄位不會觸發。

```
{
    color: {
        newValue: ""
        oldValue: "balck"
    },
    color2: {
        newValue: "",
        oldValue: "yellow"
    }
}
```

areaName代表對應的儲存區是：`"sync"`、`"local"`或 `"managed"`

## 參考

* https://crxdoc-zh.appspot.com/extensions/storage#type-StorageChange
* https://developer.chrome.com/extensions/storage
* http://www.apress.com/us/book/9781484217740


