title: Chrome Extension 開發與實作 19
date: 2017-1-2 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# chrome.downloads API 使用腳本管理下載
使用chrome.downloads API以編程方式開始下載，監視，操縱，搜索下載的文件。

<!--more-->

## 權限設定

```
{
    "name": "My extension",
    ...
    "permissions": [
      "downloads"
    ],
    ...
}
```

## 下載項目型別

DownloadItem，代表下載項目任務的一個型別，此物件實例中包含非常多的屬性，以下只羅列其中一部份，幫助大家了解這個物件大概會有什麼資訊：

* integer id： 在**不同瀏覽器工作階段**中，統一的檔案識別符。
* string url/string referrer/string filename：絕對URL/相對URL/地端路徑的絕對位置。
* boolean incognito：如果該下載存在歷史下載記錄中為false，沒有則為true。
* [DangerType ](https://developer.chrome.com/extensions/downloads#type-DangerType)danger：是否為危險下載
* string startTime：下載開始時間
* string endTime：下載結束時間
* string  estimatedEndTime：下找完成的估計時間
* State state：下載狀態(進行中/已中斷/已完成)
* boolean canResume：下載是否可以回復，如果可以則為true
* double bytesReceived：目前下載的位元數。(不考慮壓縮)
* double totalBytes：整個下載的位元數，如果未知則為-1(不考慮壓縮)
* double fileSize：解壓縮的文件位元數
* string byExtensionId：如果由擴充功能發起下載，則顯示擴充功能的ID
* string byExtensionName：發起下載的擴充功能名稱
* boolean exists：下載檔案是否還存在，需要自行調用search()方法查詢檔案狀態，如果檔案已被刪除會觸發onChanged事件。
* 其他屬性見官網完整列表[DownloadItem](https://developer.chrome.com/extensions/downloads#type-DownloadItem)

## 下載檔案

```
chrome.downloads.download(object options, function callback)
```

object options 參數設定下載檔案的相關資訊，包含以下資訊：

* url (string)：下載網址
* filename (string)：檔案名稱
* saveAs (Boolean)：是否顯示另存對話框
* method ("GET"  或 "POST" 字串 )：指定的HTTP協定的資訊
* headers (array)：指定的HTTP協定的資訊
* body (string)：指定的HTTP協定的資訊 

使用說明

* 指定下載某個URL，如果該URL使用HTTP [S]協議，請求會包含當前為主機名設置的所有Cookie。
* 如果同時指定了文件名與saveAs屬性，則會顯示另存為對話框，並且初始文件名為指定稱。
* ` 如果下載成功開始，將調用回調`，並傳遞新的DownloadItem的downloadId。(注意不是直接回傳下載項目)
* `如果開始下載時發生了錯誤，將調用回調`，並傳遞downloadId：undefined，並且runtime.lastError包含描述性文字 。
* 錯誤字串並不保証在不同版本中兼容，請不用使用他來作為程式碼的判斷。


範例：

```
var downloadOptions = {
    "url" : "http://www.apress.com/downloadable/download/sample/sample_id/1456/",
    "saveAs" : true
};

chrome.downloads.download(downloadOptions,function(downloadId) {
    console.log(downloadId);
});


```

> 這裡使用的是[電子書](http://www.apress.com/us/book/9781484217740)中的範例，完整的範例參考第三章節[DownloadsAPI](https://github.com/Apress/creating-google-chrome-extensions/tree/master/9781484217740)

## 取消/復原/暫停下載

一旦你取得下載項目的ID，你可以經由ID作以下操作：

### 取消下載

```
chrome.downloads.cancel(integer downloadId, function callback) 
```

### 復原下載

如果復原失敗則[runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)將包含錯誤訊息，如果下載項目不處於有用狀態，則下載會失敗。

```
chrome.downloads.resume(integer downloadId, function callback) 
```

### 暫停下載

```
chrome.downloads.pause(integer downloadId, function callback) 
```

## 打開下載檔案

一旦檔案下載完成，你就能使用下載項目的ID來打開檔案，如果下載還沒完成，經 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)在回調中通知錯誤。

注意該方法在安裝檔中需要額外設定`downloads.open`權限，項目第一次打開時會觸發onChanged事件。

```
chrome.downloads.open(integer downloadId)
```

如果你想打開的是下載檔案的目錄，則提供以下兩個操作：

### 打開檔案所在目錄 

```
chrome.downloads.show(integer downloadId)
```

### 打開的是檔案管理系統中的默認下載目錄

```
`crome.downloads.showDefaultFolder()`
```

## 刪除下載

### 刪除已下載完成的檔案

如果指定的下載項目還未完成，經 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)在回調中通知錯誤。

```
chrome.downloads.removeFile(integer downloadId, function callback)
 
```

### 刪除下載中的紀錄

只刪除紀錄，而不刪除檔案。每刪除一個檔案，獨立觸發一次 [onErased](https://crxdoc-zh.appspot.com/extensions/downloads#event-onErased)事件，才執行callback。

```
chrome.downloads.erase(object query, function callback)
```

可以使用參數query來設定要刪除檔案的條件，符合調件的紀錄會進行批次刪除。例如，可以設定 紀錄的下載時間，有些查詢的屬性非常有用：例如：startedBefore、startedAfter(開始的時間區間)、 endedBefore、 endedAfter(結束的時間區間)、filenameRegex(檔案名稱的正規表達式)、and urlRegex(下載網址的正規表達式)，完整的query設定可以參考[官網文件](https://crxdoc-zh.appspot.com/extensions/downloads#method-erase)。

## 在各種操作回調中判斷 [runtime.lastError](https://crxdoc-zh.appspot.com/extensions/runtime#property-lastError)的方式

```
chrome.downloads.resume(downloadId,function() {
    if(!chrome.runtime.lastError) console.log("pause");
});
```


## 修改建議的下載檔名及預設的儲存動作

```
chrome.downloads.onDeterminingFilename.addListener(function callback)
```

在確定檔案文件的過程中，擴充功能有機會修改目標的文件名稱。每一個擴充功能只能設定一個此監聽器。

事件觸發的回調中，必需提供一個 `suggest()`方法，開發人員需用此方法設置建議的**檔名**及**預設的儲存動作**(覆蓋舊文件/系統自動命名/提示選擇對話框)。

預設的儲存動作的列舉

```
"uniquify", "overwrite", or "prompt"
```

* `suggest()`方法如果要異步調用，則需在事件的回調中回傳true，否則監聽器會自動調用`suggest()`方法。
* 在所有的監聽器調用`suggest()`前，下載事件不會完成。
* 如果沒有傳遞任何參數給`suggest()`則使用下載時設定的`downloadItem.filename`作為文件名。
* 如果有多個擴充功能都使用該事件試圖修改檔名，則以最後安裝並向`suggest()`傳遞設置的擴充功能優先，為避免混肴，使用者不該同時安裝多個有服務的擴充功能。

示範：在所有檔案下載完成後，使用腳本覆蓋預設檔名。

```
chrome.downloads.onDeterminingFilename.addListener(function(item, suggest) {
    suggest({
        filename: item.filename + "羅拉拉的下載",
        conflictAction: 'overwrite',
        conflict_action: 'overwrite'
    });

});
```

`注意：`實測時發現conflictAction的設定在我的電腦沒有效果，每次都會詢問我是否覆蓋文件，初步猜想可能跟 設定>進階設定>的「下載每個檔案前先詢問儲存位置」設定有關，但即使我把勾勾取消，他還是不停的跳出儲存位置的詢問，今天時間不太夠，我後面有時間會去查証。

![http://ithelp.ithome.com.tw/upload/images/20170102/20079450z3AxpNIOYC.png](http://ithelp.ithome.com.tw/upload/images/20170102/20079450z3AxpNIOYC.png)
## 其他相關事件

* onCreated—下載項目開始下載後觸發。
* onErased—刪除紀錄完成後觸發。
* onChanged—當下載項目的屬性改變時觸發(bytesReceived estimatedEndTime 這兩個屬性除外。)


> 還有一些其他操作，例如：搜尋下載、取得檔案的ICON、提示用戶這是有風險的下載、將已下載的檔案拖動到另一個應用程序中、啟用或禁用位顧瀏覽器下源的灰色下載框等，完整的清單請參考[官網文件](https://crxdoc-zh.appspot.com/extensions/downloads)。

## 小結：

試用下載API我們能實作以下功能：

* 批次下載網頁中的圖片並提供下載進度查詢。
* 針對特定的規則命名文件，並且下載到指定資料夾。
* 自己開發下載的[替代頁面](https://crxdoc-zh.appspot.com/extensions/override)，取代原本的下載管理界面。
* 提似使用者已下載過重複來源的檔案。
* 有一點可能要找時間証實，在事件onDeterminingFilenames中，使用`suggest()`方法即使設定了儲存動作，在我的電腦也沒有作用，我查詢了官網的範例以及開發人員的討論串，目前還沒找到解法。而電子書的作者是直接略過了這個API沒說。
* 對實作有興趣的朋友可以參考對岸的前端開發者邹成卓寫的[批次抓取圖片工具](https://github.com/zouchengzhuo/BigImageFetcher)



## 參考

* https://crxdoc-zh.appspot.com/extensions/downloads
* https://developer.chrome.com/extensions/downloads
* https://chromium.googlesource.com/chromium/src/+/master/chrome/common/extensions/docs/examples/api/downloads/
* http://www.apress.com/us/book/9781484217740




