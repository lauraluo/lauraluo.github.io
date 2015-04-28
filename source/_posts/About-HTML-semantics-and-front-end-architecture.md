title: "HTML語意化及前端架構 About HTML semantics and front-end architecture"
date: 2014-11-11 17:04:01
tags: 
	- semantics
	- OOCSS
	- BEM
	- SMACSS

categories:
	- CSS
photos:
	- /images/1024px-Lego_Color_Bricks.jpg


---


# About HTML semantics and front-end architecture

About HTML semantics and front-end architecture[原文](http://nicolasgallagher.com/about-html-semantics-front-end-architecture/)

![](/images/1024px-Lego_Color_Bricks.jpg)


一篇有點歷史的文章，作者有在Twitter工作過，沒錯!馬上該想到有名的**Bootstrap**(不過不知道作者有沒有參與)。不算完全翻譯，這是一遍蠻深奧的文章，所以翻譯中除了原作者提供的之外，有加入我找到的相關資料以及我的看法。雖然英文不是很好，但我儘量表達到位。那我們開始吧。

----

 集合了一些想法、經驗、我喜歡的概念，還有最近這些年我已經在嘗試的概念，包括了HTML的語意化、元件、前端架構的設計方法，類別的命名方式、HTTP壓縮。


> We shall not cease from exploration
And the end of all our exploring
Will be to arrive where we started
And know the place for the first time.
T.S. Eliot – “Little Gidding”

> 我們不會停止探索
而一切探索的終點
將會是我們下一次探索的開始
T.S. Eliot – “Little Gidding”

<!--more-->




## 關於語意學

語意學主要在研究信號跟符號以及他們代表什麼。在語言學中，他主要是是信號含意(包括文字、常用語、跟聲音)、或是語言的研究。語意學在前端開發這塊領域，主要關注在、HTML、 attributes跟attributes value(包括microdata)方面的語意協定。這些語意協定，主要是正式的規範。可以被用來幫助開發人員更好的去了解網站的資訊。然而即使經過形式化，元素、屬性、屬性的值等語意對開發人員來說還是會因為理解或是吸收而被調整。語意化引導我在未來去調整我們的HTML。(這就HTML設計原則。)


----

## 兩種不同的含義的HTML命名方式 

### 表達內容的本質

- h1 element,
- lang attribute,
- email value of the type attribute,
- Microdata

但不是所有的語義化都是從內容衍申出來的(content-derived)

類別名稱必需語意化，無論他他們被用來表達什麼都要有意義，Class的語意化可以有別於HTML Element
，我們可以用全局的HTML元素、或是HTML的屬性或Microdata等等，以免跟區域的網站/應用中常常使用的值混肴(例如Class的名稱)

[HTML5 specification section on classes](http://www.w3.org/html/wg/drafts/html/master/dom.html#classes)寫到**最佳實踐**的假設中

> 鼓勵作者：(但這篇文章的作者不支持)
> [class的值]應該被用來描寫內容的本質，而不是內容呈現的樣子

我們沒有非得這麼作的理由，事實上這反而是開發大型網站的阻礙：

- 內容面的語意化已經被HTML Element或是其他屬性給滿足了
- Class名稱對網站的拜訪者或是機器意義很少、甚至沒有意義(除了少部份的microdata，詳情可以參考這一篇 [從搜尋到社群 - Semantics、Rich Snippets、Social Meta Tags](http://cythilya.blogspot.tw/2014/02/search-and-social.html))
- Class名稱常用來當JS的hook：如果你不必用Class來表達呈現面或是行為面，你大概也不需要放Class在你的HTML
- Class名稱應該提供對開發人員有用的資訊：當你在閱讀一段HTML片段時，這會幫助你理解Class的特性,特別是多個前端工程師維護同一個HTML的時後

下面是一個簡單例子：不好的範例

``` html
<div class="news">
    <h2>News</h2>
    [news content]
</div>

```

這個class`news`沒有告訴你任何東西(事實上他要表達的早就明顯的表達在他的內容`h2`的news)

它沒有表達任何架構或是元件，而且它沒辦法用在不是`news`的內容上，
如果把你的class名稱與內容本質緊緊的結合在一起，已經大大的減少你的結構被擴張，或是被其他工程師引用的能力


### 從內容脫離關係(Content-independent)的類別

取而代之的在設計中從重複的結構或是功能樣板來衍申語意，大多重用性組件，擁用的Class名稱從內容脫離關係的。
我們不應該因為害怕圖層失去清楚而明確的角義，而不讓類別反應具體的含意，這麼作並不會讓你的內容失去語意，它只是表達了他的語意必不是由內容衍生出來的

我們也不應該害怕去增加html elements，如果這能幫助我們創造更強壯(不容易被複寫或是影響)、更俱有彈性、更具有重用性的組件，這麼作不會讓你的HTML失去語意，這只是代表你使用了最低限度的元素，去裝飾你的內容


## 前端結構 

一個 元件/樣版/物件導向結構的目標是開發一個有限數量的重用性元件來滿足特定範圍的不同內容，在重要的應用中類別的語義被實用主義所衍申，並且他們最主要的目標就是-提供有意義、有彈性、而且有重用性 的勾子(呈現或行為)給開發人員使用


## 可重用，且可組合的組件

俱擴展性的 HTML/CSS 大體上來說，必需依賴HTML內的層級，去達到可重用組件的創造

一個有彈性以及重用性的元件，即不依靠存在DOM tree的片段，也不需要特定的HTML元素。他應該能適用各種容器、以及容易提供(風格)主題，如果是必要的話，擴張額外的HTML元素(不僅是為了裝飾內容)用以打造更強壯的元件。[Nicole Sulivan](http://www.stubbornella.org/)的[media object](http://www.stubbornella.org/content/2010/06/25/the-media-object-saves-hundreds-of-lines-of-code/)是個好例子.

組件能更容易組合，經由避免[type selectors](http://www.w3.org/TR/CSS2/selector.html#type-selectors)，下面的例子中，`.btn`組件可以輕易的跟`uilist`組合在一起。但問題是

- `.btn`(10)的選擇器層級小於`.uilist a`(11)(後者會覆寫前者的屬性)
- uilist 這個組件需要用 `a`作為他的child nodes

``` css
.btn { /* styles */ }
.uilist { /* styles */ }
.uilist a { /* styles */ }
```

``` html
<nav class="uilist">
    <a href="#">Home</a>
    <a href="#">About</a>
    <a class="btn" href="#">Login</a>
</nav>

```
![CSS Specificity](/images/css-specificity-10.jpg)

讓你能更方便將別的套件跟`.uiliat`組合的改善方法如下，使用(純)class來修飾他的子元素。

這雖然減少規則的特異性(請參考 [註 CSS Specificity: Things You Should Know ](http://www.smashingmagazine.com/2007/07/27/css-specificity-things-you-should-know/)以及 [What the Heck Is CSS Specificity](http://designshack.net/articles/css/what-the-heck-is-css-specificity/)), 主要的好處是，給你更多個自由將樣式結構應用在任何子節點(無論是`<a></a>`還是`<button></button>`)


``` css

.btn { /* styles */ }
.uilist { /* styles */ }
.uilist-item { /* styles */ }

```

``` html
<nav class="uilist">
    <a class="uilist-item" href="#">Home</a>
    <a class="uilist-item" href="#">About</a>
    <span class="uilist-item">
        <a class="btn" href="#">Login</a>
    </span>
</nav>
```

## JavaScript-specific classes

使用特定型式的javascript樣式可以用來減少風格或是結構的改變讓JS壞掉的風險，其中一個方法是為了JS使用特定的Class`.js-*`，而且不要在它上面作任何樣式定義

``` html
<a href="/login" class="btn btn-primary js-login"></a>
```

這方法，可以減少組件的風格或是結構改變，對JS行為的跟功能的復雜度所造成的影響。

組件(Component)的維護

組件經常擁有一些變異性，跟基本組件的樣貌有些微的差異，例如：不同的背景色或是不同的框線，下面有兩種模式經常用於創造這些變異性。我把他們稱作 **single-class** 以及 **multi-class** 模式.


### The “single-class” pattern
 
``` css
.btn, .btn-primary { /* button template styles */ }
.btn-primary { /* styles specific to save button */ }
```

``` html
<button class="btn">Default</button>
<button class="btn-primary">Login</button>
```

> 譯者註：這個模式的好處是HTML比較乾淨，但樣式引用不易，使用SCSS的**@extend**產出的CSS會像上面這樣

### The “multi-class” pattern

``` css
.btn { /* button template styles */ }
.btn-primary { /* styles specific to primary button */ }
```

``` html
<button class="btn">Default</button>
<button class="btn btn-primary">Login</button>
```

> 譯者註：這個好處是樣式方便引用，但帶來Class鎖碎且HTML肥大的壞處，另外就是你要改長像就要調整HTML

如果你有使用**pre-processor**(SCSS、LESS 等)你可能使用SCSS的**@extend**方法去減少一些涉及**single-class **pattern的維護工作。([詳請在SCSS的Inheritance](http://sass-lang.com/guide))但即使我們使用了**pre-processor**我還是偏好使用**multi-class**pattern，並且在HTML去調整class

我發現一個更有彈性的模式，舉個例子如果我有一個按鈕，除了基本的長相外，他需要另外**5**個顏色跟**3**個大小，使用**multi-class**至少需要9個Class(1+5+3)，但如果使用**single-class**你至少需要24個Class((5+1)*(3+1)

如果確實需要的話(絕對必要的狀況下，因為通常不到必要我們不希望這麼作)，他能更容易讓組件作上下層的調整，你可想在另一個組件中，對**所有的**`.btn`作一些小調整。(範例如下)


``` css
/* "multi-class" adjustment */
.thing .btn { /* adjustments */ }
```

> 譯者註：作者是指，多類別模式你可以經由多一個上層的選擇器來複寫`.thing`中所有的`.btn`樣式，但單類別要像下面這個例子

``` css
/* "single-class" adjustment */
.thing .btn,
.thing .btn-primary,
.thing .btn-danger,
.thing .btn-etc { /* adjustments */ }
```

## 有結構的類別名稱

當創造組件-組件打造的**樣板**-有些Class被用來打造組件的邊界，一些被用來打造組件的修改器，還有一些用來連合一個DOM nodes轉化成一個更大的抽像化呈現組件。

我們很難去理解 **btn (component)**, **btn-primary (modifier)**, **btn-group (component)**, 以及 **btn-group-item (component sub-object)**之間的關聯，因為它的選擇器名稱並沒有清楚的表達他的意思，而且也沒有一個一致的Pattern。

我在2011年開始嚐試[naming pattern](https://gist.github.com/1309546)，去幫助我快速的在節點之間的DOM程式碼片段所呈現的關係，而不是試圖不停的切換JS、HTML、及CSS檔案，來拼湊出完整的網站架構。選擇的符號要點主要受[BEM system](http://bem.github.com/bem-method/html/all.en.html)的影響，不過我把他改編成一個更容瀏灠的格式。

從我第一次寫這篇文章以來，幾個其他的團隊或是框架采用了這個方法，
[MontageJS](https://github.com/montagejs/montage)將命名方式改編成另一個風格，但還是偏好使用[SUIT framework](https://github.com/suitcss/suit)


```css
/* Utility */
.u-utilityName {}
 
/* State-utility */
.u-isStateName {}
 
/* Component */
.ComponentName {}
 
/* Component modifier */
.ComponentName--modifierName {}
 
/* Component descendant */
.ComponentName-descendant {}
 
/* Component descendant modifier */
.ComponentName-descendant--modifierName {}
 
/* Component state (scoped to component) */
.ComponentName.is-stateOfComponent {}
 
/* Component mixin (ancestor style dependencies) */
.with-ComponentName {}

```

這不過是一個我發現有幫助的命名方式，它可以採取任何模式，但好處在於他消除有歧意的CLASS名稱，而且僅僅依靠下畫線、連字符、以及camel case。


> 譯者註：將下來作者都比較類性談概念性的東西邊收尾，所以我只標一些重點。


## A note on raw file size and HTTP compression

這是一篇有探論到檔案大小最佳化的簡報[Our Best Practices Are Killing Us by Ｎicole Suillvan](http://www.slideshare.net/stubbornella/our-best-practices-are-killing-us),像FB這麼大的公司，省下幾KB都是很驚人滴。

總之就是大家怕這種命名規則檔案會很肥，作者說他有實驗 經過HTML compression 其實差不多，另外作者還提到大家要關注壓縮完的檔案大小，而不是壓縮前的。

## 我如何學會停止憂心

大意是說很多有經驗的開發人員參於過大型網站(應用)的改版，內容衍申的語意化不切實際。如果你要完成一個大型應用，你必需拋棄舊的想法，想想別的替代方案，甚至是你以前丟掉的那些方案。

一旦你開始跟其他人一起迭代開發應用，你很快就會發現你的代碼還是愈來愈難維護，有些人提出他們的解法方式，這些值得你去花時間探索(以下是作者例舉了幾個方法，並付上官網連結，這篇譯文的結尾奉上，並補充其他我找到的資料)

當你選擇用HTML跟CSS寫作，並試圖減少你花在CSS上的編輯時間，你必需花更多的時間在修改你HTML上的CLASS。這個成果是非常實用的，這讓開發人員無法前後端，都可以重新安排**樂高積木**，事實証明沒有人可以執行CSS鍊金



## 參考

- [CSS Specificity: Things You Should Know ](http://www.smashingmagazine.com/2007/07/27/css-specificity-things-you-should-know/)
- [What the Heck Is CSS Specificity](http://designshack.net/articles/css/what-the-heck-is-css-specificity/)

## CSS的架構法方論：OOCSS/SMACSS/BEM

### OOCSS 
- [OOCSS官網](http://oocss.org/) 
- [OOCSSGIT](https://github.com/stubbornella/oocss/wiki) 
- [OOCSS導讀](http://www.stubbornella.org/content/2010/06/25/the-media-object-saves-hundreds-of-lines-of-code/) 

### SMACSS
- [SMACSS官網](http://smacss.com/book/)
- [SMACSS導讀](http://www.smashingmagazine.com/2012/04/20/decoupling-html-from-css/)  
- [中文導讀]( http://csspod.com/decoupling-html-from-css/)

### BEM
- [BEM官網](http://bem.info/)
- [BEM導讀](http://www.integralist.co.uk/posts/maintainable-css-with-bem/)

### 綜合探討

- [漫談 CSS 架構方法 - 以 OOCSS, SMACSS, BEM 為例 by Kuro Hsu](http://www.slideshare.net/kurotanshi/css-oocss-smacss-bem)
