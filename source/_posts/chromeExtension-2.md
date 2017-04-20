title: Chrome Extension 開發與實作 02
date: 2016-12-16 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---
# 官網導讀：快速打造一個chrome extension

快速的建立我們第一個 `Chrome extension`，這裡我們將了解一個`extension`最基本構成及其操作。

## 簡單的定義什麼是 Chrome extension

Chrome extension，允許工程師使用前端領域裡早已熟悉的javascript + css + html 三大元素，來操作Chrome的核心功能。

<!--more-->

## 任務/Feature

* 放置一個可點擊icon在網址列的右邊
* 點擊後會展開一個POP視窗
* 裡面包含目前瀏覽網站的網址及網站的圖片(任選一張)。

> 這樣的一個放置在網址列右邊的UI元素，我們稱之為[browser action](https://developer.chrome.com/extensions/browserAction)。

![](https://quip.com/blob/SOQAAAWsZ6a/_SpR6z5_oKOkgpuYGNyakA?a=cQKpYAYsqIGIbpU6gFaft7bwa5JuUwKiAyX65HUyaHoa)

## 第一步：制作擴充功能的安裝檔( manifest.json )

每個外掛都擁有一個 JSON格式的安裝檔，檔名是manifest，副檔名(.json)，他提供了很多重要的資訊，例如extension的名字，版本。更進階的實作中，我們會用他來定義extension的行為，還有需要什麼權限。

安裝檔中的，幾個要點：

* 我們定義了行為是[browser action](https://developer.chrome.com/extensions/browserAction)
* 為了權取使用者目前瀏覽網頁的URL，我們需要 [activeTab 權限](https://developer.chrome.com/extensions/activeTab)
* 為了使用外部的Google Image search API.我們需要設定主機[權限](https://developer.chrome.com/extensions/declare_permissions)

```
{
  "manifest_version": 2,

  "name": "Getting started example",
  "description": "This extension shows a Google Image search result for the current page",
  "version": "1.0",

  "browser_action": {
    "default_icon": "icon.png",
    "default_popup": "popup.html"
  },
  "permissions": [
    "activeTab",
    "https://ajax.googleapis.com/"
  ]
}J
```

[下載完整的安裝檔](https://developer.chrome.com/extensions/examples/tutorials/getstarted/manifest.json)，並將之存在一個first_extension目錄底下。


> 關於權限所有細節設定，我們可以查看[官方權限列表](https://developer.chrome.com/extensions/declare_permissions)。

> 在設定JSON檔的時後，務必使用正確的Json 格式，我們可以使用免費的線上工具[JSONLint](http://jsonlint.com/)來驗証我們的安裝檔的格式是否正確。

## 第二步：制作界面，載入相關資源

我們注意到上面的安裝檔中，有一個用來模述browser_action相關資源的區塊(icon.png及popup.html)，但這僅僅只是設定，讓我們開始制作它們。


* icon.png
    * 呈現在網址列右邊的icon
    * 在[這裡下載](https://developer.chrome.com/extensions/examples/tutorials/getstarted/icon.png)範例中icon.png檔，並將之存放在first_extension目錄底下 
    * 你也可以自己客制化，圖片檔式是一個 19px X 19 px 的正方形 PNG 檔。
* popup.html
    * 使用者點擊網址列旁的icon後，出現的POP視窗
    * 一個標準且完整的HTML檔(包含doctype、head、body)，並且你也可以使用CSS去客制化他的長相。
    * 在[這裡下載](https://developer.chrome.com/extensions/examples/tutorials/getstarted/popup.html)範列中的html檔，並將之存放在first_extension目錄底下 。
* popup.js
    * 目前實作功能的主要的操作邏輯
    * 這一隻JS檔沒有記載在安裝檔裡，而是在popup.html裡載入
    * ![](https://quip.com/blob/SOQAAAWsZ6a/CsyfYsNkhTZnoAjuPVzaug?a=bxpLhVFO9GWlzC7pIT4KG67Pu95Y4HWMW2YXElHTf5Ea)

    * 關於操作邏輯的實作的細節我們留到後面再探討
    * 在[這裡下載](https://developer.chrome.com/extensions/examples/tutorials/getstarted/popup.js)範列中的js檔，並將之存放在first_extension目錄底下 。

教程到目前為止，你應該擁有的檔案及結構
![](https://quip.com/blob/SOQAAAWsZ6a/ffhj5mUVSKq4iDTPEWGg8w?a=m8pJCqMHqQzXOatsQfJt1EkEanb4lNaY2UXdN8GAkFYa)

## 第三步：載入擴充功能

如果我們經過Chrome Web Store來安裝擴充工具，下載的會是一個副檔名為`.crx`的打包檔，但這樣對開發人員一點也不有善，不利於開發與測試。所以接下來我們使用Chrome提供的快捷方法載入位於地端的套件檔。

* 打開你的擴充工具管理介面：
* 在網址列輸入 `chrome://extensions`
* 或是使用界面進入管理介面：點擊右上角界面 > 更多工具 > 擴充功能
![](https://quip.com/blob/SOQAAAWsZ6a/M3izZiIo3Gty42RP5WJ3vQ?a=Rh3saRf7DIiZjDUSzbPKy3fGzGf5sw1YsxvmXaYhO6Ia)

* 確定套件管理界面中的開發者模式已勾選
![](https://quip.com/blob/SOQAAAWsZ6a/aUp-wYmiGxC2LwNIM_bqoQ?a=CokqoHVSzWffYWm5cQutaz0sSWqhL4Xf5AkaALZpHrwa)

* 點擊載入未封裝擴充功能，選擇你的first_extension所在位置
![](https://quip.com/blob/SOQAAAWsZ6a/j1GAa2eEplWcsA8LMmPvdg?a=aQ1JZgUIY4sk5a4Crm1TBVY1oeRXLheBdHya6a60bJoa)


完成後，你就可以成功的在右上角看到你的第一個擴充工具
![](https://quip.com/blob/SOQAAAWsZ6a/YmamZV0b6J2x00NjRahfUg?a=L25CeaeN3UeKlNYSoX1N3aNPrSV6DhXRDtX0SUFmlBka)

## 更新我們的擴充工具

我們決定加上一個 UI上的小改善 ，使用內建的default_title屬性，讓我們的使用者hover到套件的icon時，可以經由tooltip大至了解他的互動方式。

```
{
  ...
  "browser_action": {
    "default_icon": "icon.png",
    "default_popup": "popup.html",
    "default_title": "Click here!"
  },
  ...
}
```

更新了我們的安裝檔，你還需要重新載入它。進到擴充工具管理界面，按下command + R 或是點擊 擴充套件上的重新載入，讓新的設定檔發揮作用。
![](https://quip.com/blob/SOQAAAWsZ6a/tN2BIV1yrn6KfJ31zLIFnQ?a=nDAtRN15I8n7tP3Zk6emDnPOV0oN4bMzcJl6a9M6cGAa)

![](https://quip.com/blob/SOQAAAWsZ6a/-wwSGjwLRKPZID5k7tcu3g?a=5qk4m32ILcaL32JDUAPYngYAQ2yNrqTuBtFmjqbWajwa)

## Debug 我們的擴充工具

### 檢查我們的popup內容：

方法一：在icon上點選右鍵，選擇檢查彈出式視窗
![http://ithelp.ithome.com.tw/upload/images/20161216/20079450uqv06ap7oz.png](http://ithelp.ithome.com.tw/upload/images/20161216/20079450uqv06ap7oz.png)

此時將會跳出Chrome的Developer Tool，那麼你就可以像平常的網頁去Debug。
![](https://quip.com/blob/SOQAAAWsZ6a/I6DdLyf4ILiWfnayPylUcg?a=9fFCGJT1GlSg5q9udYaS5Qk1UtcFb1zcBiVEQzioW8oa)

因為developer tool的畫面只能在彈出視窗運行期間開啟，此時js已載入完畢，但我們可以在console下輸入location.reload(true)來重新載入畫面。這樣以來便能在彈出視窗開啟的狀態下，重新載入JS(方便下中斷點)。

方法二：在擴充工具的管理界面上可查詢到extension的ID(如下圖一)
![](https://quip.com/blob/SOQAAAWsZ6a/b2x5A0qhdKoYdGWQAceDXA?a=FypRmf8kryJJU0RPRI92FuIycN32jA9qBSneHILgzkMa)

然後在網址列輸入**chrome-extension://extensionId/filename**(如下圖二)，你可以訪問extension裡的所有靜態檔案。同樣可以呼叫developer tools 進行DEBUG作業。
![](https://quip.com/blob/SOQAAAWsZ6a/QkZo5_lFPE2I0_8l14qJIQ?a=F0IRadJZGakG7HN6JVXBTzDaSQ3YXnx97bUrG8H9dK8a)

但此模式下，無法模擬需要取得使用者當下瀏覽的畫面的資訊，所以請視情況選擇你的debug方案。

## 小結 

* 我們學到了一個extension的基本組成元素，在一下個段落中，我們將進一步展開完整的結構。
* 我們學會了不經由Chrome Web Store的正式發佈，很速的在地端進行開發及debug。

## 補充

*  雖然官方的教程如此，但google search image API 已經棄用，所以大家意會就好，也許後面我們可以討論替代方案。

## 資料來源

https://crxdoc-zh.appspot.com/extensions/getstarted
https://developer.chrome.com/extensions/getstarted