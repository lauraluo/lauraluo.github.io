title: "CSS3 Animation"
date: 2015-04-30 14:59:50
tags:
---

# CSS Vendor Prefixes

- Firefox: -moz-
- Opera: -o- (舊版的才要，新的已改為 -webkit-)
- Safari/Chrome/Konqueror:-webkit-
- IE9+: -ms- 

因為宣告前綴詞

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


# 支援度

完整支援
- Firefox 4 and above  
- Chrome 4 and above    
- Safari 3.1 and above  
- Opera 10.5 and above  
- iOS Safari 3.2 and above  
- Opera Mobile 10 
- Android 2.1 and above
- Internet Explorer 10 (不需要prefixing)


部份支援


# CSS3 作不到的事

- CSS3 cannot control scroll bars or “scroll” the entire body of the document
- Gradients cannot be animated (although this is possible to achieve with SVG or JavaScript).

# 設計原則: 

- Progressive Enhancement  漸近增強
- Graceful Degradation 優雅降級

用於加強(enhance)網站的效果，但不絕對依靠這些新語法


# Why CSS3 Rather Than JavaScript or Flash

##　CSS3

優勢

- 使用簡單
- 效能
- Manipulates existing HTML content, enhancing SEO  / 操作現有的html，加強seo


劣勢

- 兼容度
- 沒有多少GUI界面幫助你制造動畫，你一定要寫程式

## Flash

優勢

- 有GUI可以用
- 程式的部份有ActionScript支援


劣勢

- Mobile不支援手機 (most significantly Apple iPhone and iPad together with Android and Windows 8 devices)
- 使用者要安裝程式或更新程式才能使用
- 對seo不好

## JS


優勢

- 好的支援度
- 可以巧妙的操作html籍由dom物件操作跟css的操作，對web開發人員來說是很熟悉的東西
- Loops, variables, and functions make the language more powerful than CSS.

劣勢

- 額外的http request 可能會降低讀取速度
- 執行的效能可能不好
-  js 產生的html無法被seo讀取 (這個最新消息是會變)

# CSS3 VS HTML5

- css3跟html5不是同一個東西，css3跟舊的html一起一樣可以運作正常
- css3不是canvas,canvas是html5的新element，用來讓js畫圖
- css 3d transforms 是 transforms module的一部份，而不是 animation的一部份，css transforms 用來操作物件的視覺交度，但他不會動起來
- webGL 不是 css animation 他是讓js可以操作3d繪圖的API


# CSS3 Transforms and Transitions


在開始前，因為css有三個Trans開頭很容易搞混的東西，所以我先幫大家釐清一下

- transform  變形，在CSS3中俱有 縮被、位移、旋轉、傾斜
- translate  前者的其中一個值，能將物件變形，達到位移的效果
- transition 漸變，或是可以稱作為補間，描述兩個字值如何作轉換 

- transforms 指的是變形這一系列，所有相關的數值，接下來會提到
- transitions 補間的所有相關數值

## Transform

https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_values_syntax#syntax-single-transition-property

### rotate：旋轉物件

#### 語法 

``` css

transform: rotate(0.5turn);

```

#### 單位 

- Degrees `deg` 360 degrees in a circle `rotate(90deg)`
- Gradians `grad` Also known as “gons” or “grades”. 400 gradians in a circle, making for easier calculations. `rotate(100grad)`
- Radians `rad` 2pradians in a full circle, equal to 6.2831853rad. `rotate(1.57rad)`
- Turns `turn` A complete rotation = 1 full turn. `rotate(.25turn)`

#### 注意事項

- 0還是要寫單位，跟長寬不一樣 其他css常常可以省略屬性
- 設定180度並不會翻轉 or 鏡象 要作到翻轉跟鏡象 要使用 scale 





## Transition





http://www.w3.org/TR/SVG/coords.html#TransformMatrixDefined

下回待續
## CSS3 Animate and key-frame
## transition3D