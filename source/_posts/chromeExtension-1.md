title: Chrome Extension 開發與實作 01
date: 2016-12-15 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017

---

# 開始之前

2016的結尾，我決定挑戰自已，參加2017年度的IT邦幫忙鐵人賽，同時希望籍由技術文章的撰寫來提升自已的時間規劃以及口語表達的能力。

## 目標

*   首先假定你已經熟悉Web開發所需的基礎知識。  
*   接下來我們會了解Chrome Extension是什麼，熟悉他的組成零件及架構。  
*   進一步，我們會比較詳細的探討Chrome提供給Extension開發者的功能以及限制(API)。  
*   最後我們會開發，並且正式發佈一個Chrome Extension。  

<!--more-->

## 學習資源

官方教程：[https://developer.chrome.com/extensions](https://developer.chrome.com/extensions) (建議閱讀順序)  


* 快速連結-入門 [https://developer.chrome.com/extensions/getstarted](https://developer.chrome.com/extensions/getstarted)  
* 快速連結-概述 [https://developer.chrome.com/extensions/overview](https://developer.chrome.com/extensions/overview)   
* 快速連結-開發手冊[https://developer.chrome.com/extensions/devguide](https://developer.chrome.com/extensions/devguide)
* 快速連結-API文件： ：[https://developer.chrome.com/extensions/api_index](https://developer.chrome.com/extensions/api_index)   

簡體版文件(非官方)：[https://crxdoc-zh.appspot.com/extensions/](https://crxdoc-zh.appspot.com/extensions/) (建議閱讀順序)  

* 快速連結-入門  [https://crxdoc-zh.appspot.com/extensions/getstarted](https://crxdoc-zh.appspot.com/extensions/getstarted)  
* 快速連結-概述 [https://crxdoc-zh.appspot.com/extensions/overview](https://crxdoc-zh.appspot.com/extensions/overview)  
* 快速連結-開發手冊 [https://crxdoc-zh.appspot.com/extensions/devguide](https://crxdoc-zh.appspot.com/extensions/devguide)  
* 快速連結-API文件 [https://crxdoc-zh.appspot.com/extensions/api_index](https://crxdoc-zh.appspot.com/extensions/api_index)  

電子書 [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  

> **Creating  Google Chrome Extensions**
> Learn how to create great extensions for Google’s popular Chrome browser
> by Prateek Mehta

![](https://quip.com/blob/bGHAAArCyod/iKRybwHrTViHemyHwj1PQg?a=Q6akjqWYS9tuI3dTUouYxHejKedKyLYBsgVDb6ddu48a)

文章中會許多引用官網跟上面這本書籍的內容，我會儘量載明出處。  
電子書中的source code：[https://github.com/apress/creating-google-chrome-extensions](https://github.com/apress/creating-google-chrome-extensions)  

如果研究過程中發現什麼其他值得參考的資源，也會回到這裡補上。

## Chrome Eextension 至今發展現況

*   2010年釋出：  
    *   是個Framework，他讓Web開發者使用已知的技術，在Browser上增加功能。  

    *   許多使用WebKit引擎的Browser在都使用這個Framework( 例如： Safari, Mozilla Firefox)。  
*   2010年2月，超過兩千個extensions在Web Store上架  

*   2014年9月，已超過三萬個extensions  

*   2016年3月，許多Chrome的User，重度的依賴這些extension來完成他們的工作，下列是受歡迎的extension安裝清單：  
    *   Adblock Plus—10,000,000+ users  

    *   AddThis: Share & Bookmark—600,000+ users  

    *   Awesome Screenshot: Capture & Annotate—900,000+ users  

    *   Evernote Web Clipper—4,500,000+ users  

    *   Google Dictionary—3,000,000+ users  

    *   Google Translate—6,000,000+ users  

    *   Hangouts—6,500,000+ users  

    *   LastPass: Free Password Manager—4,000,000+ users  

    *   Photo Zoom for Facebook—1,500,000+ users  

    *   Pin It Button—10,000,000+ users  

## 釐清一些事情

*   Chrome Extension不是 Chrome Plug-ins  

    *   Chrome Extension 可以被想成是一個讓使用者下載到電腦裡執行的軟體。只是他使用的是Web的技術，以及可以取存及控制一些Browser的功能。  

    *   Plug-ins：是為了讓Browser可以支援不同的媒體類型，例如Flash。   

*   Chrome Extension 不是 Chrome APPs  

    *   Chrome APPs是界於Chrome Extension與 Chrome Plug-ins之間的產物。  

    *   **Chrome APPs 2016年8月宣佈即將棄用。詳情可以參考這篇文章：**[https://blog.chromium.org/2016/08/from-chrome-apps-to-web.html](https://blog.chromium.org/2016/08/from-chrome-apps-to-web.html)    

## 參考資料 

*   [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)
*   [https://developer.chrome.com/extensions](https://developer.chrome.com/extensions)  