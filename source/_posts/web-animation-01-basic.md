title: "Web Animation (一) 基本既念"
date: 2015-04-30 14:59:50
tags: 
- css3
- canvas
- webGl
- animation

categories:
- web animation  

photos:
- images/animation.jpg

---


# 前言

對於Web Anmiation我還不敢說自己很熟悉，最近因為工作需要加上自己的興趣，開始對這塊領域產生興趣
在介紹動畫前先了解一下開發環境跟相關技術

<!-- more --> 


# 一些瀏覽器的基本知識

瀏覽器在繪制畫面時，會使用所謂的layout engine/rendering engine，在運行JS的時後，也有相對應的Javascript Engine
而正因為瀏覽器使用不同的Engine來渲染畫面跟運行JS，所以我們在撰寫JS跟CSS才會有語法上的不同。

例如CSS在寫一些新語法時，並需對應RenderEngine來使用不同的prefix，如下
另外因為engine都會有新舊版本的不同，那麼就直接跟間接的影響他們對新語法的支援度


``` css

.my-class, #my-id {
    -moz-border-radius: 1em;
    -webkit-border-radius: 1em;
    border-radius: 1em;

    -moz-transition: all 1s ease;
    -webkit-transition: all 1s ease;
    transition: all 1s ease;

    -moz-box-shadow: #123456 0 0 10px;
    -webkit-box-shadow: #123456 0 0 10px;
    box-shadow: #123456 0 0 10px;
 }

```


下面是常見瀏覽器，其中Gecko' V8, Webkit比較常被人們討論(開源力量大XD)


- **Firefox：**  
	- layout engine [Geko](https://developer.mozilla.org/zh-CN/docs/Mozilla/Gecko) 
	- javascript engine OdinMonkey
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
> 因為每個瀏覽器還有各自的版本問題，實在太過複雜，上面可能也不會是最新的資訊，有興趣的朋友可以自己上維基查看看，有錯的也可以留言請我糾正，因為我真的被搞的有點暈XD
> - [layout Engine 維基](http://zh.wikipedia.org/wiki/%E6%8E%92%E7%89%88%E5%BC%95%E6%93%8E)
> - [javascript Engine 維基 ](http://zh.wikipedia.org/wiki/JavaScript%E5%BC%95%E6%93%8E)


# Web中動畫跟繪圖相關技術

- HTML5/HTML
	- [CANVAS](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API)
	- [SVG](https://developer.mozilla.org/zh-TW/docs/Web/SVG)
- [CSS3](https://developer.mozilla.org/en-US/docs/Web/CSS)
- Javascript 

常常有人會把HTML5跟CSS3畫上等號，以為是同一個東西或是一定要一起使用
這兩個東西並沒有直接關係，CSS3不一定要搭配HTML5也可以運作的很好

Javascript經常擔任控制器的角色，新的瀏覽器提供api給js作操作CANVAS作繪圖or動畫
另外新的瀏覽器也提供了一些新的事件，用來監聽CSS3動畫的渲染事件，幫助你加強控制CSS3的特效


# Web Animation 相關函式庫

列舉一些我在研究動畫的時後用過或聽過的函式庫
在接下來的研究裡，期待自己能分享給大家

PS Jquery大家很熟悉，這裡就不多提


## WebGL

![WebGL](/images/WebGL_logo.png)

- JS的函式庫，基本上作用在CANVAS之上
- WebGL基於OpenGL ES 2.0 的標準
- MDN有WebGL文件，有興趣的朋友可以到[這裡](https://developer.mozilla.org/zh-TW/demos/tag/tech:webgl) 一探究極


## Greensock

![Greensock](/images/2015-05-08_151216.jpg)

- [官方網站](https://greensock.com/)  
- JS的函式庫，基本上作用在任何可以用數值之上，不一定是CSS，強調非常方便的影格控制
- 中文的導讀文件 http://bbs.9ria.com/thread-421653-1-1.html


## CreatJs

![CreatJs](/images/2015-05-08_151346.jpg)

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

![Pixi](/images/2015-05-08_151424.jpg)

- [官方網站](http://www.pixijs.com/)
- WebGL的函式庫，而且會在其不支援的時後向下相容canvas (沒錯XD canvas竟然淪到是一個降級方案了，大家就知道webGL有多新)
- [Phaser](http://phaser.io/)一個非常流行的html5 GAME開發引擎，他的畫面渲染是使用Pixi.js


## paper.js

![paper](/images/2015-05-08_151453.jpg)

- [官方網站](http://paperjs.org/about/)
- 公開資源，特色是作向量繪圖的framework，運行在html5上，跟其他的工具比起來，感覺更focus在貝茲曲線還有向量圖的交集跟差集的運算，有別大部份的網頁繪圖，他能繪制出一些活潑動感的曲線，讓人耳目一新。

# 關於Animation的基本用語

這裡介紹一些基本用語，在研究web animation時，有些概念會一直重複被提到，但他可能各自有不同的稱呼

## 變形 transform
- 包含常見的 變大變小、鏡射、平移、傾斜、旋轉
- 同樣概念的有css3中的[transform](https://developer.mozilla.org/en-US/docs/Web/CSS/transform)


## 補間  tweeen/transition
- 補間的基本特性包含：補間的運行時間、補間的延遲時間、補間的數值(*必需可以作為數字去處理*)
- 同樣概念的有
	- css3 [transition](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Using_CSS_transitions) 屬性
	- gsap [tween](http://greensock.com/tweenlite) 物件

## 關鍵影格/影格  key-frame/frame
- 關鍵影格是一種動畫常用的動畫技術，基本原理是指定特定影格的數值，而其他的影格會基本這些關鍵影格，自動作數值上的加減
- 同樣概念的有
	- css3的 `@key-frame`
	- gsap中宣告每個tween時，裡面傳的數值

## [Easing函數](http://easings.net/zh-tw)
- 動畫效果在執行時的速度，使其看起來更加真實, 真實世界中，其實不存在於可以把加速度瞬間從0到100的物體
- 控制其運動效果的方式，是利用一種[cubic-bezier (三次方貝茲曲線)](http://cubic-bezier.com/#.17,.67,.83,.67)的方法來描繪運動效果
- 同樣概念的有
	- css3中的 transition的 [time-function](https://developer.mozilla.org/en-US/docs/Web/CSS/timing-function)
	- jquery ui(jquery 的外掛)的 [easing plugin](https://jqueryui.com/easing/)

## 時間軸 Timeline
- 大家最熟悉的時間軸介面大概就是下面這張圖，Flash的時間軸控制概念，在很多Web動畫技術都會出現，其中的元素包含定義每個影格的時間，總體播放時間，播放次數、跟所謂的倒退重播(作出來回的效果)等等
	-![](/images/ws_timeline_popup.png)
- 同樣概念的有
	- css3 [animation](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Using_CSS_animations) 屬性
	- gsap [timeline](http://greensock.com/timelinelite) 物件




## 資料來源


- [封面圖片](http://driverlayer.com/img/animation%20cheval%20au%20galop/20/any)
- 其他資訊請參考上面的各連結