title: Chrome Extension 開發與實作 28
date: 2017-1-11 12:10:08

categories:
- chrome extension
- 2017 IT邦幫忙鐵人賽
tags: 
- IT邦幫忙鐵人賽
- chorme extension
- 2017
---

# 佈景主題(themes)

我們可以使用擴充功能改變Chrome的外觀，他是一種特別的擴充功能，雖然打包的過程與平常的擴充功能無異，但它不包含Javascript與HTML。

<!--more-->

你可以在下列網址找到Chrome的各種布景。
https://chrome.google.com/webstore/category/themes

## 屬性與修改內容

能修改的屬性非常多，這裡只邏列一些常用的部份：

* theme_frame—頁籤的外框，也就是包含頁籤背景的那個部份
* theme_toolbar—工具列與現在正focus的頁籤，也就是網址列與瀏覽器按鈕所在的那一列(在視窗上一體的)
* theme_ntp_background—預設"另開新頁的"頁籤的背景
* theme_ntp_attribution—預設"另開新頁的"頁籤的背景，主題作者的署名圖片
* tab_text—設"另開新頁的"頁籤的標題
* ntp_text—"另開新頁的"頁籤的所有文字的長相
* button_background—所有Chrome視窗上的按鈕(例如：回首頁、上一頁、下一頁、最小化、重新整理等)
* buttons—網址列右側，瀏覽器按鈕/頁面按鈕的初始顏色
* frame—Chrome-瀏覽器外框的長相
* frame_inactive—瀏覽器外框的長相，在視窗不活躍的時後
* frame_incognito—瀏覽器外框的長相，在視窗隱形的時後
* frame_incognito_inactive—前兩者的相加

## 屬性的值

根據上面列表屬性的不同，通常我們可以使用下列幾種方式為屬性定義他的值

* colors：使用RGB
* images：使用圖片指定長相，路徑指定為擴充功能根目錄的相對路徑。
* properties/ui properties：改變一些UI的屬性，儲如背景對齊，背景重複，替代icon等屬性。
* tints：改變部份UI的色調，可調整圖片的飽和度以及亮度，例如瀏覽器按鈕、瀏覽器外框、不活躍的頁籤色調。色調以色調 - 飽和度 - 亮度（HSL）的格式指定，使用0〜1.0之間的浮點數：
    * 色調為絕對值，0和1為紅色。
    * 飽和度相對於當前提供的圖片.0.5表示沒有變化，0表示完全不飽和，1表示完全飽和。
    * 亮度也是相對的，0.5表示沒有變化，0表示所有像素均為黑色，1表示所有像素均為白色。


至於完整的屬性與其值的完整列表，在網路上有爬到一篇很[完整教學](https://sites.google.com/site/gsugsa/google-apps/google-chrome/how-to-create-a-theme)，教學中提供了以下資訊：

* 提供畫面及索引的對照表
* 詳細的列出了哪些屬性可以以設定哪些內容(哪些可用colors，那些可用images、哪些可用tints等)
* 文章中提供了一些圖片的尺寸限制(以下截取部份示列)

![http://ithelp.ithome.com.tw/upload/images/20170111/200794500R9EJ4cow4.png](http://ithelp.ithome.com.tw/upload/images/20170111/200794500R9EJ4cow4.png)

## 佈景主題的設定檔

對照上面的介紹，大家會發現他的結構是：colors/images/properties/tints→屬性，這一點比較特別。

```
{
  "version": "2.6",
  "name": "camo theme",
  "theme": {
    "images" : {
      "theme_frame" : "images/theme_frame_camo.png",
      "theme_frame_overlay" : "images/theme_frame_stripe.png",
      "theme_toolbar" : "images/theme_toolbar_camo.png",
      "theme_ntp_background" : "images/theme_ntp_background_norepeat.png",
      "theme_ntp_attribution" : "images/attribution.png"
    },
    "colors" : {
      "frame" : [71, 105, 91],
      "toolbar" : [207, 221, 192],
      "ntp_text" : [20, 40, 0],
      "ntp_link" : [36, 70, 0],
      "ntp_section" : [207, 221, 192],
      "button_background" : [255, 255, 255]
    },
    "tints" : {
      "buttons" : [0.33, 0.5, 0.47]
    },
    "properties" : {
      "ntp_background_alignment" : "bottom"
    }
  }
}
```

## 參考

* https://sites.google.com/site/gsugsa/google-apps/google-chrome/how-to-create-a-theme
* https://developer.chrome.com/extensions/themes









