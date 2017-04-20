title: Chrome Extension 開發與實作 23
date: 2017-1-6 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# Storage API 優化過的地端儲存API
使用 chrome.tabs API 與瀏覽器頁籤交互。您可以使用該 API 創建、修改或重新排列瀏覽器中的頁籤。

<!--more-->

## 設定檔權限設定

您不需要在擴展程序的清單文件中聲明任何權限就能使用 chrome.tabs 的大多數方法和事件。然而，如果您需要訪問 `tabs.Tab` 的 url、title 或 favIconUrl 屬性，您必須在清單文件中聲明` "tabs" `權限，如下所示：

```
  {
        "name": "My extension",
        ...
        "permissions": [
          "tabs"
        ],
        ...
      }
```

在前面的章節中，我們已使用過 tab的query,connect, sendMessage, executeScript, 以及 insertCSS 方法。可以參考：

* query, executeScript, insertCSS: 
    * [Chrome Extension 開發與實作 10-快捷鍵輸入組件 Shortcut Key or Commands](http://ithelp.ithome.com.tw/articles/10187354)
* connect, sendMessag:
    * [Chrome Extension 開發與實作 13-腳本組件之間訊息的傳遞(上)](http://ithelp.ithome.com.tw/articles/10187744)
    * [Chrome Extension 開發與實作 14-腳本組件之間訊息的傳遞(下)](http://ithelp.ithome.com.tw/articles/10187844)

## 頁籤型別 Tab Type

此型別表達一個頁籤的實例，在許多相關方法中的回調有提供，例如create、query等：

* nteger id：頁籤的標識符。(某些狀況可能會沒有id)
* integer index：頁籤在所在窗口中的索引，從 0 開始。
* integer windowId：頁籤所在窗口的標識符。
* integer （可選）openerTabId：使用哪個已存在的頁籤打開指定的網址。
* boolean highlighted：頁籤是否為高亮狀態。
* boolean active：頁籤是否是窗口中的活動頁籤。 （因為視窗不一定是focus的狀態。）
* boolean pinned：頁籤是否固定。(指定為tue的頁籤，不能移動，也沒有關閉鈕)
* string （可選）url：頁籤中顯示的 URL。`需要 "tabs" 權限`
* string （可選）title：頁籤的標題，如果頁籤正在加載它也可能是空字符串。`需要 "tabs" 權限`
* string （可選）favIconUrl：頁籤的收藏夾圖標 URL，如果頁籤正在加載它也可能是空字符串。`需要 "tabs" 權限`
* string （可選）status："loading"（正在加載）或 "complete"（完成）。
* boolean incognito：頁籤是否在隱身窗口中。
* integer （可選）width：頁籤寬度，以像素為單位。
* integer （可選）height：頁籤高度，以像素為單位。
* string （可選）sessionId：session標識符。(如果使用session匯入tab可能導致沒有tab的id而只有session的id)

補充一點：要注意` highlighted`與`active`是不一樣的狀態，下面附上圖例幫助大家了解
highlighted並且active
![http://ithelp.ithome.com.tw/upload/images/20170106/200794509GEptIsQD5.png](http://ithelp.ithome.com.tw/upload/images/20170106/200794509GEptIsQD5.png)

highlighted但並沒有active(因為整個視窗並沒有focus)
![http://ithelp.ithome.com.tw/upload/images/20170106/2007945009gebx2qgO.png](http://ithelp.ithome.com.tw/upload/images/20170106/2007945009gebx2qgO.png)


## 創造及刪除頁籤

### 創造一個新的頁籤

```
 chrome.tabs.create(object createProperties, function callback)
```

參數說明：


* 指定一個書籤應包含以下資訊：

    * integer （可選）windowId：創建新頁籤的窗口，默認為當前窗口。
    * integer （可選）index：頁籤在窗口中的位置，無論傳入數值多少，都會自動把數值鎖定在0~目前頁籤數之間。
    * string （可選）url：頁籤中一開始打開的 URL。完整的 URL 必須包括協議（即 "[http://www.google.com"，而不能是](http://www.google.com/) "[www.google.com"）](http://www.google.com/)，也可以是相對URL( 相對於擴展程序中的當前頁面)。默認為“打開新的頁籤”。
    * boolean （可選）active：頁籤是否應該成為窗口中的focus的頁籤，默認為 true(如果本來就是focus的頁籤則無差)。
    * ~~boolean （可選）selected：請使用 active。頁籤是否為窗口中的選定頁籤，默認為 true。~~(從 Chrome 33 開始棄用，所有跟selected有關的功能，都取得成與highigted有關的方法跟屬性)
    * boolean （可選）pinned：頁籤是否應該固定，默認為 false。(指定為tue的頁籤，不能移動，也沒有關閉鈕)
    * integer （可選）openerTabId：用某個頁籤的id來指定新創頁籤的開啟位置(即不開啟新視窗，直接取代舊的)。
* 回調中傳入一個tab型別的物件(function([**Tab**](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab) tab) {...})

### 關閉一個或多個頁籤

```
chrome.tabs.remove(integer or array of integer tabIds, function callback)
```

參數說明：

* 傳入的可以是一個整數型別的頁籤ID或是由多個頁籤ID組成的陣列。
* 回調中沒有傳入任何參數

## 維護已有頁籤

### 更新書籤

```
 chrome.tabs.update(integer tabId, object updateProperties, function callback)
```

參數說明：

* tabId：指定頁籤識別符
* updateProperties：請參考新增頁籤
* 回調中傳入一個tab型別的物件(function( [**Tab**](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab) tab) {...})

### 移動書籤

將一個或多個頁籤移動至所在窗口中的新位置，或者移動到新窗口中。注意，頁籤只能在普通窗口（window.type === "normal"）間移動。

```
 chrome.tabs.move(integer or array of integer tabIds, object moveProperties, function callback)
```

參數說明：

* tabId：指定頁籤識別符
* moveProperties：
    * int windowId：移動的目標窗口
    * int index：新位置的order，傳入-1將把頁籤排到目標窗口的最後。
* 回調型式：function( [**Tab**](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab) or array of [**Tab**](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab) tabs) {...};

### 高亮突出指定書籤/選擇書籤

```
 chrome.tabs.highlight(object highlightInfo, function callback)
```

參數說明：

* tabId：指定頁籤識別符
* 回調型式：function( **windows****.****Window** window) {...}。回傳物件包含一些有用的視窗資訊。例如：窗口與螢幕的位置關係、窗口的類型、窗口是否置頂等。(詳見 [chrome.windows API](https://crxdoc-zh.appspot.com/extensions/windows#type-Window))

### 重新載入書籤

```
 chrome.tabs.reload(integer tabId, object reloadProperties, function callback)
```

參數說明：

* tabId：指定頁籤識別符，默認為當前窗口。
* reloadProperties：{bypassCache:false } 是否跳過本地緩存， 默認為false，即默認為使用本地緩存。
* 回調中沒有傳入任何參數。



## 取得及查詢頁籤

### 取得頁籤

```
 chrome.tabs.get(integer tabId, function callback)
```

`function( [**Tab**](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab) tab) {...};`

### 獲得腳本所在的頁籤

獲得當前調用腳本所在的頁籤，如果在非頁籤環境下調用則可能返回 undefined（例如，後台頁面或彈出視圖）。

```
getCurrent − chrome.tabs.getCurrent(function callback)
```

回調格式function( [**Tab**](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab) tab) {...};

### 使用條件查詢頁

獲取具有指定屬性的所有頁籤，如果沒有指定任何屬性的話則獲取所有籤。

```
chrome.tabs.query(object queryInfo, function callback)
```

參數說明：

* 查詢的相關設置：
    * boolean （可選）active： 頁籤在窗口中是否為活動頁籤
    * boolean （可選：
    * pinned頁籤是否固定。
    * boolean （可選）highlighted：頁籤是否高亮突出。
    * boolean （可選）currentWindow：頁籤是否在當前窗口中。
    * boolean （可選）lastFocusedWindow：頁籤是否在前一個具有焦點的窗口中。
    * enum of "loading", or "complete" （可選）status：頁籤是否已經加載完成。
    * string （可選）title：匹配頁面標題的表達式。
    * string （可選）url：匹配頁籤的 URL 表達式。(注意：片段標識符不會匹配，就是不可以用`*://www.google.*`，但可以用`*//www.google.com/*`)
    * integer （可選）windowId：父窗口標識符，或者為 windows.WINDOW_ID_CURRENT，表示當前窗口。
    * enum of "normal", "popup", "panel", or "app" （可選）windowType：頁籤所在窗口的類型。
    * integer （可選）index：頁籤在窗口中的位置。
* 回調格式function(array of [**Tab**](https://crxdoc-zh.appspot.com/extensions/tabs#type-Tab) result) {...};

### 複制頁籤

取得指定頁籤的相關設定，並在回調中操作。

```
 chrome.tabs.duplicate(integer tabId, function callback)
```

回調格式如下：要注意此方法是異步的，所以不會直接回傳值，而是在回調裡進行操作，算是query的簡便用法。

```
function( Tab tab) {...};
```



## 放大縮小頁籤

### 設定縮放

```
 chrome.tabs.setZoom(integer tabId, double zoomFactor, function callback)
```

### 取得縮放值

```
chrome.tabs.getZoom(integer tabId, function callback)
```

### 修改預設縮放設置

```
 chrome.tabs.setZoomSettings(integer tabId, ZoomSettings zoomSettings, function callback)
```

### 取得預設的縮放設置

```
chrome.tabs.getZoomSettings(integer tabId, function callback)
```

回調型式：function( [**ZoomSettings**](https://crxdoc-zh.appspot.com/extensions/tabs#type-ZoomSettings) zoomSettings) {...};

設置及取得物件時，會得到ZoomSettings型別的物件實例，代表縮放設置，詳情參考[文件說明](https://crxdoc-zh.appspot.com/extensions/tabs#type-ZoomSettings)。

## 其他方法

### 注入腳本

```
 chrome.tabs.executeScript(integer tabId, InjectDetails details, function callback)
```

### 注入樣式

```
 chrome.tabs.insertCSS(integer tabId, InjectDetails details, function callback)query
```

無論是樣式還是腳本，關於插入的來源，使用InjectDetails型別代表，詳請參考官網文件：基本上除了直接導入代碼外，也能用路徑的方式指定要插入的檔案來源。還能指定是否連頁籤的iframe也要注入。


> 警告：使用 代碼注入時要特別小心，不恰當的使用可能會使您的擴展程序遭到跨站腳本攻擊。

### 偵測語言

```
 chrome.tabs.detectLanguage(integer tabId, function callback)
```

回調中提供ISO語言代碼：例如`en`或`fr`。完整例表[在這](https://src.chromium.org/viewvc/chrome/trunk/src/third_party/cld/languages/internal/languages.cc)

### 補捉當前頁籤可見區域

此方法必需擁有 `"<all_urls>"`或 `"activeTab`"權限

```
 chrome.tabs.captureVisibleTab(integer windowId, object options, function callback)
```

設定檔範例

```
"permissions" : [
    "tabs",
    "<all_urls>"
]
```

參數說明：

* 視窗的id
* options：傳入物件包含以下屬性
    * format：jpeg 或png，預設jpeg
    * quality：當指定的格式是jpeg時，可以控制圖片的儲存品質，但png會無視這個設定。
* 回調中傳入base64圖片字串：function(string dataUrl) {...};

## 與訊息有關

長時間溝通

```
 runtime.Port chrome.tabs.connect(integer tabId, object connectInfo)
```

傳送訊息

```
 chrome.tabs.sendMessage(integer tabId, any message, function responseCallback)
```


接收訊息的方法都在`chrome``.runtime`底下，例如：chrome.runtime.onConnect，詳情參考前面的章節：

* [Chrome Extension 開發與實作 13-腳本組件之間訊息的傳遞(上)](http://ithelp.ithome.com.tw/articles/10187744)
* [Chrome Extension 開發與實作 14-腳本組件之間訊息的傳遞(下)](http://ithelp.ithome.com.tw/articles/10187844)

## 事件

* onCreated：新增頁籤時產生。
* onUpdated：頁籤更新時產生。
* onMoved：頁籤移動時產生。當使用者手動移動頁籤，只會引發一次移動事件，其他因此調換順序的頁籤不會引發此事件。頁籤如果移動到另一個視窗，也不會引發此事件。
* onActivated：切換頁籤時觸發。該事件發生時，因為網頁還沒載入完成有可能取不到url，請設置onUpdated事件取得url，如果你需要的話。
* onHighlighted：高亮窗口時觸發(注意onHighlighted不一定代表onActivated)。
* onDetached：當一個頁籤脫離窗口時發生，例如：移動頁籤中。
* onAttached：當一個頁籤附加到窗口時發生。
* onRemoved：當頁籤關閉時發生。
* onReplaced：當頁籤內容被取代時發生。
* onZoomChange：頁籤縮放時發生。


## 資料

* https://crxdoc-zh.appspot.com/extensions/tabs#method-detectLanguage
* https://developer.chrome.com/extensions/tabs#method-captureVisibleTab



