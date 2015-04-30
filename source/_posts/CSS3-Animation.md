title: "CSS3 Animation"
date: 2015-04-30 14:59:50
tags:
---


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



