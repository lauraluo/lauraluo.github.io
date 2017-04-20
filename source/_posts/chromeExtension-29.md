title: Chrome Extension 開發與實作 29
date: 2017-1-12 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 安全性相關的設置

## 跨網域的數據存取XHR

一般網頁的腳本都受限於Same-origin policy(相同來源政策)的規範，不能跨網域向遠端請求及接收數據(例如ajax)，但擴充功能不在此限，只要你在安裝檔裡宣告跨站權限，就能進行跨網域的處理。(但記得一定要宣告)
<!--more-->

### 設定檔

```
{
  "name": "我的擴充功能",
  ...
  "permissions": [
    "http://www.google.com/"
  ],
  ...
}
```

網域可以使用完整的內容，也能使用[匹配表達示](https://crxdoc-zh.appspot.com/extensions/match_patterns)，例如以下的網址都是合法的：

* "http://www.google.com/"
* "http://www.gmail.com/"
* "http://*.google.com/"
* "[http://](http:/)*/"

網址匹配表達示的格式如下：

```
協議://host(主機)/path(路徑)
```

在使用匹配表達式指定跨網域存取的權限時，必需連同服務+主機一起指定，所以如果你的協議有兩種，就得分開宣告：

```
"permissions": [
  "http://www.google.com/",
  "https://www.google.com/"
]
```

而path在這裡指定了也沒有作用，會直接被忽略

## 內容的安全策略宣告

你可以在安裝檔中設定你的[安全策略](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy)，以限制文本中引用不同類型的內容時，其來源限制，以下為例：(要注意上一段xhr在講的跟遠端的數據請求，這裡指的是上下文即內容裡外部資源的安全性)

```
{
  ...,
  "content_security_policy": "[POLICY STRING GOES HERE]"
  ...
}
```


只要在設定檔裡有設定 [`manifest_version`](https://crxdoc-zh.appspot.com/extensions/manifestVersion)(清單文件)就會有默認的安全策略，而如果宣告為2版，則預設的安全性如下：

```
script-src 'self'; object-src 'self'
```


* [`script-src`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/script-src)：腳本的安全策略。
* [`object-src`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/object-src)：指定一些html嵌入的資源，其存取限制，例如[`<object>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/object), [`<embed>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/embed), 以及 [`<applet>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/applet) 元素(常用來導入flash等多媒體件)，的安全設置。
* 以上兩個內容的值被指定為 'self'，代表只允許來自相同來源的內容（相同的協議，域名和端口）。

> 有關安全性策略可設置的細節，這裡爬到一篇不錯的文章，提供給大家參考：[Content Security Policy 介绍](https://imququ.com/post/content-security-policy-reference.html)


根據上面的默認值，擴充功能的腳本會有下列限制：

### 一、使用字串執行腳本求值的相關方法全部禁用

以下為例。其中的new Function就是導致無法直接用cdn取用vue資源庫的原因。

```
alert(eval("foo.bar.baz"));
window.setTimeout("alert('hi')", 10);
window.setInterval("alert('hi')", 10);
new Function("return foo.bar.baz");
```

由於上面的方法都存在跨網域腳本攻擊的風險，所以用以下方式取代：

```
alert(foo && foo.bar && foo.bar.baz);
window.setTimeout(function() { alert('hi'); }, 10);
window.setInterval(function() { alert('hi'); }, 10);
function() { return foo && foo.bar && foo.bar.baz };
```

### 二、限制了嵌入腳本


禁用在HTML裡使用`<script>`這個區塊宣告，例外也不能直接在DOM物件上綁定事件：例如`<button onclick="...">`

### 三、限制遠端內容的存取

也就是不能使用CDN加載外部的資源庫，以下為例：

錯誤示範

```
<!doctype html>
<html>
  <head>
    <title>範例</title>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
  </head>
  <body>
    <button>按鈕</button>
  </body>
</html>
```

正確示範

```
<!doctype html>
<html>
  <head>
    <title>我做的很棒的弹出内容！</title>
    <script src="jquery.min.js"></script>
  </head>
  <body>
    <button>单击看看会发生什么！!</button>
  </body>
</html>
```

## 放寬內容的安全政策

### 一、放寬內嵌腳本

* Chrome 45以前，沒有任何的方法可以放寬內嵌腳本的安全政策，所以你設定什麼都沒差。
* Chrome 46以後，允許你使用[**Hash usage for script elements**](https://www.w3.org/TR/2015/CR-CSP2-20150721/#script-src-hash-usage)的方法內嵌腳本。(基於 base64-encoded的)。

### 二、放寬遠端內容的存取

你可以使用白名單的指定，來放寬遠端內容的嵌入：

* Chrome目前只允許以下協議設定為白名單：
    * `blob`
    * `filesystem`
    * `https：`必需與主機(host)一起宣告
    * `chrome-extension` `：`必需與主機(host)一起宣告
    * `chrome-extension-resource`

為了開發方便，我們也允許你使用地端的位址作為白名單，例如： `http://127.0.0.1`以及` `http://localhost` `


> 以上標示為"必需與主機(host)一起宣告"，即代表不允許https :, https：// *和https：//*.com之類的匹配表達，但允許使用類似https：//*.example.com的子域名匹配表達



允許通過HTTPS加載來自example.com的腳本資源的放寬策略定義如下：

```
"content_security_policy": "script-src 'self' https://example.com; object-src 'self'"
```

一個常見的使用情境便是開發人員必需使用GA追蹤擴充功能成效時，必需放寬腳本內容的權限以便嵌入GA代碼，大家可以參考官方範例：[Tutorial: Google Analytics](https://developer.chrome.com/extensions/tut_analytics)

### 三、放寬求值相關的方法


禁止 eval 及類似構造，像 setTimeout(String)、setInterval(String) 以及 new Function(String) 的策略也可以通過向您的策略添加 unsafe-eval 來放鬆，以下為例：(但官方強列的希望你不要這麼作)

```
"content_security_policy": "script-src 'self' 'unsafe-eval'; object-src 'self'"
```

## 使用更嚴格的內容的安全政策

經由default_src 'self'的宣告，可以讓內容來源的安全性更加嚴格，例如`[Mappy](https://developer.chrome.com/extensions/samples#mappy)這個官方範例就`展示了這個擴充功能只能引入來自己擴充功能文件檔裡的資源：

```
"content_security_policy": "default-src 'none'; style-src 'self'; script-src 'self'; connect-src https://maps.googleapis.com; img-src https://maps.google.com"
```

## 內容腳本與內容安全政策(一個例外)

內容於本不受限於內容安全政策，主要是因為內容腳本不是html，所以他可以自由的使用eval這種建構方法，我們也可以使用內容腳本在使用者的網頁裡嵌入script區塊，以下為例：

```
document.write("<script>alert(1);</script>");
```

無論安裝檔裡怎麼宣告內容的安全性政策，這段代碼 一執行到就會立即alert。但如果你今天插入的內嵌Script裡牽扯到了事件，狀況就會變的比較複雜，以下為例：

```
document.write("<button id='mybutton'>click me</button>'");
    var button = document.getElementById('mybutton');
    button.onclick = function() {
      alert(1);
    };
  
```

由於點擊事件不會馬上執行，而是等點擊事件後，才執行內容腳本的代碼，於是網頁的內容安全政策可能會禁止腳本的執行(注意，不是擴充功能的，而是使用者頁面的網站)。

另一個狀況也可能導致結果不如開發者預期，以下為例：

```
var script = document.createElement('script');
    script.innerHTML = 'eval("alert(1);")';
    document.getElementById('body').appendChild(script);
```

上面的例子中，eval的達行同樣會被網頁的內容安全政策阻檔而不能運行。

## 參考

* https://crxdoc-zh.appspot.com/extensions/contentSecurityPolicy
* https://developer.chrome.com/extensions/contentSecurityPolicy
* https://imququ.com/post/content-security-policy-reference.html
* https://developer.mozilla.org/zh-CN/docs/Web/Security/CSP/Using_Content_Security_Policy












