title: Chrome Extension 開發與實作 05
date: 2016-12-19 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 腳本組件與擴充功能的執行階段

## 擴充套件與網頁的執行階段

基本上我們可以把Extension想成一個獨立的網站，他跟使用者載入頁面是完全獨立的兩個個體，擁有不同的執行階段，並且兩者之間只能籍由注入內容腳本來溝通(處理跨網域的問題)。

<!--more-->

![http://ithelp.ithome.com.tw/upload/images/20161219/20079450NHOrjIQpjK.png](http://ithelp.ithome.com.tw/upload/images/20161219/20079450NHOrjIQpjK.png)


處於不同執行階段的腳本當然無法直接溝通，也因此會延伸一些問題，為了幫助大家釐清這個狀況，就讓我們來看看前面提過的三個腳本類型，分別所屬哪些執行階段，又有哪些延伸議題。

* 事件腳本 Event scripts ：
    * 描述擴充功能的執行階段。
    * 為了監聽各種API提供的事件，能長時間在背景運行(但不代表永遠運行)，擔任中央控制器的角色。
    * 除了event script外，大多數的腳本都不會長時間持續運作，所以在開發時，我們比較依懶event script來實作功能邏輯。
* 彈出視窗腳本 Popup scripts：
    * 描述擴充功能的執行階段。
    * 但作為資源(src)的方式在popup html裡載入，自然只有在popup開啟的狀態下才會載入。
    * 因為上面的因素，所以有些事件，彈出腳本是監聽不到的。(例如：套件的安裝或移除事件)
* 內容腳本 Content scripts： 
    * 描述網頁環境的執行階段，而不是擴充功能的執行階段。
    * 內容腳本可視為使用者瀏覽網頁的一部份，也因此跟其他腳本類型比較起來，API的存取非常非常有限。
    * 但內容腳本能使用chrome. runtime底下的訊息API來間接使用 extension的完整功能。
    * 內容腳本能操作及維護使用者載入的網頁，這是其他兩個腳本組件作不到的事情。

三個腳本的API存取權自由度由大到小： 事件腳本 > 彈出視窗 > 內容腳本 

三種類型的腳本之間均只能間接經由chrome. runtime的訊息API來傳遞訊息。我們會在之後的章節中詳細探討message API。

## 小結

* 我們要知道不同的腳本組件，有不同的執行階段以及詞作用域，彼此之間無法直接存取對方的變數跟方法。
* 執行階段是巢狀的，因此作為最外層的Chrome提供API讓擴充功能籍由內容腳本與網頁溝通。
* 內容腳本( Content script) 是一個非常特別的存在，事實應將他視為使用者載入頁面中的一部份，而不是extension的一部份。
* 腳本之間能經由各種不同的Message API來進行間接的溝通。

## 參考資料

* 作者說明了 extension 以及 載入網頁 是兩個執行狀態，並且講解如何溝通：http://blog.walty8.com/simple-gmail-notes-chrome-extension/
* 作者認為背景頁面擔任控制器的角色：http://www.benknowscode.com/2014/06/develop-patterns-browser-extensions.html
* 作者認為 extension 跟載入網頁 可視為兩個不同的網站：http://www.tomforth.co.uk/chromeextension/
* http://www.apress.com/us/book/9781484217740
* https://developer.chrome.com/extensions

## 花絮(？)

我知道連著好幾篇都在講架構還有概念，完全沒有實作會有點悶，但這些觀念搞清楚，我們在實作的過程中才不會迷失在腳本組件裡面。(好吧，其實迷路的是我，K了好多個小時，千言萬語不如一張圖)

總之下面開始就有實作了(哦耶)。
