title: "20150415_RwdPojectStudy"
date: 2015-04-15 17:00:07
tags:
---

## 前言


本篇非概念文章，分享一些我們在實際專案中遇到的障礙跟心得 

以此文章適合閱讀的對象
- 用過Bootstrap3
- 用過Less/Scss這類的樣式編譯器 
- 用過 Grids System 
- 擁有RWD所有所需相關知識 
- 被專案逼瘋(？)的人

---

## 趨勢

施作RWD技術前，我們作了一些現況的調查，幫助了解現在開發要面臨的環境

### 瀏覽器的市佔率

了解瀏覽器的市佔率，可以幫助我們作技術上的選擇。特別標註IE8，是因為對前端來說，存在RWD的技術斷層，文章結尾會探討到IE8的支援度。

{% asset_path slug %}

#### 全球 2014 sept~ feb 2015
![Alt text](/images/2015-04-01_092216.png)
#### 台灣 2014 sept~ feb 2015
![Alt text](/images/2015-04-01_092729.png)
#### UU 100萬人次 瀏覽器
![Alt text](/images/2015-04-01_105304.png)
#### UU 100萬人次 作業系統
![Alt text](/images/4b3f6649-a883-4f81-b851-4a0275270cc4.png)

### 2014 台灣使用PC與APP瀏覽臉書的比例很接近

如果你像我們一樣，經營內容型網站，或是內容擴散的Event型活動，那就要了解有很多使用者是在FB APP中點開你的連結 。(也或許是Line或其他APP)

![Alt text](/images/2015-03-31_185159.png)

###  行動裝置大螢幕的普及化

#### 行動裝置不等於小螢幕

其中 [Mobile Website Development and Design Course](https://www.udacity.com/course/cs256?_ga=1.111987012.1546922041.1425352835)中Google的資深工程師有探討到幾個行動vs桌面網站的迷思：
- 以產品而言，所有的功能到了手機也應當支援(打破了有些功能手機不需要的迷失)，例如EC網站，到了APP還是需要查帳單 
- 有兩個網站，維持同步跟一致性是困難的
- 未來已經愈來愈難區分什麼是桌面，什麼是行動網站，因為行動裝置愈來愈大解析度也愈來愈高：當我們在使用設計RWD網站時，你應該思考的是裝置的螢幕大小，而不是思考他是平板還是手機。
- 另外關於Native APP 除了較高的成本外， 你要思考你的使用者是否會想離開他的瀏覽器或APP

#### 2014 Android螢幕市佔率 
![Alt text](/images/0.jpg)
#### 2014 IOS螢幕的市佔率
![Alt text](/images/2.jpg)

---

## RWD 與 獨立行動版網站的探討

了解市場趨勢後，讓我們來分別探討不同的解決方案

### RWD

優點
-  維護相對容易
-  彈性較大，MediaQuery的劃分可以依照不同的功能或產品特性規畫

ISSUE
-  手機與桌面版網站的流程基本上需要一致；
	過於複雜的流程受限於這點，可能無法提供給行動裝置的使用者良好的體驗。
	(但其實需要APP方能做到更為友善的體驗。)
-  降低了載入的速度
-  多餘的HTML
-  多餘的HTTP requests
-  多餘的圖片解析度 
-  內外部的教育成本
	
###  獨立行動版網站

優點
- 針對手機前端的專屬優化
- 針對手機使用者優化體驗

ISSUE
-  SEO網址分散的問題
-  考慮到平板與手機因裝置大小差異，要提供不同的介面，仍須使用RWD
-  針對產品不同，需思考是否更適合開發Native App
-  護維及一致性的成本

###  該如何選擇？

- 以流程的差異性來探討
	-  RWD： 桌面與行動版的網頁流程基本一致，只是介面跟互動上的不同
	-  獨立行動網站：桌面與行動版流程差異太大，甚至根本不同
-  以流程的複雜度而言
	-  RWD：適合簡單的流程
	-  獨立行動網站：沒差
- 以瀏覽器的支援度探討
	-  RWD： 依賴很多新語法，基本只支援 IE9+
	-  獨立行動網站： 若顧客真的很在意舊版(銀行業)，行動跟桌面可考慮分開作，甚至是單獨作IE8以下的網頁
-  以活動行銷方式去探討 
	-  RWD  ：適合網路及實體都有搭配的行銷活動
	-   獨立行動網站： 極度依靠手機功能制造話題的活動，例如動態感應裝置 ETC，地理資訊，等手機獨有的功能
- 以專案總時程考量
	-  RWD：雖然RWD的施作技術成本及教育成本較高，但這些是會累積成公司的資產，再來是RWD對後續的修改較容易。
	-  獨立行網站： 通常要投入多個的前端資源，但同時他可以作更靈活的資源調配動作(手機平版桌面甚至可以分開不同人作)。

----

## 實作

接著探討一些我在實作中遇到的問題

---	
###  Viewport 設定

####  基本設定 
``` html
  <meta name="viewport" content="width=device-width, initial-scale=1">
```

#### 使用JS控制Viewsport

我們可能想針對不同的螢幕尺寸給予不同的viewport。下面程式碼示範，當螢幕大於640時，我們希望直接使用PC版的瀏覽器。

``` JS
    var meta = document.createElement('meta');
	var w = screen.width;
    if (w > 640) {
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=960");
    }
    else {
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width initial-scale=1");
    }

    var s = document.getElementsByTagName('head')[0].children; s[s.length - 1].parentNode.insertBefore(meta, s[s.length - 1]);

```

#### 使用css來控制Viewport
- 查詢了MDN，原來在CSS中可以定議Viewport，但支援度太低，我們這裡就不考慮，大家可以自已看下面連結
- [MDN @viewport ](https://developer.mozilla.org/en-US/docs/Web/CSS/@viewport)

#### 注意事項
- ```initial-scale```要下，不然在某些狀況下，手機作橫版直版的轉換時，畫面會跑掉
- viewport如果有修改，要另開新視窗，重新整理是沒有用滴
- 使用JS控制Vieport，我們依然會擔心JS執行速度的問題，這種作法的穩定度可能需要花時間找到更好的方案
- 要注意 window.innerWidth在有設定`device-width`為特定寬度或是`initial-scale`不等於一的狀態下，他不會等於screen.width(物理寬度)所以施作的時後最好搞清楚你要的東西到底是什麼。

下面兩張圖分表展示了上段JS運作之後的狀態
iphone的解析度

![Alt text](/images/11092618_957963364221938_943245149_n.jpg)

ipad 因為我們強制指定width=960，所以我們會看到`screen.width`取到了物理的相素大小，而`window.innerWidth`取到的是CSS/虛擬的的相素大小

![Alt text](/images/11133794_957964304221844_4305008428719112073_n.jpg)

### mediaQuery

#### 如何決定key breakpoints 

我們可以參考最多人在使用的前端框架，bootstrap3的作法，bootstrap3將裝備定議成四種大小，斜線右邊是這個大小下，其對應到的隱含設備(寬度跟其設備沒有絕對的關係)。
-  Extra small devices / Phone 480
-  Small devices Tablets / Tablets 768
-  Medium devices / Desktops 992
-  Large devices /Desktops 1200

![Alt text](/images/2015-04-01_145703.jpg)
[圖片來源]([http://mediaqueri.es/](http://mediaqueri.es/))


這裡學習bootstrap3的方法示範一段使用less來操作Break points的方法

``` less
//變數
// Media queries breakpoints
// --------------------------------------------------

// Extra small screen / phone
@screen-xs:                  480px;
@screen-phone:               @screen-xs;

// Small screen / tablet
@screen-sm:                  768px;
@screen-tablet:              @screen-sm;

// Medium screen / desktop
@screen-md:                  992px;
@screen-desktop:             @screen-md;

// Large screen / wide desktop
@screen-lg:                  1200px;
@screen-lg-desktop:          @screen-lg;

// So media queries don't overlap when required, provide a maximum
@screen-xs-max:              (@screen-sm - 1);
@screen-sm-max:              (@screen-md - 1);
@screen-md-max:              (@screen-lg - 1);

@screen-sm-min:              (@screen-xs +1);
@screen-md-min:              (@screen-sm +1);
@screen-lg-min:              (@screen-md +1);


//===============================
//layout的斷點，用來打造GridSystem
//===============================

/* Extra small devices (phones, less than 768px) */
/* No media query since this is the default in Bootstrap */

/* Small devices (tablets, 768px and up) */
@media (min-width: @screen-tablet) { ... }

/* Medium devices (desktops, 992px and up) */
@media (min-width:  @screen-desktop) { ... }

/* Large devices (large desktops, 1200px and up) */
@media (min-width: @screen-lg-desktop) { ... }

//===============================
//用於較精準的定義
//===============================
@media (max-width: @screen-xs) { ... }
@media (min-width: @screen-sm-min) and (max-width:@screen-sm-max) { ... }
@media (min-width: @screen-md-min) and (max-width:@screen-md-max) { ... }
@media (min-width: @screen-lg-min) { ... }
```

#### 注意事項
- IE9+ 才支援media querys (後面再探討兼容方法)
- 如果對文字排版斷行跟標點符號節尾有所要求的專案，可以使用em來作為mediaQuery的參考[這篇文章](http://blog.cloudfour.com/the-ems-have-it-proportional-media-queries-ftw/)
	- 換算公式 100% = 1 em ~= 16px ~= 14pt

#### 資源

一些常見的Media Querys 片段，其中還有針對一些常見的設備的特徵作詳細的定義方法，有別於`max-width`利用`max-device-width`取得物理尺寸作為更精準的設備參考(但感覺還是追不上市場速度)
- Media Queries for Standard Devices 
	https://css-tricks.com/snippets/css/media-queries-for-standard-devices/
- Media Query Snippets
	http://nmsdvid.com/snippets/

---

###  單位

PX、EM、%、PT 要搞清楚 [這裡有個速查表](http://pxtoem.com/)
![Alt text](/images/2015-04-01_172324.jpg)

---

### Font

#### Font-Size的單位
- 絕對單位 px : 容易控制內容，適合固定尺寸網站
- 相對單位 em、rem或是百分比 : 均是以瀏覽器預設字型樣式為基準進行比例配置。
    - 會參照使用者瀏覽器字型設定呈現
    - rem直接參考html產生value 和em的運算相似，但em為參考其父元素獲得數值
    
#### RWD  EM/REM 的管理方法
使用rem更方便控制，不必擔心em的複合計算行為(將EM跟PX的轉換化為十進制)。
rem參造root或html element，因此我們將html壓縮62.5%(default 16px)> 1rem = 10px ;

```css
    html { font-size: 62.5%; } 
    body { font-size: 14px; font-size: 1.4rem; } /* =14px */
    h1   { font-size: 24px; font-size: 2.4rem; } /* =24px */
```


####  RWD  FIT  Font
一般來說，我們會針對不同字型調整大小，是為了舒服的閱讀文字體驗，BUT!!
當專案的類型圖片吃重，圖文比例有要求，這時後需要借助一下Javascript

![Alt text](/images/2015-04-01_175240.jpg)

我們從設計那邊拿到的PSD大小是寬度604px的原始檔，我們可以將640px作為參考值，在不同的裝備大小下，去重新定義em的基準值。

``` javascript
(function ($) {
    $.fn.rwdFitText = function (opts) {
        // default configuration
        var config = $.extend({}, {
            opt1: null
        }, opts);
        // main function
        function restFontSize(e) {
            var rwdFont = function () {
                if ($(window).width() <= 640 && $(window).width() > 320) {
                    var ration = 0;
                    if ($(window).width() >= 320) {
                        ration = $(window).width() / 640;
                    } else {
                        ration = 0.5; //用來控制最小縮放比率的數值
                    }
                    var fontScale = (ration * 100) * 0.625;
                    $('html').css('font-size', fontScale + "%");
                } else if ($(window).width() > 640) {
                    $('html').css('font-size', "62.5" + "%")
                }
            };
            $(window).resize(function () {
                rwdFont();
            });
            rwdFont();
        }
        // initialize every element
        this.each(function () {

            restFontSize($(this));
        });
        return this;
    };
    // start
    $(function () {
        $("html").rwdFitText();

    });
})(jQuery);
```
[範例](http://codepen.io/ce0812/details/KwbQwG)

搜尋```rwd font```的關鍵字，網路上可以找到不少相關的程式碼，有些細到可以定義每個DOM物件的最大值跟最小值，看得出來大家都有這些困擾。


---

### Layout + Grids

#### 容器管理
要施作一個RWD，需要使用容器管理的概念，我在每個區塊中，在每個區塊中放入 `container`與`row`來管理我們的佈局

HTML結構
``` html
<body>
	<nav class="nav">
		<div class="container">				
			<div class="row">
			</div>	
		</div>
	</nav>
	<section class="main">
		<div class="container">				
			<div class="row">
				<ul class="clearfix">
					<li>item</li>
					<li>item</li>
					<li>item</li>
				</ul>
			</div>	
		</div>
	</section>
	<footer class="footer">
		<div class="container">				
			<div class="row">
			</div>	
		</div>
	</footer >
</body>
```

下列程式碼除了示範如何用container來約束網站內容在不同寬度裡的SIZE，另外我還利用了SCSS的Function快速產生一套Grids System 供查詢Grid寬度使用 

SCSS
``` scss
$break:640px;
$grid-width:  7.33333333333333%;//12grid
$gutter-width: 1%;

.clearfix{zoom:1;}
.clearfix:after{content:'.';display:block;clear:both;visibility:hidden;height:0;font-size:0;}

@function grid-width($n) {
	 @return $n * $grid-width + ($n - 1) * $gutter-width;
}

@media screen and (min-width: $break+1){
	.container {
		width:960px;
		margin:0 auto;
	}
}
@media screen and (min-width: 0) and (max-width: $break){
	.container {
		width:100%;
		margin:0 auto;
	}
}

//將 UL 中的所有 LI 設定為流體佈局中的三格寬

ul li{
	width:grid-width(3);
	float:left; 
	box-size:border;
	border:1px solid #000;
}
```

#### Sticky Footer 

有兩個版本，各有優缺點
- http://compass-style.org/reference/compass/layout/sticky_footer/
- http://www.cssstickyfooter.com/

---

### Javascript
- 手機沒有Scroll Event
- 在PC上連續觸發的Event，到手機上觸發頻率都會降低
- FB的Javascript SDK 部份功能不支援手機 (惡夢)
- window.open行為不一致
- 待補充

---

### 各種百分比參照對象


- **background-size：**父層容器高寬
-  **width / height：**父層容器高寬
- **background-position：**背景大小減掉父層容層後的差集

    ``` html
    <div class="box">
    	<div class="item"></div>
    </div>
    ```

    ``` scss
    .box {
    	width:1000px;
    	height:100px;
    }
    
    .item {
    	background:url(w1000Xh100.jpg) no-repeat 10% 0;
    	background-size:90% auto;
    	// (1000(box) - 1000(item)) * 10% = 10 px
    }
    
    ```

-  **padding 跟 margin:**比較特別的地方是，padding-top、padding-bottom、margin-top、margin-bottom 是參考父層**寬度**

----


## A RWD CSS Sprite Button

使用Backgroun-size作使用圖片卻能伸縮的Sprite Button
實作方法是另用Padding-Bottom是參考其父層寬度的特性 

![Alt text](/images/螢幕快照 2015-04-01 下午11.12.59.png)
![Alt text](/images/螢幕快照 2015-04-01 下午11.12.42.png)

[範例](http://codepen.io/ce0812/details/ByvxRQ)

---

### Facebook

簡述FB會遇到的狀況，之後我們會在擬一份PC VS 手機的FB功能替代方案給大家參考

- fb.ui() 及 javascript SDK 在 IOS X Chorme 沒辦法正常運行，要依靠轉址，參數的傳遞要花工
- 轉址時，winodow.open在一些特別的Broswer(例如line)認知不同，儘量不要使用


---

### IE8兼容

#### HTML5+CSS3

-  Modernizr：可以用來偵測各種CSS3或是HTML5功能的兼容性作為JS 或 CSS的條件參考可以使用這個，預設包含Html5Shiv的功能，所以不要一起使用。
-  Html5shiv：一段讓 IE6 IE7 IE8 支援 HTML5 標籤的 JavaScrip

#### mediaQuerys

我們使用的是Respond.js

實現原理 

> - 把head中所有`<link rel=“sheetstyle” href=“xx”/>`的css路径取出来放入数组
> - 然后遍历数组一个个发ajax请求
> - ajax回调后仅分析response中的media query的min-width和max-width语法，分析出viewport变化区间对应相应的css块
> - 页面初始化时和window.resize时，根据当前viewport使用相应的css块。


#### REM

- 使用JS的解決方式 (還沒試過)
	- https://github.com/chuckcarpenter/REM-unit-polyfill
	- https://github.com/heygrady/Units


- 用SCSS解決rem在IE8解決的方式
	利用mixin傳回px和rem，在現代瀏覽器會以rem覆寫px，舊瀏覽器則是採用傳統的PX，(這個方法不適用我前面討探的RWD FIT FONT)

```css
 @function calculateRem($size) 
   $remSize $size / px
   @return $remSize * 1rem

 @mixin font-size($size) 
   font-size $size
   font-size ulateRem($size)

 //Usage
 div {
   @include font-size(px)
 }
 //Output
 div {
   font-size px //Will be overridden if browser supports rem
   font-size rem 
 }
``` 

#### Background-size

- https://github.com/louisremi/background-size-polyfill
	作用原理為截入`.htc`檔並使用`-ms-behavior: url(/backgroundsize.min.htc);`需要使用Background-size的群組屬性裡。他會使用背景圖片將IMG強制插入你的元素裡
	
	- 使用background-size作的css sprites按鈕，無法有hover效果
	- 在css中使用的路徑需相對於html
	- 還是有bug，某些狀況下無法正常初始化


####  其他Polyfills疑難雜証

- HTML5 Cross Browser Polyfills
https://github.com/Modernizr/Modernizr/wiki/HTML5-Cross-Browser-Polyfills

- 兼容速查
	-  Can I Use http://caniuse.com/ (點最下方的資源TAB有時後會提供兼容方案Ｓ)
    -  MDN https://developer.mozilla.org/zh-TW/
    
---

## Debug

RWD的自動化測試是還要再研究，讓我們先了解一下DEBUG的方式

### remote Debug 遠端Debug模式

很多問題，可能要實際在手機的Broswer上才能Debug ，要注意的是IOS的Safari只能搭配OSX來Debug是個吃蘋果的好理由

-  A Concise Guide to Remote Debugging on iOS, Android, and Windows Phone
	http://developer.telerik.com/featured/a-concise-guide-to-remote-debugging-on-ios-android-and-windows-phone/
-  windows7+ android usb driver 裝不上的處理狀況(本人試過有效)
	http://izaka.tw/2014-10-04-207/

### 畫面的Debug工具
 Chorme的WebDeveloper最好用 = =
 ![Alt text](/images/螢幕快照 2015-04-01 下午11.34.35.png)

 試過幾款Web工具發現在Viewport的模擬上跟真實都會有出入，而且在Windows中還可以摸擬TouchEvent跟3G環境也就沒有再找其他的

---

### 實作方向

#### 固定寬度

- 原理：如果你有三個BreakPoint分別代表手機/平板/PC，這個作法會直接切固定的三個寬度的CSS，定位都可以用PX，然後使用JS改變Viewport
- 難度：簡單
- 優點：施作容易
- ISSUE：
	- 較適合圖案吃重，圖文大小比例要求的專案
	- 彈性較不足
	- BreakPoint切的不夠的狀況下，UI的元素會變的異常大OR異常小(例如一顆屏幕寬度為640的一個44PX的按鈕，在320的手機中只剩22px，以此類推)


### 以百分比佈局

- 原理：使用百分比，所有東西都參照螢幕寬度作相對變化
- 難度：複雜
- 優點：彈性較高
- ISSUE：
	-  較適合內容文字比例多的專案，甚至可針對不同裝置大小設置舒適的閱讀文字
	-  施作較複雜

以上這兩種作法我們都有使用過，並沒有覺得哪個比較好，只能說看狀況
	

---
## 更多的議題

開放討論優先順序

-  測試
-  最佳化
-  設計出圖
- 員工與客戶的訓練
-  行動裝置特有的屬性研究


# 工具

- [Responsive Patterns]( http://bradfrost.github.io/this-is-responsive/patterns.html) : A collection of patterns and modules for responsive designs.
針對不同的RWD需求(Layout Nav Grids 等)提供原始碼，使用上來說更靈活。Bootstrap有時後對專案來說太龐大了。



# 參考




[2015年移动设备界面设计趋势](http://mp.weixin.qq.com/s?__biz=MzAwODAzOTU3MQ%3D%3D&mid=205291657&idx=1&sn=e767d9267f29281f8900638e5da87837&scene=2&from=timeline&isappinstalled=0#rd)


RESPONSIVE REPORT 2014

http://2014.report.gridsetapp.com/

模範市場「Facebook 台灣消費者線上行為調查」

http://www.slideshare.net/yuanping/facebook-36279879

设备像素比devicePixelRatio简单介绍

http://www.zhangxinxu.com/wordpress/2012/08/window-devicepixelratio/

https://developer.mozilla.org/en-US/docs/Web/API/Window/devicePixelRatio

font

http://www.w3schools.com/css/css_font.asp

http://zerosixthree.se/8-sass-mixins-you-must-have-in-your-toolbox/

http://www.kangting.tw/2014/04/rwd.html

http://snook.ca/archives/html_and_css/font-size-with-rem

http://clagnut.com/blog/348/


css sprites button

http://blog.brianjohnsondesign.com/responsive-background-image-sprites-css-tutorial/

Media query ie8- 兼容实现总结 - 阿里妈妈MUX

http://mux.alimama.com/posts/686

