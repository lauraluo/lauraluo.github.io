title: Chrome Extension 開發與實作 16
date: 2016-12-30 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# API簡介：擴充功能可以作到哪些一般網站作不到的事？


鐵人賽來到了第十六天，開頭就來個中場休息復習一下我們前面學習的東西：  

<!--more-->

Extension的開發架構：  

*   [Chrome Extension 開發與實作 03-官網導讀：架構總覽Architecture Overview](http://ithelp.ithome.com.tw/articles/10186334)  
*   [Chrome Extension 開發與實作 04-名詞定義：架構的組成部份](http://ithelp.ithome.com.tw/articles/10186466)  

架構底下的各種腳本組件：  

*   [Chrome Extension 開發與實作 05-腳本組件與擴充功能的執行階段](http://ithelp.ithome.com.tw/articles/10186595)  
*   [Chrome Extension 開發與實作 06-事件腳本與背景頁面](http://ithelp.ithome.com.tw/articles/10186775)  
*   [Chrome Extension 開發與實作 07-內容腳本(content script)之臉書下雪了](http://ithelp.ithome.com.tw/articles/10186935)  

各種輸入組件：  

*   [Chrome Extension 開發與實作 08-輸入組件:瀏覽器按鈕與頁面按鈕](http://ithelp.ithome.com.tw/articles/10187070)  
*   [Chrome Extension 開發與實作 09-啟用頁面按鈕](http://ithelp.ithome.com.tw/articles/10187228)  
*   [Chrome Extension 開發與實作 10-快捷鍵輸入組件 Shortcut Key or Commands](http://ithelp.ithome.com.tw/articles/10187354)  
*   [Chrome Extension 開發與實作 11-輸入組件 右鍵功能選單(chrome.contextMenus)](http://ithelp.ithome.com.tw/articles/10187476)  
*   [Chrome Extension 開發與實作 12-網址列輸入組件(chrome.omnibox)](http://ithelp.ithome.com.tw/articles/10187579)  
*   [Chrome Extension 開發與實作 15-使用Vue打造內容UI 輸入組件(Content UI)](http://ithelp.ithome.com.tw/articles/10187964)  

腳本組件的溝通  

*   [Chrome Extension 開發與實作 13-腳本組件之間訊息的傳遞(上)](http://ithelp.ithome.com.tw/articles/10187744)  
*   [Chrome Extension 開發與實作 14-腳本組件之間訊息的傳遞(下)](http://ithelp.ithome.com.tw/articles/10187844)  


下個段落將進一步展開，細看Chrome 提供的各種Javascript API幫助你更具體的了解擴充功能開發的各種可能性。  (事實上Chrome幾乎開放了大部份的瀏覽器功能給開發者)，在進入下一個段落前，先讓我們快速的瀏覽所有的API，為了方便記憶跟理解，我將API根據特性歸納了幾種類型：  

> 官網上API照字母排列，實在不利用吸收跟學習 ，所以我自己進行了分類，幫助我理解擴充功能到底能作到哪些事情。

### 輸入組件：

前面已經介紹完了  

*   [chrome. omnibox](https://crxdoc-zh.appspot.com/extensions/omnibox) 網址列輸入組件   
*   [chrome.contextMenus](https://crxdoc-zh.appspot.com/extensions/contextMenus) 右鍵功能選單輸入組件  
*   [chrome.commands](https://crxdoc-zh.appspot.com/extensions/commands) 快捷鍵輸入組件   
*   [chrome.pageAction](https://crxdoc-zh.appspot.com/extensions/pageAction) 頁面按鈕輸入組件   
*   [chrome. browserAction](https://crxdoc-zh.appspot.com/extensions/browserAction) 瀏覽器按鈕輸入組件  



### 開發擴充功能的輔助相關：

*   [alarms](https://crxdoc-zh.appspot.com/extensions/alarms)：委託瀏覽器在指定的時間/或是指定周期執行程式碼。  
*   [events](https://crxdoc-zh.appspot.com/extensions/events)：命名空間包含API分發事件使用的通用類型，以便在某些有意義的事情發生的時後通知你。  
*   [i18n](https://crxdoc-zh.appspot.com/extensions/i18n)：讓你的擴充功能擁有多國語系支援  
*   [runtime](https://crxdoc-zh.appspot.com/extensions/runtime)：獲取後台網頁，返回安裝設定檔的資訊，監聽並響應擴充功能生命週期內的事件，您還可以使用該API將相對路徑的URL轉換為完全限定的URL。  
*   [permissions](https://crxdoc-zh.appspot.com/extensions/permissions)： 使用腳本來動態要求原本要在安裝檔宣告的權限。  
*   [declarativeContent](https://developer.chrome.com/extensions/declarativeContent)： 在指定的內容裡執行特定的動作，我們在啟用頁面按鈕的時後有提到。  
*   [extension](https://developer.chrome.com/extensions/extension)：所有的擴充功能裡的腳本跟頁面可以使用這個共同的實例來進行溝通。  


### 瀏覽器設定相關：

*   [browsingData](https://crxdoc-zh.appspot.com/extensions/browsingData)：允許從地端中移除一些使用者的暫存資料，例如cookie、暫存、緩存、瀏覽紀錄錄等。  
*   [contentSettings](https://crxdoc-zh.appspot.com/extensions/contentSettings)  ：   
    *   控制網站能否使用 Cookie、JavaScript 和插件之類的特性。大體上說，內容設置允許您針對不同的站點（而不是全局地）自定義 Chrome 瀏覽器的行為。  
    *   例如：允不允許顯示圖片，允不允許設置Cookie，是否運行Javascript。是否運行插件，是否允許顯示彈出視窗，是否允許桌面通知。  
*   [fontSettings](https://crxdoc-zh.appspot.com/extensions/fontSettings)  管理 瀏覽器的字體設置  
*   [privacy](https://crxdoc-zh.appspot.com/extensions/privacy)：控制有關影響使用者隱私權的瀏覽器設定。  
*   [proxy](https://crxdoc-zh.appspot.com/extensions/proxy)：代理服務器設定   
*   [history](https://crxdoc-zh.appspot.com/extensions/history) 使用 chrome.history API 與瀏覽器的歷史記錄交互，您可以添加、刪除、通過 URL 查詢瀏覽器的歷史記錄。如果您想要使用您自己的版本替換默認的歷史記錄頁面，請參見[替代頁面](https://crxdoc-zh.appspot.com/extensions/override)。  
*   [bookmarks](https://crxdoc-zh.appspot.com/extensions/bookmarks) ： 操作瀏覽器書籤，你可以自定義一個書籤管理頁面，請參見[替代頁面](https://crxdoc-zh.appspot.com/extensions/override)。  
*   [cookies](https://crxdoc-zh.appspot.com/extensions/cookies)：能查詢和修改Cookie，並在Cookie更改時接收通知。  
*   [topSites](https://crxdoc-zh.appspot.com/extensions/topSites) 使用 chrome.topSites API 訪問“打開新的標籤頁”頁面中顯示的“常去網站”。  
*   [sessions](https://developer.chrome.com/extensions/sessions)：使用它可以查詢或是復原一個瀏覽器工作階段的頁籤或是視窗。  
*   [downloads](https://crxdoc-zh.appspot.com/extensions/downloads) ：使用程式碼開始下載， 監視，操作搜尋。  
*   [webRequest](https://crxdoc-zh.appspot.com/extensions/webRequest) ：網頁請求的生命周期事件。  
*   [windows](https://crxdoc-zh.appspot.com/extensions/windows)  可以使用該模塊創建、修改和重新排列瀏覽器中的窗口。  
*   [tabs](https://crxdoc-zh.appspot.com/extensions/tabs)  可以使用該 API 創建、修改或重新排列瀏覽器中的標籤頁。  
*   [management](https://crxdoc-zh.appspot.com/extensions/management) ：管理已經安裝並且正在運行的擴充功能，當你想重新設計內建的"新增頁籤頁面"(同樣參考[替代頁面](https://crxdoc-zh.appspot.com/extensions/override))中邏列的擴充功能清單時，這個API特別有用。(如下圖)  
*   <span data-section-style="11" style="max-width:100%">![](https://quip.com/blob/QHSAAAwyxNG/a7t53MREEtsOUHWxa9L1AQ?a=fGdRLzJZXjuXBUQ5lTNhyLPGSwl83TVGf9w7yISoB4sa)</span>
*   [webNavigation](https://developer.chrome.com/extensions/webNavigation)  chrome的導航操作相關的通知。  



### 開發人員工具相關 ：

協助你為開發人員工具新增功能，例如[Vue developertool](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd)。  
![](https://lh3.googleusercontent.com/zfUws9vbcxMXz8Ad_PxLlcq8e1dodaV_rymPGJFUdvaOptRDR0lZOrH2ZiJw34qirwAR7YHF=s1280-h800-e365-rw)

*   [devtools.inspectedWindow](https://developer.chrome.com/extensions/devtools.inspectedWindow)：與開發工具視窗溝通，在窗口的上下文中執行程式碼，重新加載網頁或者獲取網頁中所有資源的列表。  
*   [devtools.network](https://developer.chrome.com/extensions/devtools.network)：獲得開發者工具裡有關network面板中顯示的與網絡請求相關的信息。  
*   [devtools.panels](https://developer.chrome.com/extensions/devtools.panels)：在開發人員工具內新增面板。也可以訪問其他的面板，還可以增加側邊欄。  
*   [debugger](https://crxdoc-zh.appspot.com/extensions/debugger)：協助遠程debug相關的功能，可以查看官網的 [Get Started with Remote Debugging Android Devices ](https://developers.google.com/web/tools/chrome-devtools/remote-debugging/?utm_source=dcc&utm_medium=redirect&utm_campaign=2016q3)。  



### 作業系統相關 ：

*   [idle](https://crxdoc-zh.appspot.com/extensions/idle)：使用 chrome.idle API 檢測計算機空閒狀態的更改。   
*   [power](https://crxdoc-zh.appspot.com/extensions/power)： 使用 chrome.power API 修改系統的電源管理特性。  
*   [system.cpu](https://crxdoc-zh.appspot.com/extensions/system.cpu) 使用 chrome.system.cpu API 查询 CPU 元数据。  
*   [system.memory](https://crxdoc-zh.appspot.com/extensions/system.memory) 使用 chrome.system.memory API 獲取記憶體訊息。  
*   [system.storage](https://crxdoc-zh.appspot.com/extensions/system.storage) 使用 chrome.system.storage API 查詢存儲設備信息，並在連接或移除可移動存儲設備時得到通知。 
*   [printerProvider](https://developer.chrome.com/extensions/printerProvider)： 允許擴充功能利用此API操作與列印相關的功能。   




### Google帳號相關：  



*   [gcm](https://crxdoc-zh.appspot.com/extensions/gcm)：利用goolge的[雲端訊息服務](http://developer.android.com/google/gcm/)([Google Cloud Messaging](https://developer.android.com/google/gcm/))來傳遞訊息。  

*   [identity](https://crxdoc-zh.appspot.com/extensions/identity)：使用 chrome.identity API 獲取 OAuth2 訪問令牌，可以利用它來獲取一些Chrome登入的帳號資料。  

*   [pushMessaging](https://crxdoc-zh.appspot.com/extensions/pushMessaging)：使用 chrome.pushMessaging 使應用或擴展程序能夠接收通過GCM發送消息。  

*   [storage](https://crxdoc-zh.appspot.com/extensions/storage)：具有[localStorage API](https://developer.mozilla.org/en/DOM/Storage#localStorage) 相同的功能，另外提供了，儲存，獲取，以及追踪用戶數據的更改，以及跨機器的儲存資料同步。  



> Google雲消息服務（GCM）是一項用於Android設備和Chrome應用的服務，可以向服務器發送和接收數據[.chrome.gcm API](https://crxdoc-zh.appspot.com/extensions/gcm)允許Chrome應用或擴展程序以Chrome中登錄用戶的身份訪問GCM服務。即使應用程序或擴展程序不在運行時該服務也能正常工作，例如即日使用沒有打開，日曆更新也可以推送至用戶。  
> [引用網址](https://crxdoc-zh.appspot.com/extensions/cloudMessaging)

### 其他：  

*   [desktopCapture](https://developer.chrome.com/extensions/desktopCapture)：提供畫面的串流，可以指定補獲的對象是：某個視窗、整個畫面、某個頁籤。  
*   [pageCapture](https://developer.chrome.com/extensions/pageCapture)：把頁面存取成MHTML檔。(封存的網頁檔，能用於電子郵件的寄送)  
*   [notifications](https://crxdoc-zh.appspot.com/extensions/notifications) ：通過模板創建豐富通知，並在系統托盤中向用戶顯示這些通知。  
*   [tabCapture](https://crxdoc-zh.appspot.com/extensions/tabCapture)：提供當前操作頁面的畫面串流。  
*   [tts](https://crxdoc-zh.appspot.com/extensions/tts) / [ttsEngine](https://crxdoc-zh.appspot.com/extensions/ttsEngine) ：tts提供了一些合成語音朗讀相關功能，這個我沒細看貌似還能用來播放聲音。ttsEngine提供了一些相關的事件供你操作，也能讓你使用web技術對的聲音進行合成或輸出。官方有示範用此API打造一個朗讀時heightlight他讀到哪個文字的界面(可以參考官方[範例影片](https://www.youtube.com/watch/?v=5KL_ccQwAuo)))。
*   [webstore](https://crxdoc-zh.appspot.com/extensions/webstore)：在網頁內嵌安裝擴充功能的操作。  
*   [extensionTypes](https://developer.chrome.com/extensions/extensionTypes)：The `chrome.extensionTypes` API contains type declarations for Chrome extensions.(OK這個我真的看不懂，文件寫的也少的可憐，而且我也沒看到範例)  


> 以上API不包括ChromeOS Only以及beta版的API, 完整的清單請參考[官方網站](https://developer.chrome.com/extensions/api_index)。

## API的使用權限：

根據不同的API需要在安裝檔中宣告不同的權限設定：  

```
"permissions" : [  
    "alarms", //Extensions-API permission  
    "tabs", //Extensions-API permission  
    "bookmarks", //Extensions-API permission  
    "http://www.blogger.com/", //XHR permission  
    "http://*.google.com/" //XHR permission  
],
```

官網的API文件會告訴你這個API需要的權限，以[alarms](https://developer.chrome.com/extensions/alarms)為例：  

![](https://quip.com/blob/QHSAAAwyxNG/MBvYg7bQK_AZxiwK56A2wg?a=OkaVOVHDBnhPdCFUveCOGUb1YNCoq23PRIyaI19nK88a)

權限的宣告有兩種方式：  


*   必要權限：在安裝檔中定義的權限。
*   可選權限：使用API動態在腳本中宣告的權限，更多的資訊可以查看[permissions](https://crxdoc-zh.appspot.com/extensions/permissions) API。  
    *   使用可選權限的好處之一是可以在要求權限的同時，與使用溝通要求權限的目的。  

部份權限的宣告會讓使用者看見授權畫面，細節可以查看以中文翻譯文件的[權限警告](https://crxdoc-zh.appspot.com/extensions/permission_warnings)。  

## 小結

*  我們快速的查看了所有的API，並對功能進行了歸納。歸網的結果讓我們了解了使用ChromeAPI不謹謹可以操作瀏覽器的設定，使用者的資料，Google帳號的存取，跨機器的資料同步，還可以為開發者工具新增功能，存取一些作業系統裡的操作。  
*   因為API實在太多了，接下來的十多天也不能可一一介紹，所以我會挑一些我比較有興趣的部份為大家講解。  
* 2017/1/1 - 有關於tts api的部份有誤解，已修正。
## 花絮

光是把每個API文件點開大致上看過也是花了不少時間，官網的文件寫的非常精簡，我感覺不到有想要讓我看懂的誠意，很多要把範例運行起來去看腳本才知道實際的意思(冏rz)，也有些根本就沒有範例(冏rz 2)，還有些範例有bug我得debug(冏rz 3)，所以如果我有理解錯誤的地方還請大家多多包涵。

另外還要注意文件有新舊版本的問題，雖然我為了偷懶一開始看的是中文文件，但中文跟最新的版本文件還是有落差，所以我花了一些時間作比對，另外還有些API是ChromeOS專用的API，在這裡我直接先瀘掉。

總得來說2016最後一PO，祝大家新年快樂。  

## 參考資料
待補

