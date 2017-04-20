title: Chrome Extension 開發與實作 10
date: 2016-12-24 12:10:08
categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 快捷鍵輸入組件 Shortcut Key or Commands

## 快捷鍵輸入組件的簡介

Chrome允許Extension設定多組快捷鍵，當這個快捷鍵被觸發時，可以處理對應的操作。快捷鍵設定使用Command API。

<!--more-->  

下圖展示了，當我按下一組快速鍵時，右上角瀏覽器按鈕的ICON，進行了切換。  

![](https://quip.com/blob/ACYAAA5TWjU/oblUYXAB7EADCB2PPBrIgg?a=tm66UYJmFDCuH92gGPkbXQrfOKp2OZa6aPGKTfEVAvwa)

## 快捷鍵輸入組件能作到什麼事


*   讓User更方便的使用你Extension中的功能，提升使用經驗。  
*   除了自定義的操作邏輯外，還允許綁定Chrome提供的預設操作，例如：快速啟動瀏覽器按鈕，快速啟動頁面按鈕。  
*   快捷鍵的定義是允許使用者重新客制化的。(會蓋掉設定檔的定義)使用者可以在 chrome://extensions/configureCommands 對話框中手動添加更多的快捷鍵。  


## 用法

### 按鍵設定


*   一個擴充工具可以擁有多組快速鍵的設定  
*   但一個快速鍵的設定，最多只能有四個按鍵組成  
*   支持的按鍵包括：  
    -   A～Z、0～9、  
    -   逗號、句號、  
    -   Home、End、PageUp、PageDown、Insert、Delete、方向鍵（上、下、左、右）  
    -   和多媒體鍵（上一曲（MediaPrevTrack） 、下一曲（MediaNextTrack）、播放/暫停（MediaPlayPause）、停止（MediaStop））。  
    -   所有組合鍵必須包含 Ctrl 或 Alt 中的一個。  

*   不允許使用涉及到 Ctrl+Alt 的組合鍵，以免與 AltGr 鍵衝突。除了 Alt 或 Ctrl 外還可以使用 Shift 鍵，但不是必須使用。組合鍵（例如 Ctrl）不能與多媒體按鍵一起使用。  
*   出於輔助功能的原因，從 Chrome 33 開始不支持 Tab 鍵。  
*   Mac的Ctrl會自動轉換成Command，如果要正確的指定Ctrl請使用MacCtrl  
*   快捷鍵是有優先等級的，例如視窗管理的快捷鍵優先等級高尋擴充功能的快捷鍵指令，無法被覆蓋。  


### 安裝檔設定

```
      {  
        "name": "我的擴充功能",  
        ...  
        "commands": {  
          "switch-icon": {  
            "suggested_key": {  
              "default": "Ctrl+Shift+Y",  
              "mac": "MacCtrl+Shift+Y"  
            },  
            "description": "切換Action的Icon"  
          },  
          "_execute_browser_action": {  
            "suggested_key": {  
              "windows": "Ctrl+Shift+Y",  
              "mac": "Command+Shift+Y",  
              "chromeos": "Ctrl+Shift+U",  
              "linux": "Ctrl+Shift+J"  
            }  
          },  
          "_execute_page_action": {  
            "suggested_key": {  
              "default": "Ctrl+Shift+E",  
              "windows": "Alt+Shift+P",  
              "mac": "Alt+Shift+P"  
            }  
          }  
        },  
        ...  
      }
```


*   快捷鍵允許是用key/value的 方式成對宣告。  
*   屬性`global`可設定你的快捷觸發，是所有視窗(true)，或是目前使用者fcous的視窗(false)，但除了Chrome OS除外，目前還不允許全局設定。  
*   使用suggested_key除了定義快捷鍵，還能指定作業系統。  


### 監聽命令的觸發

運用onCommand (`chrome.commands.onCommand`)監聽事件，callback將會接受快捷鍵的名稱作為回傳值，接著你就可以用回傳值判斷相應的動作：  

```
chrome.commands.onCommand.addListener(function(command) {  
    console.log('Command:', command);  
});
```

除了監聽快捷鍵的觸發，你還可以使用`chrome.commands.getAll(function callback)`  
取得你擴充功能的快捷設定，如果你需要的話。  

## 內建操作

**要特別特別注意的一點是： `_`  **作為一個保留前綴，保留給Extension一些內建操作，而開發者定義的快速鍵名稱如果使用**`_`**當前綴的話會導致錯誤。  

```
"_execute_browser_action": {  
    "suggested_key": {  
        "windows": "Ctrl+Shift+Y",  
        "mac": "Command+Shift+Y",  
        "chromeos": "Ctrl+Shift+U",  
        "linux": "Ctrl+Shift+J"  
    }  
},  
"_execute_page_action": {  
    "suggested_key": {  
          "default": "Ctrl+Shift+E",  
          "windows": "Alt+Shift+P",  
          "mac": "Alt+Shift+P"  
    }  
}  
   
```

### 如果你有設定彈出視窗 ：

`_execute_browser_action`(執行瀏覽器按鈕) 以及 `_execute_page_action`(執行頁面按鈕)，只會觸發預定的彈出視窗角本，不會產生其他可處理的事件(例如onClicked)，所以如果你有些邏輯必需與彈出視窗一起載入，可考慮在彈出視窗腳本裡，使用 `onDomReady`事件來處理。  

### 如果你沒有設定彈出視窗

`_execute_browser_action`(執行瀏覽器按鈕) 以及 `_execute_page_action`(執行頁面按鈕)，會自動同步觸發你的`browserAction.onClicked`以及`browserAction.onClicked`事件。  

> 要注意內容腳本無法直接使用Command的API，但利用Chrome的訊息API，可以讓事件腳本接受到快捷鍵觸發事件時，再把消息傳遞給內容腳本

> 只要有指定彈出視窗，`browserAction.onClicked`以及`browserAction.onClicked`事件都會被它檔住，所以這裡無法觸法事件跟快捷鍵的設定沒有關係，我覺得官網只是想跟你陳述一個狀況。但說法容易讓人誤會快捷鍵不會觸發點擊事件。所以在這裡分成兩個狀況討論有助大家理解。

## 使用者的快捷鍵管理介面

輸入chrome://extensions/ configureCommands，便可呼叫出設定快捷鍵的界面(如下圖)。使用者可以隨他的喜好覆蓋掉安裝檔中的設定。一組快捷鍵只能設定一次，重覆宣告同一組快捷鍵，會直接將前一個設定清空。(所以我推理如果兩個擴充功能打架，後者會覆蓋前者)  

![](https://quip.com/blob/ACYAAA5TWjU/xw_Ju6u2GbJFQgUBRkpykA?a=aKVHT0ClEx8fZ2VYh9xUcAPlC3GO9m9PtjyoUiNLMXYa)

## 動手作看看

功能描述：利用快捷鍵改變載入網頁的背景顏色  

### 設定檔

```
{  
    "manifest_version": 2,  
    "name": "鐵人賽-Commands範例",  
    "description": "切換臉書背景顏色",  
    "version": "2.0",  
    "page_action": {  
        "default_title": "切換臉書背景顏色",  
        "default_icon": "icon.png"  
    },  
    "permissions": ["tabs","activeTab", "declarativeContent"],  
    "commands": {  
        "switch-fb-bg": {  
            "suggested_key": {  
                "default": "Ctrl+Shift+Y",  
                "mac": "MacCtrl+Shift+Y"  
            },  
            "description": "切換FB的背景顏色"  
        }  
    },  
    "background" : {  
        "scripts" : ["event.js"],  
        "persistent" : false  
    }  
}
```

### 事件腳本

```
var toggleBg = false;  

chrome.commands.onCommand.addListener(function(command) {  
    console.log('Command:', command);  
    if(command == "switch-fb-bg" && toggleBg){  
        chrome.tabs.executeScript({  
            code: 'document.body.style.backgroundColor="red"'  
        });   

        toggleBg = !toggleBg;      
    }  
    else if (command == "switch-fb-bg" && !toggleBg) {  
        chrome.tabs.executeScript({  
            code: 'document.body.style.backgroundColor="black"'  
        });   
        toggleBg = !toggleBg;      
    }  
});
```

### 結果展示

![](https://quip.com/blob/ACYAAA5TWjU/RztzxIckeiow-Yh9Zbwwrg?a=1c1tvjS9bPi02HIJAbgwIUshViiMewgiGXUadtJ5Kkga)

> 完整程式碼在[Github](https://github.com/lauraluo/ExtensionSample/tree/master/ShortcoutKey)

## 補充：兩個擴充功能如果宣告同樣的快捷鍵會如何？  

如果兩個擴充功能，擁有一樣的快捷鍵設定會如何？我試著去作了實驗，原本以為後載入的會蓋掉前者，但事實上我們可以看到以下圖為例，Commands範例A比Commands範例B還早載入到擴充功能力，但同樣的快捷鍵設定A被保留了，B被清掉成空白。  

![](https://quip.com/blob/ACYAAA5TWjU/BCpF9JZ3nhzbmIn68Ul9KQ?a=DTQOcaX7BS3frPu3akwa7Dxldhqa729YTtn4LZ00Py0a)

## 小結


*   快捷鍵的按鍵組合是有一些條件限制的。  
*   快捷鍵可自行定義操作行為，Chrome也提供一些內建行為供開發者設定。  
*   `chrome.commands.onCommand`可監聽快捷鍵的觸發，並以回傳的名稱判斷操作行為。  
*   當開發者沒有指定彈出視窗時，快捷鍵設定`_execute_browser_action`(執行瀏覽器按鈕) 以及 `_execute_page_action`(執行頁面按鈕)會觸發對應的onClick事件。  
*   在網址列輸入chrome://extensions/ configureCommands，可以開啟快捷鍵的自定義介面。  
* 如果有同樣的兩個擴充套件宣告同一組快速鍵，Crhome會保留舊的，而新的那個設定，將會是空白的。



## 參考


*   [https://developer.chrome.com/extensions/commands](https://developer.chrome.com/extensions/commands)  

*   [https://crxdoc-zh.appspot.com/extensions/commands](https://crxdoc-zh.appspot.com/extensions/commands)  

*   [http://www.apress.com/us/book/9781484217740](http://www.apress.com/us/book/9781484217740)  
 

 

