title: Chrome Extension 開發與實作 24
date: 2017-1-7 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 打造螢幕錄影功能 chrome.desktopCapture (上)

使用desktopCapture可以補捉使用者單個螢幕，或是指定視窗，或是某個頁籤的畫面。

<!--more-->

## 設定檔權限

```
{
    ...
    "permissions": [
        "desktopCapture"
    ]
    ...
}
```

## 選擇來源

使用此方法會跳出系統提供的媒體來源選擇介面，如下圖。

```
chrome.desktopCapture.chooseDesktopMedia(array of DesktopCaptureSourceType sources, tabs.Tab targetTab, function callback)
```

![http://ithelp.ithome.com.tw/upload/images/20170107/20079450h1Bw1NCKGy.png](http://ithelp.ithome.com.tw/upload/images/20170107/20079450h1Bw1NCKGy.png)
上圖中我只設定了`screen`以及`window`的媒體來源供使用者選擇

參數說明：

* sources：指定供給使用者選擇的媒體來源類型，可以多個(`"screen"`, `"window"`, or `"tab"`)。
* targetTab：也可以指定直定tabID。
* callback：回調中會提供串流的識別符，開發者可以利用[MediaStream API](https://developer.mozilla.org/zh-TW/docs/Web/API/Navigator/getUserMedia)去處理串流。

另外還提供了取消選擇媒體來源視窗的方法

```
chrome.desktopCapture.cancelChooseDesktopMedia(integer desktopMediaRequestId)
```

## 實作相關

這次API很簡單，但只拿到串流來源沒什麼意義，不如讓我們直接討論實作。

基本功能：

* 使用者按下瀏覽器頁面按鈕後，選擇要錄影的來源是「螢幕、視窗、還是頁籤」。
* 使用者開始錄影時，要能提示使用者正在錄影中。
* 當錄影完成時，會出現一個預覽頁面，在裡面我們可以預覽影片，

進階功能(想作不一定有空作的部份 XD)：

* 如果使用者指定的是頁籤，我們能讓使用者在網頁裡繪圖。(受限於擴充功能的架構，我們應該無法在頁籤以外的地方實作繪圖功能，頁籤裡還能使用內容腳本結合canvas)
* 除了錄影是否能同步錄聲音，或是同步利用攝影機錄臉(單純想試)。


今天時間不太夠，先讓我介紹幾個我收集起來跟實作有關係的API，我們在下一個段落將依靠這些API來實作功能：

### 第一步：使用MediaStream API處理串流

`MediaStream` API 代表一個多媒體（影像與聲音）的同步串流（synchronized stream），開發者可以利用這個功能擷取本地端的多媒體串流，並顯示在瀏覽器上或是進行進一步的傳送或處理。我們將使用它在`chooseDesktopMedia`方法中處理串流。

```
navigator.getUserMedia(constraints, successCallback, errorCallback);
```

* `constraints`：各種參數設定的物件，是一個很大的物件，主要是用來設定stream的讀取格式，詳情參考[這裡](https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamConstraints)。
* `successCallback`：執行成功的回呼函數（callback function）。
* `errorCallback`：執行失敗的回呼函數。

### 第二步：使用Video tag 及 Canvas

在利用navigator.getUserMedia處理串流的時後，我們會將這個串流指定成一個看不見的video tag 來源，並使用他用每秒60 fps的速度(requestAnimationFrame)，在Canvas裡繪圖，並且利用canvas.toDataURL將每一偵輸出成`'image/webp'`格式，並存放在一個陣列裡。

### 第三步：將圖片轉碼成影片

接著我們會利用[whammy.js](https://github.com/antimatter15/whammy)這個WebM Encoder，把圖片轉成影片`image/webp`的陣列，轉換成`webm`的影片格式。

### 第四步：最後我們會利用Download API實作下載影片的功能

* 可以參考這篇文章：[Downloading resources in HTML5: a[download]](https://developers.google.com/web/updates/2011/08/Downloading-resources-in-HTML5-a-download)
* 裡面的範例：http://html5-demos.appspot.com/static/a.download.html

## 小結

* 這次的API牽扯有點廣，所以今天我先快速概覽了一些實作的可能性，並且在心中把預想的實作的邏輯作了一個歸納，下一個章節會利用實作証明我的推論。
* 利用canvas轉圖出影片的問題，已經預想可能會有記憶體不足的問題，這部份可能要小心。
* 本次實作只討論到了影片截取的部份，但進一步應該還會討論到影片串流遠通溝通方式(例如：遠端桌面分享)，事實上有一個web技術的網頁串流方案叫[WebRTC](https://webrtc.org/)，算是為了解決遠端的影片即時分享推出的新服務，有興趣的朋友可以去看看，提醒一下存在兼容度的問題。

## 參考

* 英文文件：https://blog.gtwang.org/web-development/webrtc-media-stream/
* 中文文件(非官方)：https://blog.gtwang.org/web-development/webrtc-peer-connection/
* 遠端影片串流的溝通API：https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection
* [Creating .webm video from getUserMedia()](https://ericbidelman.tumblr.com/post/31486670538/creating-webm-video-from-getusermedia)
* [WebRTC 入門教學（一）：多媒體影像串流擷取](https://blog.gtwang.org/web-development/webrtc-media-stream/)

