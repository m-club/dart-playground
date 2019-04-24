# Dart Angular 整体思路

好了，现在你应该知道：

1. 如何使用代码和用户交互；
2. 如何使用代码操纵html页面；
3. 如何处理根据API文档发送/处理http req/resp；
4. plus 如何构建自己的简单http server；

既然你已了解了dart web的基础，那么你应该可以完成一个功能如同[Google Ads](https://ads.google.com/intl/en_us/home/?subid=us-en-et-g-aw-a-home-awhp_awx!o2m--ahpm-0000000014-0000000000)的网站了吧。

emmm...理论上来说，知道了1+1=2就了解了数学的本质。可是若是要推导高阶函数收敛极值所在，还是需要使用微积分公式，follow一个规则，完全明白它是如何得来如何实现的最好，但在无法完全理解的情况下，信任这种规则的结论也是必要的。

在前两篇中提到的是基础，但若是使用它们来搭建稍微复杂一点的场景就会有功能模块不好划分，页面结构复杂不好维护等问题。所以，我们需要一个框架，这里我选了**Angular**。

### Angular能做什么

在体验了一回AngularDart开发之后，我觉得Angular的意图有二，一是模块化，将各种操作划分开来，封装成一个个模块，使得代码逻辑清晰；二是减少重复性劳动代码。

但为了能让Angular知道你的意图，就需要学习/明白/遵循Angular的一些规范，这就是获得便利的代价了。

### 中文文档传送门

[AngularDart文档翻译](https://github.com/soojade/AngularDart_doc_cn)，这一篇是我觉得翻译得最好的了，需要说明的是**我们使用的版本是5.2.0，文档是4.0的翻译**，不过不影响整体理解，这里面基本就包括了官方文档中的内容。里面介绍了AngularDart中的各种特性，可以照着写，也可以当作查询用。

## dart应用文件结构惯例

一个dart应用的文件结构是有惯例的，[官方文档](https://www.dartlang.org/tools/pub/package-layout)中有详细说明，这里我写写我们用得到的。

![structure](src_4_structure.png)

dart中也有一个便利的工具叫做`stagehand`，可以帮你自动建立一个符合特定需求的文件夹结构。仅使用stagehand会列出你需要的project类型。stagehand不是开发必需的，它只是比较方便。

``` bash
# 安装stagehand
pub gloabal activate stagehand
# 使用stagehand
cd <your_work_dir>
stagehand <project type>
```

## Angular的模块化

这样说起来太空洞，我来写几个例子。在这一节里若是有不清楚的代码细节可以参考一下[中文文档](https://github.com/soojade/AngularDart_doc_cn)中的相关内容。

### 模块化组件

我们知道在html文档中一个tag就是一个元素，而html页面就是由有结构的各种元素组成，然后通过使用代码操纵各个元素来完成与用户的交互。Angular定义了一个Component的概念，就是将功能相对独立的一系列html+代码交互塞到一个tag里面去。

这里我写了一个示例[狗狗狗](http://www.imandui.com/fun/get_me_a_dog/)，用来表达一下最近都撸不到大狗的怨念。看起来这个页面里有一个button，一个提示行，一个图片展示，那么我们的入口index.html中是怎样的呢？

``` html
<!DOCTYPE html>
<html>
  <head>
    ...
  </head>
  <body>
    <get-me-a-dog>Loading...</get-me-a-dog>
  </body>
</html>
```

那些按钮提示图片交互汇成了一个tag，也就是<get-me-a-dog>，这就是Angular中的Component啦。

### 如何定义一个Component

简单来说，在使用了angular之后，为class添加@Component注解，那么在编译时就会根据参数将这个类作为一个组件。在他处用到这个component时，将它依照规则展开成html+css+dart形式。

Component是彼此独立的，它所引用的css只作用于它所指向的html文件，它类中的变量也不会与其父节点或是子节点混淆。这种封装性使得它可以如零件般随意拆卸安装，也便于维护。以下是get_me_a_dog.dart文件中的关键部分，它提供了`<get-me-a-dog>`标签中的所有内容。

``` dart get_me_a_dog.dart
// 必要包
import 'package:angular/angular.dart';
// 告知‘我是一个组件’
@Component(
    selector: 'get-me-a-dog', // 在它处引用时使用的tag名称
    templateUrl: 'structure.html', // 组件的html构成
    styleUrls: ['my_style.css'], // 组件的样式表
    providers: [], // 引用到的其他类，在DI中会说到
    directives: [] // 引用的指令，后面会提到
)
class GetMeADog {}
```

### 如何引用一个Component

刚刚那个例子是特别简单的，而实际上，一个页面会有许许多多组件构成，比如说我不仅仅想有一条狗，我还想开个动物园，那么狗找到了，可能还要找猫、狐狸、猴子、大象等等等等。每一种动物又都有一个获取的模块，那么我们的结构就得改改了。

首先我们会增加一个主页面模块，来罗列所有的模块，我们给它起名叫`main_page.dart`。

``` dart
import 'package:angular/angular.dart';
// 需要引用定义的dart文件
import 'package:react_play/src/get_a_dog/get_me_a_dog.dart';
import 'package:react_play/src/get_a_cat/get_me_a_cat.dart';
import 'package:react_play/src/get_a_fox/get_me_a_fox.dart';

@Component(
    selector: 'get-me-a-zoo',
    template: ''' 
    <get-me-a-dog></get-me-a-dog>
    <get-me-a-cat></get-me-a-cat>
    <get-me-a-fox></get-me-a-fox>
    ''',
    // 需要在component注册时，告诉angular用到了哪些组件类·
    directives: [GetMeADog, GetMeACat, GetMeAFox]
)
class GetMeAZoo {}
```

### 不光Component可以模块化

比如说在用户点击某段文字时，则会将文字的背景换成荧光黄色，以免跳行。我们可以定义这样一个名叫highlight的指令。
