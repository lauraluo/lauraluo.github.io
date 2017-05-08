title: "React單元測試 (一) 初探基礎知識"
date: 2017-05-8 17:00:07
tags: 
- React
- 單元測試
- bdd
- tdd
categories:
- react

---

## 前言

以一個前端開發者的角度來探討測試的基本知識及概念，軟體開發史這麼長，不敢說自己理解絕對正確，歡迎大家糾錯討論。(部份內容引用自網路文章，皆有標注出處)

<!-- more -->

## 相關概念

### TDD

**測試驅動開發**（英語：Test-driven development，縮寫為TDD)  

參考[這篇簡報](https://www.slideshare.net/dualface/bdd-1068404)中的定義：強調在寫代碼之前，先根據需求撰寫測試，然後再撰寫程式來實現測試案例中的需求，最終通過不斷的修正代碼來通過所有的測試案例，交付有品質的代碼。  

在我過去的開發經驗中這些流程在資深工程師上是自然而然的行為，當一名工程師拿到需求後相關工作流程如下：  

*   分析需求要實作的功能  
*   依據規畫依續完成功能的實作  
*   檢驗程式碼是否準確的完成需求  
*   重構程式  
*   交付程式碼(祈禱沒有問題)  


在這些流程中，前端開發人員要不停的重複操作以確定每一塊的功能實作完整，但其實這樣非常花費時間，由其在程式碼的重構階段，想將代碼調整的較優美或增加方法的彈性，卻擔心影響到已完成的功能流程。先撰寫測試案例的好處除了要求工程師有先設計後執行的思維，最大的好處是自動化測試，所以即使開發人員在重構或疊加功能的過程中，也不用擔心意外的破壞已完成的功能。(終於可以脫離不停重新整理瀏覽器的日子)  

讓我們將原本的工作流程修正加入TDD的概念  


*   分析需求要實作的功能  
*   針對需求要完成的功能，先寫測試，因為功能還沒實作完成，所以所有的測試結果一定會失敗  
*   往始開發每個功能，並且讓測試通過  
*   優化你的程式碼，期間必需保持測試通過，不必擔心在重構的過程中部份相依單元功能失效  
*   交付程式碼  


下圖引用自[https://www.slideshare.net/dualface/bdd-1068404](https://www.slideshare.net/dualface/bdd-1068404)  

![](https://quip.com/blob/ZYFAAAWZiZi/5lysrlVZ5ct6zkGMsbb93g?a=H5aEKnfK3FTE9n72qe2oYatnzOF8o50RyabTOCk3MoQa)

### BDD

**行為驅動開發**（英語：Behavior-driven development，縮寫**BDD**  

參考[這篇簡報](https://www.slideshare.net/dualface/bdd-1068404)中的定義：行為驅動使用一種「通用語言」，讓需求端與開發端用統一的介面定義系統行為。籍以避免表達不一至帶來的問題(表達不一致是開發過程中常遇見的問題，由此造成最終作出來的系統脫離客戶期望)。使用通用語言，需求端可以與開發端一同定義出系統行為，從而做出符合需求端的設計。然而光有設計沒有驗証是不夠的，所以BDD要跟自動化測試結合在一起，用系統行為的定義來驗証實程式碼功能的實現。  

在我過去開發經驗中常遇到的開發問題如下，BDD是TDD的進化，他重要想要解決的問題如下：  


*   與需求端雞同鴨講：延申的問題有兩個面向，要求需求端用通用語言的方式思考，接著將這些描述當作規格書來驗收程式碼。  
*   BDD可以協助工程師聚焦在需求上：開發人員的設計應優先滿足需求，再來考慮彈性(重構單性時有測試保護)，另一個面向是說明某個功能的實作是為了對應哪些需求，讓後續維護的工程師，可以理解你的程式碼。  


使用「通用語言」來描述需求，則系統其中一方的行為被稱為故事，書寫規格如下：  

### Story：故事，描述故事的單行文字，格式如下

Story：#標題 身為一個「_角色_」，我想要「_特定的功能_」，以便「_得到好處_」  

### Scenario：情境，對應需求下的系統行為，

Scenario：描述場景的單行文字  


*   Given：描述該情境的先決條件或是環境的準備  
*   When：描述當下的動作  
*   Then：描述預期的結果  
*   And：附加的條件會行為  


```
Given….When…then… 這樣的語法結構稱為 “Gherkin”
```

```
BDD的測試案例通常以spec為後綴，例如dialog的test，會稱為 dialog.sepc.jsx
```

實例：(引用自 [https://www.slideshare.net/wantingj/tdd-bdd-47559903](https://www.slideshare.net/wantingj/tdd-bdd-47559903))  

需求描述    

*   User story：[帳戶持有人要領錢]
*   身為一個 [帳戶持有人]，我想要 [從atm領錢]，以便 [可以在銀行關門後領 到錢]  

系統行為, 一個需求會有一系列的場景來定義驗證標準  

*   Scenario [1]：[帳戶裡有足夠的錢，要給錢]  
	*   Given [帳戶餘額100] and [有效的領款卡] and [提款機夠錢]  
	*   When [帳戶持有人要求提20元]  
	*   Then [提款機應該給20] and [帳戶餘額80] and [退提款卡] ○  

*   Scenario [2]：[帳戶裡沒有足夠的錢，要提示餘額不足]  
	*   Given [帳戶餘額100] and [有效的領款卡] and [提款機夠錢]  
	*   When [帳戶持有人要求提120元]  
	*   Then [提示餘額不足] and [退提款卡]  


接著分享一些我在研究測試相關知識的幾個盲點：  

### 以為TDD跟BDD是對立的只能擇其一：

BDD是TDD的進化，重點著重在著寫測試案例時，群組這些測試的是需求的情境，但驗証這些情境是否正確的，還是TDD，所以TDD的精神並沒有不見(例如：在某個情境中還是要依靠驗証方法的正確性來確認需求是否完成)。  

> 以為 BDD == 測試介面流程，BDD == 整合測試 ，TDD == 單元測試，而且這是不可動搖的。

大多數人在探討TDD時，多數以單元測試為例，籍由驗証程式最小功能單位的品質來，來提升軟體品質。  
大多數人在探討BDD時，多數以整合測試為例，很常籍由運行瀏覽器的模擬器來作為BDD的實例。  

根據以上的呈述，可以理解我為什麼會有 BDD == 測試介面流程，BDD == 整合測試 ，TDD == 單元測試這種認知，但事實上TDD及BDD只是在呈述測試時的角度不同。就算是單純共用的函數，也可以使用BDD的呈述來表達當初設計時程式時想要解決的需求情境。  

例如： 
scenario 所有的網站在處理代表金錢的數字時，都要加上三位一點  
*   given  如果調用者傳入字串 abc  
*   then 期望函數要報錯  
*   given 如果調用者傳入數字 1000  
*   then 系統會回傳加上3位一點的字串 1,000  


另外一個值得討探的議題是，早期前端缺乏模組化開發的方式，所以前端很難進行單元測試，但至從react流行之後，前端的單元測試變得較能實作，其測試工具跟框架也被一一實作，但現在討探測試的相關文章或書籍或是有名的書籍，其來源都是漫長的軟體開發的經驗的整合，比較不會探討到前端最近的現況。但像react這種以組件為單為來開發介面用的框架，很適合使用BDD來進行介面組件的單元測試及呈述開發者當初設計組件的目的(某個介面需求)。所以我跟同事認為BDD之於單元測試是有討論空間的。  

## 測試階段

下面這張圖簡單的介紹測試在軟體開發中的不同階段與其目的，我個人覺得在整個軟體開發過程中，應該有比較面向開發人員的部份，及面向QA人員的部份。  

面向開發人員的部份，目的會就重在探討測試協助程式設計及程式碼的交付品質確認，其中的單元整合測試，及單元測試，應該屬於開發人員的範圍，其餘個人認為在責任分野上，比較偏QA(驗收)單位。**所以接下來文章探討的內容，會較偏重單元測試的部份。**  

![](https://quip.com/blob/ZYFAAAWZiZi/9Yak6H9nmqWOZr623Nwzcw?a=cM4ROUYU2acYMldwJikjYA85YgcsjR1YfBNxuSx7V8oa)

圖片來源：[http://www.mpinfo.com.tw/about_5.php](http://www.mpinfo.com.tw/about_5.php)  

## 前端單元測試框架

測試框架的定義：一個測試框架應該具備的功能有：運行測試、提供測試資源庫(或設定接口)、產出測試報告、提供測試資料接口、撰寫測試情境。  

大家可以參考以下兩個文章，下圖截錄文章中的一部份，讓大家理解現在流行的工具的流行狀況。  


*   [A complete overview of the JavaScript landscape in 2016:about Test Framework](https://risingstars2016.js.org/#test-framework)  
*   [Testing Frameworks2016](http://stateofjs.com/2016/testing/)  


![](https://quip.com/blob/ZYFAAAWZiZi/PBcbqPwPWG_a6k9wUuCI6g?a=ialVovJwq506E2oCktiaea6jM6btpJjSvv2e48hnQnga)

圖片來源：[A complete overview of the JavaScript landscape in 2016:about Test Framework](https://risingstars2016.js.org/#test-framework)  

![](https://quip.com/blob/ZYFAAAWZiZi/X9FKGvBm1ZuLUkN_c_YzAw?a=5Q0SQ7Zg3PVAVu7X2Hi5LKfOhQVwzJN0GgaeING4os8a)

圖片來源：[Testing Frameworks2016](http://stateofjs.com/2016/testing/)  

### 撰寫測試案例

在撰寫測試案例前，先讓我們了解一個測試案例的組成結構  


*   測試情境：分為BDD與TDD通常內建在測試框架裡。  
	*   BDD 風格 ：test()  
	*   BDD風格：describe()  
*   斷言庫(assertion library)：斷言庫的存在目的，是為了讓工程師在撰寫測試案例的情境判別上能更語義化，有關於斷言庫的資源可以參考[Mocha的介紹](https://mochajs.org/#assertions)。有些框架內建自己的斷言庫，也允許開發人員選擇自己的斷言庫。  

	*   BDD 風格 ：assert()  
	*   BDD：expect()、should()  
*   測試工具(Testing utilities)：  
	*   在測試時能模擬React組件安裝實例的Enzyme。  
	*   為了摸擬使用者操作，我們會需要瀏覽器環境準備  
		*   Browser driver 直接驅動瀏覽器模擬使用者操作行為： WEBDRIVERI/O 、Selenium WEBDRIVERI  
		*   Headless browser 沒有真正驅動瀏覽器，所有結果會在命令字元環境進行： JSDOM、Phantomjs  


> 有關於BDD與TDD的語言風格，感覺只是一種共識，必非強制規則，所以各家測試框架似乎都有自己的詮釋。

> 雖然前面說到了BDD中情境的撰寫風格 “Gherkin”，但前端單元測試比較流行`describe…it`這種撰寫風格，跟朋友請益後說這種寫作風格的起源是RoR。

以下方程式碼為例：我們可以看到一個測試案例的撰寫，除了Jest提供的測試框架，還可以整合各式各樣的工具。而斷言庫主要負責的便是判斷程式碼運行的結果如不如預期(回傳階是true  or false)。  

```javascript
import React from 'react'    
import { expect } from 'chai'; //引用斷言庫   
import {mount, render, shallow} from 'enzyme'    
import DemoComponent from "./DemoComponent"    
//describe 與 it 來自 jest提供的方法  
describe('DemoComponent: ', () => {  
    //使用enzyme取得react安裝後的實例  
    const wrapper = mount(<DemoComponent/>);    
    it('應該要顯示文字，"this is demo"', () => {   
        //expect引用自斷言庫  
        expect(wrapper.text()).to.contain('this is demo');    
    })    
});  

```

DemoComponent的內容  

```javascript
import React, {Component} from 'react'  

class DemoComponent extends Component {  
    constructor(props) {  
        super(props);  
        this.state = {};  
    }  
    render() {  
        return (  
            <div>  
                <p>this is demo</p>  
             
        );  
    }  
}  
export default DemoComponent;
```

測試的運行指令如下  

```
jest src/components/demo/DemoComponent.spec.jsx
```

測試結果如下  

![](https://quip.com/blob/ZYFAAAWZiZi/stK3hM-Ci7S52Hnl7Mj5tw?a=ae05BPje6RScpg1Qp9cxEtHZugli0Q6mZdnf2OJTagoa)

## 小結


*   TDD：測試驅動開發幫助你在程式碼重構的過程中檢查功能的正常，鼓勵先設計再撰寫程式。  
*   BDD：TDD的進化，主要想解決開發過程中，需求端與程式開發端的溝通落差，中心思想是除了功能測試功能正常，更要驗証是否確實滿足需求。  
*   Unit Test：單元測試，中心思想是，如果所有最小單位的功能正常，則我們可以推測由最小單位集合而成的軟體具有一定的品質。  
*   嚐試各種測試框架的過程中發現，Jamisne與Mocha皆有複雜性高，學習曲線長的議題，由於想降低單元測試的導入成本，所以跟團隊成員討論過後，暫定使用react官方打造的測試框架Jest搭配與Enzyme為主要方案。(可以參考這篇文章 [前端开发自动化单元测试趋势](http://web.jobbole.com/89946/))  


## 參考

- [http://zhenhua-lee.github.io/tech/test.html](http://zhenhua-lee.github.io/tech/test.html)  
- [https://risingstars2016.js.org/#test-framework](https://risingstars2016.js.org/#test-framework)  
- [http://stateofjs.com/2016/testing/](http://stateofjs.com/2016/testing/)  
- [http://www.mpinfo.com.tw/about_5.php](http://www.mpinfo.com.tw/about_5.php)  
- [http://www.html-js.com/article/Nodejs-testing-automation-E2E-testing--WebDriverJS-Jasmine-and-Protractor](http://www.html-js.com/article/Nodejs-testing-automation-E2E-testing--WebDriverJS-Jasmine-and-Protractor)  
- [https://techblog.commercetools.com/testing-in-react-best-practices-tips-and-tricks-577bb98845cd](https://techblog.commercetools.com/testing-in-react-best-practices-tips-and-tricks-577bb98845cd)  
- [https://www.slideshare.net/dualface/bdd-1068404](https://www.slideshare.net/dualface/bdd-1068404)  
- [https://www.slideshare.net/wantingj/tdd-bdd-47559903](https://www.slideshare.net/wantingj/tdd-bdd-47559903)  
- [https://risingstars2016.js.org/#test-framework](https://risingstars2016.js.org/#test-framework)  
- [http://stateofjs.com/2016/testing/](http://stateofjs.com/2016/testing/)



