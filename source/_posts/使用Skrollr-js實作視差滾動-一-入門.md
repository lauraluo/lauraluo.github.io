title: "使用Skrollr.js實作視差滾動-(一)入門"
date: 2014-10-31 15:23:42
tags: 
	- css3
	- html5
	- parallax
	- Skrollr.js
	- 視差滾動
categories:
	- tools
photos:
	- images/scrollrdemo3.gif

---
Parallax Scrolling又名視差滾動，在江湖上已經流傳了這麼久，雖然是老梗但用在網頁上的效果一直很不錯，作前端工程師應該總會遇過設計或是需求用閃亮期待的眼神問你作不作得到。我們會在接下來的章節中利用工具實作視差滾動的的效果。


我們將假設你會以下技術,否則在接下來的介紹裡，你可能會感覺有點吃力。

- Css3：動畫實作經驗
- JQuery 或 Javascript
- SASS 或 SCSS


<!--more-->

![](/images/scrollrdemo3.gif)

*****

## 什麼是視差滾動

[Parallax](http://en.wikipedia.org/wiki/Parallax "Parallax") 視差 這個專有名詞在電腦圖學最早出現在1982年一款叫[Moon Patrol](https://www.youtube.com/watch?v=39EsNumG3Fc)的遊戲裡，簡單來說就是利用多張圖片疊加在一起，在畫面上用不一樣的速度移動：而遠的物件動的較慢，近的物件動的較快，利用這種方式來產生偽3D的錯覺效果。


![](/images/111019_0.jpg)
[圖片引用來源](http://www.mrmu.com.tw/2011/10/19/parallax-scrolling/)

![Demo](/images/111019_1.gif)
[圖片引用來源](http://www.mrmu.com.tw/2011/10/19/parallax-scrolling/)

後來在WEB應用中，讓使用者使用視窗的ScrollorBar產生有趣的使用體驗，愈來愈多類似的作品在網路上出現，搭配HTML5的技術、CSS3的動畫、還有JQuery、SVG 產生各式各樣的延申變化令人眼睛為之一亮。


*****


## Skrollr.js [連結](https://github.com/Prinzhorn/skrollr"视差滚动(Parallax Scrolling)"skrollr")

- 使用**Html5**及**CSS3**實作
- **純Javascript** library不用依靠Jquery 
- Skrollr被設計來支援**mobile**與**desktop**
- 最小化後只有12k
- 提供對設計師友善API(只需要動HTML與CSS)


## Skrollr的相關資源

**官方插件**

- [skrollr-menu](https://github.com/Prinzhorn/skrollr-menu)：使用他可以很容易讓頁面上的導航與產生互動
- [skrollr-ie](https://github.com/Prinzhorn/skrollr-ie)：提供IE9以下的CSS Fixes
- [skrollr-stylesheets](https://github.com/Prinzhorn/skrollr-stylesheets)：擴充CSS語法，讓開發人員直接在CSS中對影格進行控制


**第三方插件**

- [skrollr-colors](https://github.com/FezVrasta/skrollr-colors) - 支援跨rgb、hex、hsl顏色的轉換
- [skrollr-decks](https://github.com/TrySound/skrollr-decks) - 把你的網頁變成全螢幕的SlideShow

**教程或是相關的Blog文章**

教程或討論文章，不過我覺得中文的好像很少XD，所以我才自己想寫 **[點此連結](https://github.com/Prinzhorn/skrollr/wiki/Resources "點此連結")**


**使用Skrollr的作品集**

真的蠻多的，所以開發者叫你自己去看[作品集連結](https://github.com/Prinzhorn/skrollr/wiki/In-the-wild "作品集連結")，但我覺得作品集品質並沒有都很穩定，看來主要還是看設計功力。


**Skrollr的開發概念**

開發者認為其他的框架會有以下兩項問題：

- **動作**及**物件**並不在同一個地方，為了查看一段動畫的意義，你可能要滾動好幾千行的JS程式碼(聽起來很可怕)：  
- 要學新的語言(時間有限，而你的專案很趕)

所以Skrollr的開發者想用下面兩種方式解決這個問題：

- 有動畫影格控制的概念，而且可以跟**物件**有關聯
- 使用你已經知道的CSS語法

呈上，開發者表示如果你更傾向使用JS來定義所有的動畫或有充足的學習時間，可以考慮[ScrollMagic](https://github.com/janpaepke/ScrollMagic)，他是一個使用JQuery，及[GSAP](https://greensock.com)的框架

> 筆者補充：GSAP是一個動畫框架，比起純JQUERY他的效能更好，比起CSS3+HTML5他的兼容性又更高。缺點就是要學習(不過對Flash轉過來的人應該比較友善)，另外他不是一個完全免費的服務。


## 安裝Skrollr

在`</body>`前放入`skrollr.min.js`，然後使用`skrollr.init()`初始化

``` html
    <script type="text/javascript" src="skrollr.min.js"></script>
    <script type="text/javascript">
    var s = skrollr.init();//初始化
    </script>
</body>

```



## 開始Skrollr


使用下列語法，產出隨著SkrollBar往下拉，DIV一邊變色一邊滾動的效果[DEMO] (http://prinzhorn.github.io/skrollr/examples/docu/3.html)

``` html
<div data-0="background-color:rgb(0,0,255);transform[bounce]:rotate(0deg);" 
	 data-500="background-color:rgb(255,0,0);transform[bounce]:rotate(360deg);">WOOOT</div>

```




解析這段語法函義：

- `data-0`：Skrollr使用data來定義影格，0代表SkrollrTop的值：畫面中有兩個影格分別是`data-0`與`data-500`，而裡面的值，則分別用CSS來定義他的過渡效果

- `ackground-color:rgb(0,0,255)`：Skrollr只能使用 hsl 跟 rgba 的色彩編碼(但你可以使用插件[skrollr-colors](https://github.com/FezVrasta/skrollr-colors))

- `transform[bounce]`：
	- Skrollr的實作原理是將CSS3的transform從原本的秒數，變成SkrollTop的PX數，應此開發人員另外提供了擴充語法來支援CSS3的非線性函數
	- Skrollr會處理CSS3的Prefix問題


## Skrollr提供的Keyframe用法

Skrollr沒有針對動畫作太多擴充功能，因為他儘量依賴CSS3實作動畫，所以Skrollr的實作重點，就在於他提供的Keyframe控制工具，我健議在這裡花時間搞懂，在下一次的實作裡才會相對輕鬆。

什麼是Keyfame：學Flash的就想像他是關鍵影格，想像影片的播放Bar中的秒數在視差滾動實作中，概念被轉化成了ScrollBAR及物件的offset. 

Skrollr提供下列兩個Keyframe用法。

### absolute mode (document mode)：將**文本(document)**在視窗中的位置，也就是Scroll Top當作觸發影格的關鍵

定義：
#### `data-[offset]-[anchor]`

- offset：定義偏移值，型別為整數值，可以是負值，不指定時為`0`：這裡的偏移值概念上是以文本為基準，我們可以理解為取得視窗相對於文本的偏移位置(參考下圖)，也就是Skroll top
- anchor：定義參考點(錨點)，有`Start`或`End`兩個參數，預設值為Start.：定義了偏移值的參考位罝是文本的開頭還是結尾
- 這兩個參數至少要有一個

讓我們看以下，下列分別定義了哪些關鍵影格

- `data-0` = `data-start` = `data-0-start`:  scrolltop = 0

- `data-100` = `data-100-start`: scrolltop = 100

- `data--100` = `data--100-start`: scrolltop = -100

- `data-end` = `data-0-end`: 當文本到達結尾的時後

- `data-100-end`: 當文本到到結尾的前100px

- `data--100-end`: 當文本到到結尾後，超過100px(開發者說，不管你用不用得到XD)


補充說明：

如果用jquery來表達的話，你可以想像當下列事件觸發的時後，代表各keyframe的CSS屬性將會作用在Dom物件上
(雖然Skrollr用的是純JS XD)

``` javascript
//data-0
$(window).scrollTop() = 0 
//data-100
$(window).scrollTop() = 100
//data--100
$(window).scrollTop() = -100
//data-100-end
$(window).scrollTop() = $(document).outerHeight() - $(window).Height() + 100
//data--100-end
$(window).scrollTop() = $(document).outerHeight() - $(window).Height() - 100

```

[DEMO](http://prinzhorn.github.io/skrollr/examples/anchor_target.html)

![](/images/absolute.jpg)


### relative mode(viewport mode)：將**Dom物件(element)**在視窗中的位置，當作觸發影格的關鍵

#### `data-[offset]-(viewport-anchor)-[element-anchor]`

- offset：定義偏移值，型別為整數值，可以是負值，不指定時為`0`：用來定義物件與視窗的偏移值(兩個物件的相對位置) 
- viewport-anchor： 定義視窗的參考位置，可以是 `top`(預設值)，`center`，`bottom`，指的是視窗的上緣，下緣，以及中間
- element-anchor：定義物件的參考位置 可以是 `top`(預設值)，`center`，`bottom`，指的是物件的上緣，下緣，以及中間

讓我們看以下，下列分別定義了哪些關鍵影格

- `data-top` = `data-0-top` = `data-top-top` = `data-0-top-top`: 當視窗的上緣跟的物件上緣重疊的時後

- `data-100-top` = `data-100-top-top`: 當視窗的上緣跟物件的上緣重疊後，又超過了100px

- `data--100-top` = `data--100-top-top`: 當視窗的上緣跟物件的上緣重疊後，重疊前的100px

- `data-top-bottom `= `data-0-top-bottom`: 當視窗的上緣，跟物件的下緣重疊的時後(這時你是看不到物件的，但可以作為物件從畫面上方進場前的準備)

- `data-center-center` = `data-0-center-center`: When the element is at the center of the viewport.：當視窗的中間跟物件的中間重疊的時後(在使用者的眼前，畫面的中間)

- `data-bottom-center` = `data-0-bottom-center`: 當視窗的底部，與物件的中間重疊的時後(物件準備退場)


在relative模式中，可以使用`data-anchor-target`改變物件的參考對像從視窗變成另一個物件。

範例: `<divdata-anchor-target="#foo">` 


[DEMO](http://prinzhorn.github.io/skrollr/examples/anchors.html)
![](/images/relative.jpg)

### 限制及Debug

- 使用keyframe指定CSS屬性時，從同一個屬性請使用統一的單位：如果兩個keyframe間使用不同的單位，則不會作用
- 如果使用了composed，例如：`margin:0 0 0 0;`則另一個keyframe也要使用composed否則沒有作用
- 如果使用transforms指定多個屬性值順序也要一樣：`rotate(0deg) scale(1)` → `rotate(90deg) scale(2)`
- 色彩只能使用rgb()、rgba()、hsl()、hsla()，而且兩個keyframe只能作用同一色彩函式：rgb(255,255,255) → rgb(255,255,200)

*****

## skrollr-stylesheets 在CSS檔裡定義keyframe

上面的例子中，我們發現keyframe散亂HTML各處，維護起來非常費時。所以接下來我們介紹在CSS檔裡維護keyframe的方式。
使用前面提到的官方Plugin -[skrollr-stylesheets](https://github.com/Prinzhorn/skrollr-stylesheets)：擴充CSS語法，讓開發人員直接在CSS中對影格進行控制，甚至還可以加**SASS**搭配使用，維護起來應該會方便很多。

### 安裝 

- 只有1kb
- 支援IE8+

**step1**

在`</body>`前加入`dist/skrollr.stylesheets.min.js`，而且要在Skroll.js之前，他的作用原理就是分析CSS快速將對應的`data`屬性塞在CSS選擇器對應的物件裡面，所以開發人員可能會擔心效能問題，但這裡先不討論。

**step2**

放一隻CSS，如下 

``` html
<link rel="stylesheet" type="text/css" href="style.css" data-skrollr-stylesheet />
```

### 使用 

**HTML**

``` html
<div id="foo"></div>
```

**CSS** 

``` css
#foo {
    -skrollr-animation-name:animation1;
}

@-skrollr-keyframes animation1 {
    0 {
        left:100%;
    }

    2000 {
        left:0%;
    }

    top {
        color:rgb(0,0,0);
    }

    bottom {
        color:rgb(255,0,0);
    }
}
```

**輸出結果**

``` HTML
<div id="foo" data-0="left:100%;" data-2000="left:0%;" data-top="color:rgb(0,0,0);" data-bottom="color:rgb(255,0,0);"></div>
```

### 搭配SASS

使用SASS可以更好利用變數或是運算來控影keyframe

``` css
$about_section_begin: 0;
$about_section_duration: 2000;
$about_section_end: $about_section_begin + $about_section_duration;

@-skrollr-keyframes animation1 {
    #{$about_section_begin} {
        left:100%;
        opacity#{"[swing]"}: 0.0;
    }

    #{$about_section_end} {
        left:0%;
        opacity: 1.0;
    }
}

```


*****


## Javascript的部份

除了HTML及CSS，開發者也列出Skrollr提供的JS功能，有興趣的人可以去看的文件，我這裡只會列出幾個比較重要的功能。開發者標榜，如果是不懂程式語言的設計師，可以不看JS的功能。

## 初始化及參數

使用下列語法初始化，而`init()`會回傳instance，所以可以這樣寫

``` js

var scrollObj = skrollr.init({
  //跟smoothScrolling的功能，主要都是讓scroll事件不要這麼敏感，動畫才不會看起來卡卡的。
  smoothScrolling : true,
  smoothScrollingDuration:200,
  
  //可以定義一些常數在影格使用，Example: data-_myconst-200 and skrollr.init({constants: {myconst: 300}}) result in data-500.
  
  constants:{
    initTop:100
  },
  
  //可以調整ScrollBar往下拉對應到keyframe的值等倍放大
  scale:1,
  
  //讓文本高度自動達到滿足Keyframe的條件
  forceHeight:true,
  
  //針對行動裝置的功能
  mobileCheck:function(){},
  mobileDeceleration:0.004,
  
  //畫面一開始，元素的初始值set：物件上第一個影格的值，ease：相對畫面開始的Scrolltop值使用兩格影格作參考，reset:使用他原生的CSS值
  edgeStrategy:'set'，
  
  //render事件
  render: function(data) {
      //Log the current scroll position.
      console.log(data.curTop);
  }

});

```





render事件可以取得一些物件的資訊


``` js
{
    curTop: 10, //the current scroll top offset
    lastTop: 0, //the top value of last time
    maxTop: 100, //the max value you can scroll to. curTop/maxTop will give you the current progress.
    direction: 'down' //either up or down
}
```


## keyframe 

為了接收keyframe事件，物件上必需加上`data-emit-events`屬性。

HTML 

``` HTML
	<div
	    data-500="..."
	    data-top-bottom="..."
	    data-_offset-center="..."
	    data-emit-events
	>
	    Some content
	</div>
```


回傳值有三個：
- element 發射事件的物件
- name keyframe名稱
- direction 使用者滾動方向

``` js
skrollr.init({
    keyframe: function(element, name, direction) {
        //name will be one of data500, dataTopBottom, data_offsetCenter
    }
});

```

## 其他功能

- skrollr.get() Returns the skrollr instance


使用下列語法，在初始化Skrollr後，可取他的實例使用以下功能

``` js

var scrollObj = skrollr.init();

```

- skrollObj.refresh([elements])
- skrollObj.getScrollTop()
- skrollObj.getMaxScrollTop()
- skrollObj.rsetScrollTop(top[, force = false])
- skrollObj.risMobile()
- skrollObj.ranimateTo(top[, options])
- skrollObj.rduration
- skrollObj.reasing
- skrollObj.done
- skrollObj.stopAnimateTo()
- skrollObj.isAnimatingTo()
- skrollObj.on(name, fn)
- skrollObj.off(name)
- skrollObj.destroy()

## 本篇總結

### Skrollr的優點

- 入門快，不需要學新的語言
- 檔案小 
- 對設計師友善
- 兼容行動裝置的瀏覽器

### Skrollr的缺點

- 以HTML跟CSS3為基礎，所以如果很重視IE兼容度的需求端，不適合使用
- keyframe沒有先後關係，物件的關系也很平，不適合作太複雜的動畫，這應該是面向設計師多過工程師的缺點：不過我自己覺得有時後視覺效果很棒的視差網站，並不需要太複雜的動畫，而是要看設計師的設計功力，就這點而言選擇這個方案也沒什麼不好。


Skrollr基本上功能沒有很強大(跟[GSAP](https://greensock.com)比)、完全依懶CSS3、相較於華麗複雜的特效；他更適用於概念簡單的效果、面向設計多師過於工程師、支援手機(如果這讓你說服你的老闆的話XD)。

以上就是Skrollr的入門教學，在下一篇中我們會開始教大家作組點實例的應用，儘請期待。
預告：使用Skrollr.js實作視差滾動-(二)實作基礎篇


## 參考及引用 

- [skrollr](https://github.com/Prinzhorn/skrollr)
- [skrollr-stylesheets](https://github.com/Prinzhorn/skrollr-stylesheets)
- [網頁設計中的多層視差滾動效果 (Parallax scrolling)](http://www.mrmu.com.tw/2011/10/19/parallax-scrolling/)
- [http://wedesignpixel.com/best-jquery-parallax-scrolling-tutorials/](http://wedesignpixel.com/best-jquery-parallax-scrolling-tutorials/
- [http://jquer.in/category/jquery-plugins-for-awesome-scrolling-and-scrollbars-on-websites/](http://jquer.in/category/jquery-plugins-for-awesome-scrolling-and-scrollbars-on-websites/)
- [http://desiznworld.com/2013/07/free-jquery-parallax-scrolling-plugins.html](http://desiznworld.com/2013/07/free-jquery-parallax-scrolling-plugins.html)


