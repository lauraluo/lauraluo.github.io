title: Chrome Extension 開發與實作 21
date: 2017-1-4 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 推送系統通知 chrome.notifications

使用 chrome.notifications API 通過模板創建豐富通知，並在系統介面顯示這些通知。

<!--more-->

## 安裝檔的權限設定

```
{
    …
    "permissions" : [
        "notifications"
    ]
    …
}
```

## 創造一個通知

```
chrome.notifications.create(id, options, creationCallback);
```

參數說明：

* notificationId：如果沒傳值，則會生成一個新的識別符並回傳，如果傳入已經有的識別符，他會先清除指定ID的通知如果沒有的話，會以此值作為id。
* options：通知的內容設定(一個被定義為[NotificationOptions](https://crxdoc-zh.appspot.com/extensions/notifications#type-NotificationOptions)型別的物件，下面會說明細節)。
* 回調會帶入此通知的notificationId。

## 通知的設置細節(**NotificationOptions**)：

通知的設定通過型別[NotificationOptions](https://crxdoc-zh.appspot.com/extensions/notifications#type-NotificationOptions)定義，一個通知的設定包含以下屬性：


* [TemplateType](https://developer.chrome.com/extensions/notifications#type-TemplateType) type`*`：指定顯示類型的通知，為特定字串的列舉，詳情請參考開頭的`通知的模版類型`。
* string  iconUrl`*`：通知的圖標。
* string  appIconMaskUrl：通知圖標的遮罩(Chrome 38.才開始支援)，此圖片需要有透明的部份才有意義。也僅支援能有透明度的圖片格式。
* string  title`*`: 通知標題：例如郵件發送者的姓名），調用 notifications.create 方法時必須指定。
* string  message`*`： 通知的主要內容。
* string  contextMessage：通知的次要內容，以較小的字體顯示(從 Chrome 31 開始支持)。
* integer  priority ：通知的優先級，從 -2 到 2，-2 優先級最低，2 最高，默認為零(優先頁序會影響通知的顯示長度度及顯示方式，詳情可參考[這篇文章](https://crxdoc-zh.appspot.com/extensions/richNotifications#behave))。
* double eventTime：通知的時間戳記，表示為 1970 年 1 月 1 日以來所經過的毫秒數（例如 Date.now() + n）。
* array of object  buttons：通知動作按鈕（最多兩個）的文本和圖標，每一個物件包含以下屬性。
    * string title：按鈕的文字。
    *  string iconUrl：按鈕的icon。
* string  imageUrl：包含圖片預覽的通知`(type:image)`中圖片縮略圖的 URL。 URL 的限制與 iconUrl 相同。
* array of object  items `多項目通知類型(type:list)`的項目。：
    * string title 通知列表中某個項目的標題。
    * string message 該項目的額外詳情。
* integer （可選）progress：`顯示進度條的通知(type:`progress`)`的當前進度，從 0 到 100。(從 Chrome 30 開始支持)
* boolean （可選）isClickable：表明該通知是否會一直留在畫面上，直到使用者激活或解除該通知。(從 Chrome 32 開始支持)

> 以上屬性有打`*`號的代表`在chrome.notifications.create`方法中，是必要設定，不可省略。

> 圖片的路徑都支援 data URL 或是 blob URL以及使用相對路徑讀取extension安裝目路裡的資源。

## 通知樣版的設置(TemplateType)：

當你宣告不同的通知樣，在創造一個通知時，關係著此類型樣版會生效的可選屬性(比照上面)。

基本通知

設定值：`"basic"`
可設置組件：iconUrl, title, message, contextMessage, up to two buttons
![](http://i.imgur.com/ivFt10b.png)

設定值：`"image"`
可設置組件：iconUrl, title, message, contextMessage, image, 最多兩個 buttons
![](http://i.imgur.com/gZ9JsIk.png)

設定值：`"list"`：
可設置組件：iconUrl, title, message, items,  最多兩個 buttons
![](http://i.imgur.com/dLMwZIR.png)

設定值：`"progress"`：
可設置組件：iconUrl, title, message, progress,  最多兩個 buttons
![](http://i.imgur.com/ZXv4hgd.png)

## 更新通知


使用`notifications.create`方法返回的id來傳入此方法中，以更新通知的設置。

```
chrome.notifications.update(string notificationId, [**NotificationOptions**](https://developer.chrome.com/extensions/notifications#type-NotificationOptions) options, function callback)
```

參數說明：

*  notificationid：想更新的通知ID。
* options：參考前面的**NotificationOptions**
* 回調中會以boolen值的方式告訴你是否有匹配的通知。

## 刪除通知

使用`notifications.create`方法返回的id來傳入此方法中，以刪除指定的通知。

```
chrome.notifications.clear(string notificationId, function callback)
```

*  notificationid：想刪除的通知ID。
* 回調中會以boolen值的方式告訴你是否有匹配的通知。

## 取得所有的通知


返回當前所有通知的ID。

```
chrome.notifications.getAll(function callback)
```

比較特別的一點，回調的傳入值會是一個物件，這個物件的屬性，就是所有的通知ID：

```
function(object notifications) {...};
```

object notifications的結構如下：

```
{
    id1:true,
    id2:true
}
```

> API還有提供一個方法`notifications.getPermissionLevel`用以確認用戶是否啟用了擴充功能的通知。有需要的可以參考官網文件。

## 事件的處理

* **onClosed**：使用者關閉通知時觸發，回調中帶入以下值：
    * string notificationid：通知的id
    * boolean byUser：是否由使用者關閉
* **onClicked：**使用者點擊通知中的非按鈕區域，回調中帶入notificationid
* **onButtonClicked：**使用者點擊了通知中的按鈕區域，回調中帶入以下值：
    * string notificationid：通知的id
    * integer buttonIndex：按鈕的索引

> 其他Chrome OS only：onPermissionLevelChanged、onShowSettings事件這裡就略過不說

## 動手作看看：

### 範例說明：

來打造一個具有清單項目的通知：

* 通知上有一個按鈕，按下去的時後會在新視窗打開指定的網址。
* 按下按鈕區域以外的部份，我們會更新通知的標題。

> 這裡參考自[電子書](http://www.apress.com/us/book/9781484217740)中三章節的[NotificationsAPI](https://github.com/Apress/creating-google-chrome-extensions/tree/master/9781484217740)。但為Demo方便功能有稍作調整。

### 設定檔：

```
{
    "manifest_version" : 2,
    "name" : "通知的範例",
    "description" : "通知的範例",
    "version" : "2.0",
    "background" : {
        "scripts" : ["event.js"],
        "persistent" : false
    },
    "permissions" : [
        "notifications"
    ]
}
```

### 事件腳本：

```
//region {variables and functions}
var oneMinuteAsMilliseconds = 1 * 60 * 1000;
//getTime returns the number of milliseconds since the epoch
var currentTimeAsMilliseconds = new Date().getTime();
var notificationId = "id1";
var NOTIFICATION_TEMPLATE_TYPE = {
    BASIC: "basic",
    IMAGE: "image",
    LIST: "list",
    PROGRESS: "progress"
};
var myButton1 = {
    title: "點這裡打開新視窗",
    iconUrl: "button.png"//相對於擴充目錄底下的路徑
};
var myButton2 = {
    title: "點這裡什麼都不作",
    iconUrl: "button.png"//相對於擴充目錄底下的路徑
};
var myItem1 = {
    title: "項目標題1",
    message: "項目內容"
};
var myItem2 = {
    title: "項目標題2",
    message: "項目內容"
};
var notificationOptions = {
    type: NOTIFICATION_TEMPLATE_TYPE.LIST,
    iconUrl: "icon.png",
    title: "通知的標題",
    message: "通知內容",
    contextMessage: "通知的次要內容",
    eventTime: currentTimeAsMilliseconds + oneMinuteAsMilliseconds,
    buttons: [myButton1, myButton2],
    /*imageUrl : "icon.png",*/
    items: [myItem1, myItem2], //如果type是basic這個屬性就會沒有作用
    /*progress : 0,*/
    isClickable: true
};

chrome.notifications.create(notificationId, notificationOptions, function(id) {
    console.log("create: " + id);
    chrome.notifications.getAll(function(notifications) {
        console.log("getAll:");
        console.log(notifications);
    });
});


chrome.notifications.onClicked.addListener(function(id) { //notification-id
    console.log("onClicked: " + id);
    notificationOptions.title =  " 使用者點擊了通知(onClicked)";
    chrome.notifications.update(notificationId, notificationOptions, function(wasUpdated) {
        console.log("update: " + wasUpdated);
    });
});
chrome.notifications.onClosed.addListener(function(notificationId, byUser) {
    console.log("onClosed: " + notificationId);
});
chrome.notifications.onButtonClicked.addListener(function(notificationId, buttonIndex) {
    console.log("onButtonClicked: " + buttonIndex);
    if(buttonIndex == 0){
        chrome.windows.create({ "url": "https://github.com/lauraluo" });
    }
});
```

### 結果展示：

![](http://i.imgur.com/e8SM2n5.gif)


## 小結：

chrome.alarms可結合chrome.notifications為你的擴充功能增加通知的服務。

## 參考：

* https://crxdoc-zh.appspot.com/extensions/notifications
* https://developer.chrome.com/extensions/notifications
* https://crxdoc-zh.appspot.com/extensions/richNotifications
* http://www.apress.com/us/book/9781484217740







