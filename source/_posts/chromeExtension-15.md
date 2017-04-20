title: Chrome Extension 開發與實作 15
date: 2016-12-29 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 使用Vue打造內容UI 輸入組件(Content UI)

## 什麼是內容UI

內容UI在**Creating  Google Chrome Extensions**一書中，被作者列為開發功能的輸入組件之一，但事實上他不是屬於任何一個Chrome * API，只是一個利用內容腳本在畫面中插入HTML元素，並且使用Javascript撰寫操作邏輯的一種手段。  

<!--more-->

以evernote的擴充功能為例(如下圖)  

![](https://quip.com/blob/ccaAAA3TaO5/KeeS1RoQtddG4FbBihGVnA?a=a6mXYut4yGLgrl8aTJ0VCBg6tq65aSSu6vdu8QZqoZ4a)</div>

## 為什麼要使用內容UI輸入組件

當你擴充功能相依網站的內容比較多，需要頻繁的對載入頁面進行操作，這時選擇把擴充功能的邏輯核心挪到內容腳本上是是一個很明智的選擇。不僅擁有操作網站內容的強大自由度，並且保留了利用Chrome的訊息API間接使用Chrome核心功能的操作權力。  

## 在討論內容UI之前

使用內容腳本插入一顆按鈕並不困難，但如果你想打造的是像evernote(如上圖)這樣的互動界面，單純靠原生的javascript應該會是一場惡夢。所以在實作上，我們必需依懶框架協助開發。  

前端領域目前在探討資料與界面還有行為綁定的框架(MVVM、MVC)很多這裡我就不再贅述，剛好前陣子在玩Vue，所以就利用Vue來實作內容UI輸入組件，並且把上一篇討論的訊息傳遞融入到這個範例來，看看會長什麼樣子。  

## Vue的簡介

> 引用自官網：Vue.js（讀音/vjuː/，類似於view）是一套構建用戶界面的漸進式框架。與其他重量級框架不同的是，Vue採用自底向上增量開發的設計.Vue的核心庫只關注 視圖層，並且非常容易學習，非常容易與其庫或已有項目整合。另一方面，Vue完全有能力驅動採用單文件組件和Vue生態系統支持的庫開發的複雜單頁應用。  
>   
> Vue.js的目標是通過盡可能簡單的API實現響應的數據綁定和組合的視圖組件。

### 使用Vue開發界面的好處：(主觀意見)

*   不用進行煩人的DOM物件操作  
*   容易開發及維護  
*   100%的Javascript解決方案(還記得嗎，今天討論的是利用內容腳本打造界面)。  
*   CSS可以宣告Scope，讓樣式不要影響到載入頁面。  
*   嚴謹的資料流，在開發時可以考慮把ChromeAPI的邏輯獨立出來，使內容腳本的邏輯可以在地端進行開發，不用使用擴充功能載入的方式。(可以把從擴充功能來的訊息當作使用AJAX跟伺服器取資料的概念去處理)。  


### Vue的基本操作：

官網寫的也很好，鐵人賽也很多人在討論，這裡就不再贅述。個人感觀上View的部份寫起來像Angular1,Model的部份寫起來像React。

### 使用的環境及資料夾說明：

Vue官網提供的[browserify-simple](https://github.com/vuejs-templates/browserify-simple)，內容腳本的撰寫方式會使用官網提到的[單文件組件](https://cn.vuejs.org/v2/guide/single-file-components.html)，主要操作邏輯會寫在`src/App.vue。`，最後會產出內容腳本content.js檔，並且存放在`dist`資料夾。

除了內容腳本(content.js)之外，`dist`裡還有擴充功能需要的其他檔案，請參考下圖。`dist`目錄是最後會作為擴充功能，載入到Chrome的管理介面。

![](https://quip.com/blob/ccaAAA3TaO5/cN5Lkt7-pMlslnERY0seAg?a=wAxt9xvsxa0eorrk4TIpr0NNtdgAIq2UCa02ZoPUj1ga)

## 開始實作

### 實作功能概述：

*   利用Vue向指定網域載入一個界面，在這個界面上擁有兩組按鈕：
    *   第一組按鈕可以利由Chrome的訊息API，向事件腳本發送請求，以便啟用及關閉頁面按鈕。  
    *   第二組按鈕，點擊後可以切換內容UI的長相。  
*   實作頁面按鈕，一開始是未啟用的狀態，頁面按鈕的彈出視窗實作一個按鈕：  
    *   點擊按鈕，彈出視窗腳本會發送訊息給內容腳本請求切換內容UI的長相。  

這個實作的目的是練習：事件腳本/ 彈出事件腳本/內容腳本 之間的溝通，而內容腳本的主要邏輯會使用Vue實作。  

### 設定檔

```
{  
    "manifest_version" : 2,  
    "name" : "鐵人賽-使用vue打造ContentUI",  
    "description" : "",  
    "version" : "2.0",  
    "page_action": {  
        "default_title": "",  
        "default_icon": "icon.png",  
        "default_popup": "popup.html"  
    },       
    "content_scripts" : [  
        {  
            "matches" : ["*://www.google.com.tw/*"],  
            "js" : ["jquery-3.1.1.min.js","content.js"],  
            "css" : ["animate.css"]  
        }  
    ],  
    "background" : {  
        "scripts" : ["event.js"],  
        "persistent" : false  
    },  
    "permissions" : ["tabs"]  
}
```
*   範例實作在google頁面注入內容腳本  
*   為開發方便，在內容腳本裡會使用到[animate.css](https://daneden.github.io/animate.css/)及jquery等資源庫  

### 內容腳本的初始化

```
import Vue from 'vue'  
import App from './App.vue'  

Vue.config.silent = true;  

var initDom = document.createElement("div");  
initDom.id = "extensionUIwrap";  

document.getElementsByTagName("body")[0].appendChild(initDom);  

new Vue({  
  el: '#extensionUIwrap',  
  render: h => h(App)  
})
```

### 內容腳本的界面宣告：

App.vue

```
<template>  
    <div class="contentUI" ref="contentUI">  
        <!-- 展開時的畫面 -->  

        <!-- vue的動畫組件宣告方式，會跟v-if連動 -->  
        <transition name="custom-classes-transition" enter-active-class="animated fadeInRight" leave-active-class="animated fadeOutRight">  
            <!-- v-if 設定區塊顯示的邏輯是根據  data.toggle 這裡的內容會在切換的是後出現或消失 -->  
            <div class="contentUI__open-content" v-if="toggle">  
                <h1>擴充功能範例</h1>  
                <h2>使用vue打造內容UI，並且與擴充功能溝通</h2>  
                <p>按下按鈕向事件腳本發送訊息</p>  
                <div>  
                    <!-- v-on:click 綁定點擊事件會執行 開啟 及 關閉 頁面按鈕 方法 -->  
                    <a class="contentUI__button" href="#" v-on:click="turnOnThePageAction">開啟頁面按鈕</a>  
                    <a class="contentUI__button" href="#" v-on:click="turnOffThePageAction">關閉頁面按鈕</a>  
                </div>  
                <h2>切換內容UI的長相</h2>  
                <p>啟用頁面按鈕後，按下彈出視窗的按鈕也能切換長相</p>  
                <!-- v-on:click  綁定點擊事件會執行長相的切換 -->  
                <a class="contentUI__button" href="#" v-on:click="switchView">切換長相</a>  
            </div>  
        </transition>  

       <!-- 關閉時的畫面 -->  

       <!-- vue的動畫組件宣告方式，會跟v-if連動 -->  
        <transition name="custom-classes-transition" enter-active-class="animated fadeInRight" leave-active-class="animated fadeOutRight">  
          <!-- v-if 設定區塊顯示的邏輯是根據  data.toggle 這裡的內容會在切換的是後出現或消失 -->  
          <div class="contentUI__close-content" v-if="!toggle">  
            <!-- v-on:click  綁定點擊事件會執行長相的切換 -->  
            <a class="contentUI__button" href="#" v-on:click="switchView">切換長相</a>             
          </div>  
        <transition>          
    </div>  
</template>
```

### 內容腳本的操作邏輯宣告：

App.vue
```
  
<script>  
export default {  
  name: 'contentUI',  
  data () {  
    return {  
      //作為畫面切換的開關  
      toggle: 'false'  
    }  
  },  
  watch: {  
    toggle: function(val){  
      console.log('toggleSwitch');    
    }    
  },  
  methods: {  
    switchView: function(callback){  
    //切換參數，執行回調  
      this.toggle = !this.toggle;  

      if(callback && typeof callback == 'function'){  
        callback();  
      }  
    },  
    turnOnThePageAction: function(){  
    //向擴充功能(事件腳本)發出請求  
      chrome.runtime.sendMessage({ name: "開啟頁面按鈕" },function(response) {  
        console.log(response);  
      });  
    },  
    turnOffThePageAction: function(){  
       //向擴充功能(事件腳本)發出請求  
      chrome.runtime.sendMessage({ name: "關閉頁面按鈕" },function(response) {  
        console.log(response);  
      });  
    }  
  },  
  mounted: function(){  
    var _this = this;  
    //在組件實例安裝完成後，開始監聽來自擴充功能的事件  
    chrome.runtime.onMessage.addListener(function(message, sender, sendResponse) {  
      //注意如果有callback要使用call的方式呼叫方法  
      _this.switchView.call(_this, function(){  
        sendResponse("操作完成")  
      });  
    });  

  }  
}  
</script>
```

### 內容腳本的松式宣告：

App.vue
```
<style scoped>  
.contentUI__open-content {  
  font-family: 'Avenir', Helvetica, Arial, sans-serif;  
  text-align: center;  
  color: #2c3e50;  
  position: fixed;  
  padding: 40px;  
  right: 0;  
  top:0;  
  width: 250px;  
  z-index: 9999;  
  background: #fff;  
  height: 100vw;  
  min-height: 800px;  
  box-shadow: 0 0 30px 5px rgba(0,0,0,0.3);  
}  

.contentUI__close-content {  
  position: fixed;  
  right: 10px;  
  top:100px;  
  z-index: 9999;   

}  

.contentUI  h1, .contentUI  h2 {  
  font-weight: normal;  
}  

.contentUI__button {  
  display: inline-block;  
  box-sizing: border-box;  
  background-color: #4fc08d;  
  border: 1px solid #4fc08d;  
  margin: 15px 20px;  
  padding: 15px 20px;s  
  font-size: 16px;  
  color: #fff;  
  width: 150px;  
  text-align: center;  
  vertical-align: middle;  
  color: #fff;  
  border-radius: 6px;  
  text-decoration: none;  
}  

.contentUI__button:hover {  
  text-decoration: none;  
  background: #00bd68;  
}  

.contentUI__button:active,.contentUI__button:visited {  
  color: #fff;  
}  

</style>
```

在`style tag`上將`scoped`設定開啟，則產生的樣式檔如下：這麼以來便能避免樣式檔不小心影響到載入頁面。

![](https://quip.com/blob/ccaAAA3TaO5/pQmw9xXaVdgVZ-8nDhnPAQ?a=631kVfoaLPrg9WphFSrKKB29pPz6ZpiefimYHGTaWhka)

### 事件腳本

要注意內容腳本是無法存取tabs相關的API， 所以這裡只能依靠訊息的傳遞來實作此功能。  

```
chrome.runtime.onMessage.addListener(function(message, sender, sendResponse) {  
    console.log(message.name);  

    switch (message.name) {  
        case "開啟頁面按鈕":  
            chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
                console.log(tabs);  
                chrome.pageAction.show(tabs[0].id);  
            });  
            break;  
        case "關閉頁面按鈕":  
            chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
                console.log(tabs);  
                chrome.pageAction.hide(tabs[0].id);  
            });  
            break;  
        default:  
            break;  
    }  

    sendResponse("來自事件腳本的回覆：處理已送出");  

});
```

### 功能展示(一)：使用內容ui切換頁面按鈕(注意右上角頁面按鈕icon的啟用及關閉狀態)
![](http://i.imgur.com/2jkZCmp.gif)

### 彈出視窗的腳本

```
document.addEventListener('DOMContentLoaded', function(dcle) {  
    var dButtonContent = document.getElementById("button");  

    //點擊按鈕，向內容腳本發送訊息  
    dButtonContent.addEventListener('click', function(e) {  
        console.log('click');  
        chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {  
            chrome.tabs.sendMessage(tabs[0].id, { content: "你好，此訊息來自彈出視窗腳本" }, function(response) {  
               console.log(response);  
            });  
        });  
    });  

});
```

### 功能展示(二)：內容ui切換長相
![](http://i.imgur.com/8sDJCgD.gif)

> 完整範例在[github](https://github.com/lauraluo/ExtensionSample/tree/master/vueWithContentUI/my-extension)

### 本篇沒有小結只有花絮

鐵人賽到一半了，為了增加自己的歸納能力才開啟了這個挑戰，過程中真的學到很多。

寫這個範例真是寫的累死我了，畢竟沒有Livereload可以看，每次產生程式碼就得重新載入擴充功能，所以找時間要把開發環境準備好。

比較好的方式應該是把內容腳本的操作邏輯與跟擴充功能溝通的部份隔離開來，把訊息相關的操作，當作像是用Ajax去取資料的方式去對待，將這類操作集中寫在一個地方，也可以寫個配適器去輔佐，這樣才能脫離Chrome擴充功能的環境開發，也比較利於測試。(可以考慮搭配vuex或是redux)

話說回來我真的好喜歡Vue寫起來的感覺，真希望工作能用vue寫(摀臉)。

## 參考資料
*   [https://vuejs.org/](https://vuejs.org/)  
*   [http://www.zoucz.com/blog/2016/08/31/vue-chrome-extensions/](http://www.zoucz.com/blog/2016/08/31/vue-chrome-extensions/)  
*   [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  
*   [https://crxdoc-zh.appspot.com/extensions/messaging](https://crxdoc-zh.appspot.com/extensions/messaging)  
*   [https://crxdoc-zh.appspot.com/extensions/runtimme](https://crxdoc-zh.appspot.com/extensions/runtimme)  


  

