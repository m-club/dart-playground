# Dart Angular 整体思路

好了，现在你应该知道：

1. 如何使用代码和用户交互；
2. 如何使用代码操纵html页面；
3. 如何处理根据API文档发送/处理http req/resp；
4. plus 如何构建自己的简单http server；

既然你已了解了dart web的基础，那么你应该可以完成一个功能如同[Google Ads](https://ads.google.com/intl/en_us/home/?subid=us-en-et-g-aw-a-home-awhp_awx!o2m--ahpm-0000000014-0000000000)的网站了吧。

emmm...理论上来说，知道了1+1=2就了解了数学的本质。可是若是要推导高阶函数收敛极值所在，还是需要使用微积分公式，follow一个规则，完全明白它是如何得来如何实现的最好，但在无法完全理解的情况下，信任这种规则的结论也是必要的。

在前两篇中提到的是基础，但若是使用它们来搭建稍微复杂一点的场景就会有功能模块不好划分，页面结构复杂不好维护等问题。所以，我们需要一个框架，这里我选了**Angular**。

### 中文文档传送门

[AngularDart文档翻译](https://github.com/soojade/AngularDart_doc_cn)，这一篇是我觉得翻译得最好的了，这里面基本就包括了官方文档中的内容。里面介绍了AngularDart中的各种特性，可以照着写，也可以当作查询用。

## dart应用文件结构惯例

一个dart应用的文件结构是有惯例的，[官方文档](https://www.dartlang.org/tools/pub/package-layout)中有详细说明，这里我写写我们用得到的。

![structure](src_4_structure.png)

dart中也有一个便利的工具叫做**stagehand**，可以帮你自动建立一个符合特定需求的文件夹结构。仅使用stagehand会列出你需要的project类型。stagehand不是开发必需的，它只是比较方便。

``` bash
# 安装stagehand
pub gloabal activate stagehand
# 使用stagehand
cd <your_work_dir>
stagehand <project type>
```

## Angular的设计模式

在体验了一回AngularDart开发之后，我觉得Angular的意图有二，一是模块化，将各种操作划分开来，封装成一个模块，使得代码逻辑清晰；二是减少重复性劳动代码。

这样说起来太空洞，我来写几个例子。在这一节里若是有不清楚的代码细节可以参考一下[中文文档](https://github.com/soojade/AngularDart_doc_cn)中的相关内容。

### 模块化组件

我们知道在html文档中一个tag就是一个元素，而html页面就是由有结构的各种元素组成，然后通过使用代码操纵各个元素来完成与用户的交互。Angular定义了一个Component的概念，就是将功能相对独立的一系列html+代码交互塞到一个tag里面去。

这里我写了一个示例[狗狗狗](http://www.imandui.com/fun/get_me_a_dog/)，用来表达一下最近都撸不到大狗的怨念。看起来这个页面里有一个button，一个提示行，一个图片展示，那么我们的入口index.html中是怎样的呢？

``` html
<!DOCTYPE html>
<html>
  <head>
    <title>react_play</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="styles/bulma.css">
    <link rel="icon" type="image/png" href="favicon.png">
    <script defer src="main.dart.js"></script>
  </head>
  <body>
    <get-me-a-dog>Loading...</get-me-a-dog>
  </body>
</html>
```

那些按钮提示图片交互汇成了一个tag，也就是<get-me-a-dog>，这就是Angular中的Component啦。

#### 如何定义一个Component

具体到相应的代码(random_dog.dart)中，可以看到每一个Component中，视图是由html+样式表定义的，数据逻辑则在dart文件中（具体代码会放在src_dart_basics_4中）。

``` dart
// 使用AngularDart需要引用这个文件
import 'package:angular/angular.dart';

// @Component在前修饰GetMeADog类，在编译时就会告诉webdev，这是一个组件
@Component(
  // 即在其他html中使用什么tag会唤起这个component  
  selector: 'get-me-a-dog',
  // 即这个component的html结构，简单的可以如下编写，复杂的可以使用templateUrl指向一个单独的html文件
  template: '''
  <div class="wrapper">
    <button (click)="getMeADog()" [disabled]="disabled">
        亲爱的普京，我想要一条...</button>
    <div>{{randomDog}}</div>
    <img [src]="imageUrl">
  </div>
   ''',
  styleUrls: ['random_dog.css'],
)
class GetMeADog {

  String imageUrl = "";
  String randomDog = "";
  bool disabled = false;

  void getMeADog() {
    ...
    // get a random dog's name and imageUrl
  }
}
```

#### 如何引用一个Component

由于
