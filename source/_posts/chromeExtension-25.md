title: Chrome Extension 開發與實作 25
date: 2017-1-8 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 打造螢幕錄影功能 chrome.desktopCapture (下)
續上回[Chrome Extension 開發與實作 24-打造螢幕錄影功能 chrome.desktopCapture (上)](http://ithelp.ithome.com.tw/articles/10188620)今天來講講螢幕截錄的功能實作。

<!--more-->

今天的範例實作大概為了四到五個小時，大至上照著上一個章節的規畫一步一步實作完成，但影片輸出的方案我作了一些微調，後面會談到。細節還不太夠，只能算是雛型。

完整的原始碼都放在：[GitHub](https://github.com/lauraluo/ExtensionSample/tree/master/DesktopCapture)

## 首先是設定檔

```
{
    "manifest_version": 2,
    "name": "影片截圖範例",
    "description": "影片截圖範例",
    "version": "2.0",
    "browser_action": {
        "default_title": "影片截圖範例",
        "default_icon": "play_icon.png"
    },
    "background": {
        "scripts": ["event.js"],
        "persistent": false
    },
    "permissions": [
        "desktopCapture",
        "tabs"
    ]
}
```

## 事件腳本

```
chrome.browserAction.onClicked.addListener(function() {
    chrome.tabs.create({
        url: "preview.html"
    }, function(tab) {
        console.log('window open');
    });
});
```

點擊瀏覽器按鈕，會用新頁籤打開一個已經準備好的view。

## 錄制頁面的制作

```
<body>
    <div class="content">
        <p class="ctrls">
            <a id="recodBtn" class="btn btn-primary btn-large btn-block" href="#"><span class="fui-video-24"></span>開始錄制</a>
            <a id="stopBtn" class="btn btn-large btn-block btn-danger" href="#">停止錄制</a>
            <a id="downloadBtn" class="btn btn-large btn-block btn-primary " href="#">影片下載</a>
        </p>
        <div class="row clearfix">
            <div class="live col">
                <h3>即時的串流畫面</h3>
                <video id="video" class="box" autoplay></video>
            </div>
            <div class="capture col">
                <h3>Canvas的截錄畫面</h3>
                <canvas id="canvas" class="box"></canvas>
            </div>
            <div class="result col">
                <h3>輸出影片</h3>
                <div id="resultWrap" class="box">
                </div>
            </div>
        </div>
    </div>
    <script src="jquery-3.1.1.min.js"></script>
    <script src="preview.js"></script>
</body>
```

### 畫面說明：

畫面上會有三個影象輸出區：

* live區塊：會即時顯示使用者現在正在操作的畫面。
* capture區塊：這裡會把live區塊的畫面給繪制到canvas裡。
* result區塊：當使用者停止錄影，我們會把最後錄完的片段輸出到這裡。

![http://i.imgur.com/oek7nVp.png](http://i.imgur.com/oek7nVp.png)

* 開始錄制：按下後開選擇畫面開始錄制。
* 停止錄制：停止錄制並輸出結果。
* 影片下載：點擊後下載結果影片(輸出格式是mp4)。

畫面的腳本


```
(function(exports) {
    //API兼容處理
    exports.URL = exports.URL || exports.webkitURL;

    exports.requestAnimationFrame = exports.requestAnimationFrame ||
        exports.webkitRequestAnimationFrame || exports.mozRequestAnimationFrame ||
        exports.msRequestAnimationFrame || exports.oRequestAnimationFrame;

    exports.cancelAnimationFrame = exports.cancelAnimationFrame ||
        exports.webkitCancelAnimationFrame || exports.mozCancelAnimationFrame ||
        exports.msCancelAnimationFrame || exports.oCancelAnimationFrame;


    navigator.getUserMedia = navigator.getUserMedia ||
        navigator.webkitGetUserMedia || navigator.mozGetUserMedia ||
        navigator.msGetUserMedia;


    var isRecoding = false;
    //預覽影片，使用原始的dom物件操作
    var video = document.getElementById('video');
    var videoWidth = 600;
    var videoHeight = 400;
    video.autoplay = true;
    video.height = videoHeight;
    video.width = videoWidth;

    //取得原始的dom物件，以便使用download api
    var downloadlink = document.getElementById('downloadBtn');

    //畫面展示需要，使用jquery dom 
    var dRecordBtn = $('#recodBtn');
    var dStopBtn = $('#stopBtn').hide();
    var dDownloadBtn = $('#downloadBtn').hide();
    


    //錄制畫面用的canvas
    var canvas = document.getElementById('canvas');
    canvas.height = videoHeight;
    canvas.width = videoWidth;
    //準備用來存放 requestAnimationFrame 的id 以便在停止時取消Canvas的截錄繪制
    var rafId = null; 
    //準備畢來存放，cnavas的錄制相關的物件
    var cStream = null;
    var recorder = null;
    var chunks = [];
    //串流的來源
    var sourceTrack = null;

    //開始錄制的邏輯
    function record(stream) {
        //將live區塊的影片來源跟串流接上。
        video.src = URL.createObjectURL(stream);
        shareStream = stream;

        var ctx = canvas.getContext('2d');
        sourceTrack = stream.getTracks()[0];


        function drawVideoFrame(time) {
            rafId = requestAnimationFrame(drawVideoFrame);
            ctx.drawImage(video, 0, 0, videoWidth, videoHeight);
        };
        //開始截取畫面並把requestAnimationFrame的id儲存起來以便控制

        cStream = canvas.captureStream(30);
        recorder = new MediaRecorder(cStream);
        rafId = requestAnimationFrame(drawVideoFrame);
        recorder.start();
        recorder.ondataavailable = function(e) {
            //saveChunks
            chunks.push(e.data);
        };
    };

    //處理停止的邏輯
    function stopRecord() {
        //停止影片串流的來源
        sourceTrack.stop();
        //停止Canvas錄制畫面
        recorder.onstop = exportPreview;
        recorder.stop();
        //停止請求requestAnimationFrame
        cancelAnimationFrame(rafId);
    };



    function exportPreview() {
        //顯示下載按鈕
        dDownloadBtn.show();
        //影片輸出
        var blob = new Blob(chunks);
        var vidURL = URL.createObjectURL(blob);
        var vid = document.createElement('video');
        vid.controls = true;
        vid.src = vidURL;
        vid.onend = function() {
            //釋放URL訪問object
            URL.revokeObjectURL(vidURL);
        };
        $('#resultWrap').append(vid);
        //指定下載網址跟下載檔的副檔名
        downloadlink.download = 'capture.mp4';
        downloadlink.href = vidURL;

    };

    //取得串流失敗的錯誤處理
    function getUserMediaError(error) {
        console.log('navigator.webkitGetUserMedia() errot: ', error);
    };


    //按下開始錄制鈕
    dRecordBtn.click(function() {
        if (!isRecoding) {
            isRecoding = true;
            dRecordBtn.hide();
            dStopBtn.show();

            //設定可以選擇媒體來源，以便開始處理串流
            captureRequestID = chrome.desktopCapture.chooseDesktopMedia(["screen", "window", "tab"], function(streamId) {
                var audioConstraint = {
                    mandatory: {
                        chromeMediaSource: 'desktop',
                        chromeMediaSourceId: streamId
                    }
                };
                //使用 Navigator.getUserMedia拿到串流並開始處理
                navigator.getUserMedia({
                    audio: audioConstraint,
                    video: {
                        mandatory: {
                            chromeMediaSource: 'desktop',
                            chromeMediaSourceId: streamId,
                            maxWidth: screen.width,
                            maxHeight: screen.height
                        }
                    }
                }, record, getUserMediaError);
            });
        }
    });
    //按下停止錄制鈕
    dStopBtn.click(function() {
        if (isRecoding) {
            //處理停止事件
            stopRecord();
            //處理UI
            isRecoding = false;
            dRecordBtn.show();
            dStopBtn.hide();

        }
    });
})(window);
```



截錄畫面時，利用[HTMLCanvasElement.captureStream()](https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/captureStream)錄制畫面的相關程式碼片段。

本來在上一篇的規畫，我們應該把canvas輸出成webp再處理成webm，但我在實作上遇到了一些無法解決的問題，導致無法輸出成果，後來發現canvas直接有API提供串流，所以我就換了個作法。

```
cStream = canvas.captureStream(30);
recorder = new MediaRecorder(cStream);
rafId = requestAnimationFrame(drawVideoFrame);
recorder.start();
recorder.ondataavailable = function(e) {
    //saveChunks
    chunks.push(e.data);
};
```

## 結果展示
![http://i.imgur.com/iFZ6wVK.gifv](http://i.imgur.com/iFZ6wVK.gifv)
呃…不支援gifv檔，那我直接付上連結，晚點看要不要傳到youtube。
[Demo 動圖](http://i.imgur.com/iFZ6wVK.gifv)

完整程式碼在[GitHub](https://github.com/lauraluo/ExtensionSample/tree/master/DesktopCapture)，大家可以參考[Chrome Extension 開發與實作 02-官網導讀：快速打造一個chrome extension](http://ithelp.ithome.com.tw/articles/10186039)下載到地端載入到擴充功能裡玩看看。

## 議題
* 影片下載的實作不算完成，雖然能成功下載mp4檔，但影片無法跳時播放，也無法被mac的影片播放器讀取，這部份我再找時間深入研究看看。
* 使用HTMLCanvasElement.captureStream取得的影片ffmpeg的格，這又是另一個大坑，有興趣的人請[參考這篇入門文章](http://einverne.github.io/post/2015/12/ffmpeg-first.html)。
* 關於取得視圖的一些雷：
    * 按官方說法可以用利extension.getview來操作擴充功能打開的視圖中所有的dom物件，原本想直接在事件腳本中使用extension.getview()，來取得打開的頁籤內容進行操作。
    * 但是發現在tabs.create方法的回調中無法直接取得到這個頁面，必需等上一段時間(settimeout)，表示回調調用時，頁籤視窗還沒準備好。
    * 後來換成window.open，無論我怎麼onread，也取不到完整的dom物件，一樣也是要等上一段時間，爬了很多文章，最後只好放棄。
    * 另外就是事實有一個跟window.open很像的api叫chrome.windows，他也可以用來創造視窗，但extension.getview無法取得他開啟的視窗。
    * 總之getview很詭異，都不照常理來，我卡了兩個多小時最後只好放棄。

## 題外話一下
關於canvas可以輸出成影片這件事，再加上可以取得影片畫畫面來繪圖，我們應該就能利用它作到影片跟動畫(2d canvas or webgl)的合成功能。我覺得蠻值得深入研究，找時間玩起XD。(題外的題外：[這是之前玩webgl的一些實例](https://github.com/lauraluo/webGlDemo))。

## 參考

* http://stackoverflow.com/questions/38924613/how-to-convert-array-of-png-image-data-into-video-file
* https://developer.mozilla.org/en-US/docs/Web/API/MediaStream_Recording_API
* https://developers.google.com/web/updates/2015/07/mediastream-deprecations?hl=en#stop-ended-and-active
* https://www.webrtc-experiment.com/RecordRTC/
* https://developer.mozilla.org/zh-TW/docs/Web/API/Blob
* https://developer.mozilla.org/zh-TW/docs/Web/API/URL/createObjectURL
* http://einverne.github.io/post/2015/12/ffmpeg-first.html



