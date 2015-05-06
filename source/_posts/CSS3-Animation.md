title: "CSS3 Animation"
date: 2015-04-30 14:59:50
tags:
---

mdn css參考手冊
https://developer.mozilla.org/zh-CN/docs/Web/CSS/Reference

In order to gain support for experimental CSS properties in a particular browser, you mustinclude the 
appropriate vendor prefix and value in your stylesheet. There are just two exceptions:
The browser allows prefix aliases (discussed in the next section).  
The browser follows the final W3C standard and does not require a prefix. 

Limitations of CSS3 Animation

- CSS3 cannot control scroll bars or “scroll” the entire body of the document
- Gradients cannot be animated (although this is possible to achieve with SVG or JavaScript).

Design Principles: 

- Progressive Enhancement  漸近增強
- Graceful Degradation 優雅降級

用於加強(enhance)網站的效果，但不絕對依靠這些新語法


Why CSS3 Rather Than JavaScript or Flash

CSS3

優勢

- 使用簡單
- 效能
- Manipulates existing HTML content, enhancing SEO  / 操作現有的html，加強seo


劣勢

- 兼容度
- 沒有多少GUI界面幫助你制造動畫，你一定要寫程式

Flash

優勢

- 有GUI可以用
- 程式的部份有ActionScript支援


劣勢

- Mobile不支援手機 (most significantly Apple iPhone and iPad together with Android and Windows 8 devices)
- 使用者要安裝程式或更新程式才能使用
- 對seo不好

JS


Advantages

- 好的支援度
- 可以巧妙的操作html籍由dom物件操作跟css的操作，對web開發人員來說是很熟悉的東西
- Loops, variables, and functions make the language more powerful than CSS.

Disadvantages

- 額外的http request 可能會降低讀取速度
- 執行的效能可能不好
-  js 產生的html無法被seo讀取 (這個最新消息是會變)


Other Technologies

CSS3 is not HTML5. While the two technologies tend to be spoken of in the same breath,  •	
CSS3 is not related to HTML5. Markup is not presentation: CSS3 can be equally applied to 
XHTML or HTML3.1. In this book, you’ll be using HTML5 as your markup, but you don’t 
have to.

WebGL is not CSS Animation. WebGL is a JavaScript 3D API that manipulates drawings in  •	
the <canvas> element.



- css3跟html5不是同一個東西，css3跟舊的html一起一樣可以運作正常
- css3不是canvas,canvas是html5的新element，用來讓js畫圖
- css 3d transforms 是 transforms module的一部份，而不是 animation的一部份，css transforms 用來操作物件的視覺交度，但他不會動起來
- webGL 不是 css animation 他是讓js可以操作3d繪圖的api



CSS3 Transforms and Transitions


可以操作所有的HTML元素

Transforms
v. [数][电] 变换；变形（transform的三单形式）
n. 语法转化规则；[数] 变换式（transform的复数）

Transitions
轉場


----

Transforms
https://developer.mozilla.org/zh-CN/docs/Web/CSS/transform

transform-function
https://developer.mozilla.org/zh-CN/docs/Web/CSS/transform-function
事實上所有的變型都可以用
matrix(a, b, c, d, tx, ty)
matrix3d(a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, a4, b4, c4, d4) 代表

一個告訴你matrix是什麼的網站
http://www.useragentman.com/blog/2011/01/07/css3-matrix-transform-for-the-mathematically-challenged/

三角涵數
http://www.cyut.edu.tw/~wdshiau/teach/mathmatic/ch3.pdf

Matrix 類別代表變形矩陣，可決定如何從一個座標空間，將各點對應到另一個空間。
這些變形類型統稱為 「仿射變形」。 仿射變形會在變形時保留線段的筆直性，以便讓平行線保持平行。
![images/2015-05-05_170516.jpg](images/2015-05-05_170516.jpg)
![images/2015-05-05_170702](images/2015-05-05_170702.jpg)
http://help.adobe.com/zh_TW/FlashPlatform/reference/actionscript/3/flash/geom/Matrix.html


欧几里得空间
http://zh.wikipedia.org/wiki/%E6%AC%A7%E5%87%A0%E9%87%8C%E5%BE%97%E7%A9%BA%E9%97%B4


Combining Transformations

transform:  <transform-function> [<transform-function>]* | none

transform-origin: x-axis y-axis z-axis|initial|inherit;

transform所有的值

https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_values_syntax#syntax-single-transition-property

------

There are four main CSS translation functions: 

------
rotate

- Degrees deg 360 degrees in a circle rotate(90deg)
- Gradians grad Also known as “gons” or “grades”. 400 gradians in a circle, making for easier calculations. rotate(100grad)
- Radians rad 2pradians in a full circle, equal to 6.2831853rad. rotate(1.57rad)
- Turns turn A complete rotation = 1 full turn. rotate(.25turn)

issue

- 附件真正的layout不會被改變
- dom物件的屬性不會被影響，例如 offsetWidth
- css的轉換基本是在他原始的空間作相對的角度轉換
- 如果物件轉換超出了父層的可視範圍，如父層的overflow:auto or scroll 那麼scroll bar就會出現
- The rotation occurs from the computed centerof the element, the transform-origin
- Other CSS appearance rules applied to the element, such as  •	 box-shadow, are applied 
beforethe transformation, so they will be rotated with the effect.
- 設定180度並不會翻轉 or 鏡象 要作到翻轉跟鏡象 要使用 scale 
- 你可以ratoe任務html content, 但不推荐去旋轉文字 因為那會有閱讀障礙
- 即史是0還是要寫單位，跟長寬不一樣 其他css常常可以省略屬性

transform-origin 使用方式跟 background-position一樣 左右(水平) 上下(垂直) 軸心的位置相對於
 relative to the element itself.
 軸心可以身外面

webkit issue

chrome safari up to version 5.1 以前 旋轉有剧齒

There are various techniques for getting around this bug :
Apply a 1-pixel white border around the element.	
Apply webkit-backface-visibility: hidden;to the element.
Add another transformation to the element, such as  -webkit-transform: rotate(−10deg) translateZ(0);.
------

scale 


- scale(2) 長寬兩倍
- scale(.5) 4分之1
- scaleX()
- scaleY()
- scaleZ() ← 3d

Flipping/mirror

![](images/2015-05-04_155344.jpg)

- translate
跟 scale很像，他使用相似的座標系統

translate3d(tx, ty, tz)
transform:  translateX(tx)
transform:  translateY(ty) 
transform:  translateZ(tz)-3d Is a <length> representing the z component of the translating vector. It can't be a <percentage> value; in that case the property containing the transform is considered invalid. 

https://developer.mozilla.org/zh-CN/docs/Web/CSS/Reference


------
- skew

skew(ax)       or
skew(ax, ay)


shear mapping
http://dict.youdao.com/search?q=Shear%20mapping&keyfrom=chrome.extension

可以很好的用來表達物體移動的速度感

設定skew的角度，是參照另一個另一個邊


skewX 21 deg 指的是左邊跟右邊，會跟垂直的那條線，打開呈21度
見下圖
![](images/2015-05-04_155344.jpg)

Combining Transformations

重複宣告transform並不會產生集合變形，而是下取代上



------

CSS Transitions

一個可視狀態，過渡到另一個

基本上是點對點的模式
如果你有多個狀態想要過度，你要使用 css的 keyframes

transition 是一个简写属性，可设置 
transition-property, 
transition-duration,  過渡時間 s / ms
transition-timing-function,  
transition-delay。 延遲時間  s /ms

``` css
Formal syntax: [ none | <single-transition-property> ] || <time> || <timing-function> || <time>

```

transition用来定义元素两种状态之间的过渡。不同状态可以用 pseudo-classes 定义，比如 :hover 、:active 或使用JavaScript设置。

↑ 這裡很容易跟 transform搞混 因為 transform 跟 transform-origin是兩個屬性，而且沒有簡寫屬性


Animatable properties
http://css3.bradshawenterprises.com/transitions/
http://www.w3.org/TR/css3-transitions/#properties-from-css-

如何用JS偵測 CSS3 Q過渡完成的事件
https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Using_CSS_transitions

transition 沒有loop loop 要用 animation





transition-duration


作者建議用秒數
因為動畫很少需要用到ms



transition作用在動畫的起始狀態，讓你的動畫可以回到原本的狀態
甚至一半都可以被打斷回到原本的狀態

```
img.tilt {
width: 300px; height: 300px; float: left;
-moz-transition: 2s all; -webkit-transition: 2s all;
-o-transition: 2s all; transition: 2s all;
}
img.tilt:hover {
-moz-transform: rotate(7.5deg); -o-transform: rotate(7.5deg);
-ms-transform: rotate(7.5deg); -webkit-transform: rotate(7.5deg);
transform: rotate(7.5deg);
}
```


Delaying and Combining Transition Effects


Several CSS Properties Transitioned Simultaneosly
```
<style>
img.tilt {
width: 300px; height: 300px; float: left;
-moz-transition: 2s;
-ms-transition: 2s;
-o-transition: 2s;
-webkit-transition: 2s;
transition: 2s;
}
img.tilt:hover {
-moz-transform: rotate(15deg);
-o-transform: rotate(15deg); -ms-transform: rotate(15deg);
-webkit-transform: rotate(15deg); transform: rotate(15deg);
opacity: .3;
}
</style>
```

A CSS3 Transition of Multiple Properties with Different Timings for Each

```

<style>
img.tilt {
width: 300px; height: 300px; float: left; position: relative;
-moz-transition-property: opacity, left;
-o-transition-property: opacity, left;
-webkit-transition-property: opacity, left;
transition-property: opacity, left;
-moz-transition-duration: 2s, 4s;
-o-transition-duration: 2s, 4s;
-webkit-transition-duration: 2s, 4s;
transition-duration: 2s, 4s;
}

img.tilt:hover {
opacity: .2; left: 60px;
}
</style>
```

貝茲曲線DEMO
https://www.jasondavies.com/animated-bezier/

貝茲曲線的公式
http://devres.zoomquiet.io/data/20110728232822/index.html

貝茲曲線在程式語言中
http://www.zhangxinxu.com/wordpress/2013/08/%E8%B4%9D%E5%A1%9E%E5%B0%94%E6%9B%B2%E7%BA%BF-cubic-bezier-css3%E5%8A%A8%E7%94%BB-svg-canvas/