title: Chrome Extension 開發與實作 30
date: 2017-1-13 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 正式發佈擴充功能

正式發佈流程

<!--more-->


## 一  使用Google帳號 [登入Chrome 線上應用程式商店](https://chrome.google.com/webstore/developer/dashboard)後台

![](https://quip.com/blob/FXQAAAUrVsJ/_xBelV8XWaxcCRbZdzGpeA?a=UQ6jKCo8txH25CO0JWVpNNAzR61aBw93Efgi4vVzxQoa)

##  二 首先我們先進行帳號的驗証動作

這裡比較奇怪的是，我必需點擊新增商品再回到首頁，或是點擊立即付款，再回到首頁才能看到我的開發帳號填寫介面，不然就像上一張圖一樣空白。  

![](https://quip.com/blob/FXQAAAUrVsJ/OgHtd_NvQJgKoYGeLXdNjA?a=jrLO92gFvfL0AK1p7HxnixQeKNhaD597ncRJrvG4acoa)

這裡的資料都不是必填的，一旦填寫，就要作好心理準備這些資料會在前台出現：例如地址、email、不想的填的人可以不用填。  

## 三 接著先付款進行帳號的驗証(你也可以選擇發佈前在付款)，驗証金額是五美元。

這個付款是一次性的，但一個帳號上傳項目是有限的，你也可以使用你的google皮夾付款。  

![](https://quip.com/blob/FXQAAAUrVsJ/8ty_k9ggupNZks97fCkpCg?a=O2QjctFajEmVaaaexajGJdDbJ12VtBUwbBFje7lk7jwa)

![](https://quip.com/blob/FXQAAAUrVsJ/b1zc0JVx1_mXPLvWaokKpw?a=brOVbCBF63PapICbpKiVlAPAwpqpbGlWr2vTwv9rK5Aa)

以上圖片來源是[電子書](http://www.apress.com/us/book/9781484217740)  

## 四 上傳你的擴充功能(請打包成zip檔)

![](https://quip.com/blob/FXQAAAUrVsJ/X0yd3yKDAwmdsNIS15wfRw?a=f6CC1oz2AjVBEnu1D8NaM48dYNHWyFHYTIatUhwtPXEa)

上傳記得在擴充功能中，補齊相關的圖示，下以為例：  

```
{  
    "manifest_version": 2,  
    "name": "ShowTime",  
    "description": "Extension to show the current time and date",  
    "version": "1.2",  
    "browser_action": {  
        "default_title": "ShowTime",  
        "default_icon": "icon.png", //瀏覽器按鈕的icon  
        "default_popup": "popup.html"  
    },  
    "icons": {  
        "16": "icon16.png", //用來作為extension頁面的favicon  
        "48" : "icon48.png", //利用來講管理者頁面  
        "128": "icon128.png" //用來在安裝期間，以及和Chrome網上應用商店使用  
    }  
}
```

上傳壓縮檔時，如果設定檔的格式有誤，或是指定的資源路徑找不到都會在這時提出錯誤警告  

![](https://quip.com/blob/FXQAAAUrVsJ/teYMrUhHVpranCq8QRhi7A?a=HqxFsar7vjZ0o6MXfL7vwsR1XGZtHefL7oPT4LZA72Ya)

## 五 上傳成功後進入擴充功能的編輯頁面

![](https://quip.com/blob/FXQAAAUrVsJ/1aY_Nc6eyJJoblu-rGTjyg?a=OfSYaAo1NRrvAwSOjC9yqy4YtckiJ5a6aC1Sa7DDXIMa)

## 六 填寫擴充功能的前台基本資料

除了說明文字之外，還需上傳一些前台展示圖片  
![http://ithelp.ithome.com.tw/upload/images/20170113/20079450eLZFcbVlkg.png](http://ithelp.ithome.com.tw/upload/images/20170113/20079450eLZFcbVlkg.png)

可以點擊**宣傳方塊預覽**查看圖片展示區塊的預覽  

![](https://quip.com/blob/FXQAAAUrVsJ/KijzQV6NBQIjivzC8VCIWA?a=6XunjO7enalwHTNaFuJeIlnyGLEgLkbIDT2shW63Xm0a)

你可以為你的擴充功能選擇付費或免費的資訊、發佈的地區、類型、等等相關的發佈操作，最後你可以選擇下列三種式發佈你的應用程式 

![](https://quip.com/blob/FXQAAAUrVsJ/8Azdck2p3Ji__7WxYDHJhw?a=3eDiI8PV5yuICV2R1Rh8F5lOJxmLF51qCC0Kti1LcbAa)

按下發佈前，如果你還沒付款的話後台會要求你完成帳號驗証的付款動作，但在付費前你可以先預覽你的發佈結果：

(注意預覽畫面的安裝按鈕是不能按的)

![](https://quip.com/blob/FXQAAAUrVsJ/_Vx-OBA_EvaimceXGo4VEg?a=cGtSTBbgqX7JHdFhmciDKAZRabaZwGLeaFM1LIFUwcMa)



## 七 發佈結果

由於我選擇不公開發佈我的擴充功能，所以只有下列網址才能看到我的擴充功能頁面，商店不會搜尋到：  
[擴充功能發佈頁連結](https://chrome.google.com/webstore/detail/%E5%BD%B1%E7%89%87%E6%88%AA%E5%9C%96%E7%AF%84%E4%BE%8B/dhaadjpgjpdbbplnfdhclnlcmpgglnbl)  

因為官方流程的關係，很容易誤導開發人員預覽頁的網址就是發佈網址，但事實上正確的網址是回到[後台首頁](https://chrome.google.com/webstore/developer/dashboard)，在項目清單頁上點擊擴充功能的名字。  

![](https://quip.com/blob/FXQAAAUrVsJ/zWKdA4UHYmCO5QwV0vpK5w?a=7b0t4klMzDQG3G3550WVPnVZaq0APulpRNhLyKRJaCca)

另外點擊右測的更多資訊，你能取得擴充功能的ID以及金鑰。  

![](https://quip.com/blob/FXQAAAUrVsJ/G5dWs6qgi2EZH5zJiEVVBg?a=3tUtzKa12jqhQ47ygQAEyiEM6L0DecPTu7rI2gDD1lga)

## 參考

* [以上示例中的ICON作者](http://www.flaticon.com/authors/madebyoliver)  
* [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  



## 鐵人賽完賽感想

僅以此三十篇文章作為我入行三年多來的一個紀念。  

三年半前我是一個從設計踏入前端領域的小菜菜，在程式的路上有許多給予我信念指導以及技術指導的前輩、同輩、後輩們。感謝你們讓我專注於解決問題，而不是工具本身，鼓勵我從根本去了解問題而不被表現所迷惑，也讓我時常發各種以為不可能的可能，突破很多本來以為的限制，有你們才有今天的我。  

最後特別感謝鼓勵我參賽及給我研究方向的良師以及益友們。














