title: "Web Animation (一) 基礎"
date: 2015-04-30 14:59:50
tags:
---


# 前言

對於Web Anmiation我還不敢說自己很熟悉，最近因為工作需要加上自己的興趣，開始對這塊領域產生興趣
在介紹動畫前先了解一下開發環境跟相關技術


# 一些瀏覽器的基本知識


在開始探討Web Animation前，讓我們先了解一下當今瀏覽器裡運行動畫有哪些技術選項，順便補充一下瀏覽器的基本知識

瀏覽器在繪制畫面時，會使所謂的layout engine/rendering engine，在運行JS的時後，也有相對應的Javascript Engine
而正因為瀏覽器使用不同的Engine來渲染畫面跟運行JS，所以我們在撰寫JS跟CSS才會有語法上的不同。

例如CSS在寫一些新語法時，並需對應RenderEngine來使用不同的prefix，如下
另外因為engine都會有新舊版本的不同，那麼就直接跟間接的影響他們對新語法的支援度


``` css

.my-class, #my-id {
    -moz-border-radius: 1em;
    -webkit-border-radius: 1em;
    border-radius: 1em;

    -moz-transition: all 1s ease;
    -o-transition: all 1s ease;
    -webkit-transition: all 1s ease;
    transition: all 1s ease;

    -moz-box-shadow: #123456 0 0 10px;
    -webkit-box-shadow: #123456 0 0 10px;
    box-shadow: #123456 0 0 10px;
 }

```


下面是常見瀏覽器，所使用的Engine，其中Gecko' V8, Webkit比較常被人們討論，而 Webkit 的市佔率最大


- **Firefox：** [Geko](https://developer.mozilla.org/zh-CN/docs/Mozilla/Gecko) 
- **Chrome：** 
	- layout engine Webkit (open source)
	- JavaScript Google V8 (open source)
- **Safari：**
	- layout engine Webkit
	- closed-source JavaScript engine

- **Opera**：
	- layout engine 原本是自行開發的 Presto 2013年2月13日轉採用Webkit開發的Blink
	- Javascript engin  Carakan 
	- 如果早期用在用CSS3的人，可能還有用過`-o-`，後來Opera換了rendering後，基本也統一成-webkit-

- **IE：** 
	- layout engine Trident
	- Javascript engin IE9+ Chakra 


> 補充：
> - [Geko維基](http://zh.wikipedia.org/wiki/Gecko)
> - [WebKit維基](http://zh.wikipedia.org/wiki/WebKit)
> - [市面上的layout Engine 維基](http://zh.wikipedia.org/wiki/%E6%8E%92%E7%89%88%E5%BC%95%E6%93%8E)

# Web Animation 相關技術

- HTML5
	- CANVAS
	- SVG
- CSS3
- Javascript 

# Web Animation 相關函式庫

Jqeury大家都很熟悉，這裡就不用提，列舉一些我在研究動畫的時後用過或聽過的函式庫
在接下來的研究裡，期待自己能分享給大家


## WebGL

- JS的函式庫，基本上作用在CANVAS之上
- WebGL基於OpenGL ES 2.0 的標準
- MDN有部份中文化的WebGL文件，有興趣的朋友可以到[這裡]一探究極(https://developer.mozilla.org/zh-TW/demos/tag/tech:webgl) 

## Greensock

- [官方網站](https://greensock.com/)  
- JS的函式庫，基本上作用在任何可以用數值之上，不一定是CSS，強調非常方便的影格控制
- 中文的導讀文件 http://bbs.9ria.com/thread-421653-1-1.html


## CreatJs

- [官方網站](http://www.createjs.com/Home)  
- JS的函式庫，基本上作用在CANVAS之上
- Flash cc 可直接引用其JS程式碼片段，因為這一點引起我的注意，也許值得深入研究
-  有興趣的朋友也可以看一下[Adobe的官方文件](https://helpx.adobe.com/tw/flash/using/creating-publishing-html5-canvas-document.html#CreateJS)，大概了解一下他的運作方式 
- 另外 除了CreatJS外，他還有四個兄弟產品 
	- EASELJS
	- TWWEENKS
	- SOUNDJS
	- PRELOADJS 

## Pixi.js

- [官方網站](http://www.pixijs.com/)
- WebGL的函式庫，而且會在其不支援的時後向下相容canvas
- [Phaser](http://phaser.io/)一個非常流行的html5 GAME開發引擎，他的畫面渲染是使用Pixi.js 

# 關於Animation的基本用語

- 變形 transform
	包含常見的 變大變小、垂直水平的鏡射、傾斜、旋轉
- 補間  tweeen/transition
	補間的基本特性包含：補間的運行時間、補間的數值(必需可以作為數字去處理)，補間的延遲時間
- 關鍵影格/影格  key-frame/frame
	關鍵影格是一種動畫常用的動畫技術，基本原理是指定特定影格的數值，而其他的影格會基本這些關鍵影格，自動作數值上的加減
- Easing函數
	動畫效果在執行時的速度，使其看起來更加真實, 真實世界中，其實不存在於可以把加速度瞬間從0到100的物體
- 時間軸 Timeline
	大家最熟悉的時間軸介面大概就是下面這張圖，Flash的時間軸控制概念，在很多Web動畫技術都會出現，其中的元素包含定義每個影格的時間，總體播放時間，等等
	![](/images/ws_timeline_popup.png)





