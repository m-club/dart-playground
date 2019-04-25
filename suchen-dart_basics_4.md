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

这一篇先不要考虑它是如何实现的，可以先从代码的意思来看这块代码实现了个什么功能，这个功能在其他地方是怎么用的。后面会有一篇来写Angular的架构，那里面会有提到这些实现组装的问题。

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

首先我们会增加一个主页面模块，来罗列所有的模块，我们给它起名叫`main_page.dart`。这样各个功能模块里的逻辑视图就能简洁地引用到这个组件中来了，同样，这个组件也可以以同样的方式被引用在其他地方。

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
    // 需要在component注册时，告诉angular用到了哪些组件类
    // directives里面需要写这个组件的类名
    directives: [GetMeADog, GetMeACat, GetMeAFox]
)
class GetMeAZoo {}
```

### 不光Component可以模块化

比如说在用户点击某段文字时，则会将文字的背景换成荧光黄色，以免跳行。我们可以定义这样一个名叫highlight的指令。这是一个[官方文档](https://webdev.dartlang.org/angular/guide/attribute-directives)中的示例。

``` dart 
import 'dart:html';
import 'package:angular/angular.dart';
// 这里展示了另一个注解，@Directive告诉Angular这个类是一个指令
// 当tag元素中有myHighlight时，就会调用这个类
@Directive(selector: '[myHighlight]')
class HighlightDirective {

  final Element _el;
  HighlightDirective(this._el);

  @HostListener('mouseenter')
  void onMouseEnter() { _highlight('yellow'); }

  @HostListener('mouseleave')
  void onMouseLeave() { _highlight(); }

  void _highlight([String color]) {
    _el.style.backgroundColor = color;
  }
}
```
当我们在html文件中使用时，就会有[highlight示例]()这样的效果啦，那么在其他地方是如何引用的呢？首先在html结构中添加`myHighlight`属性，然后在引用这个属性的dart文件中添加引用声明。

`html文件`
``` html
<p class="subtitle" myHighlight>子夜四时歌：春歌</p>
```
`dart文件`
``` dart
import 'package:angular/angular.dart';
// 需要引用定义的dart文件
import 'package:path/to/your/directives.dart'

@Component(
    ...
    // directives里面添加定义highlight的类名
    directives: [HighlightDirective]
)
```

我以前是没写过css/js/html的，经过这两个月的各种尝试，我觉得highlight的这种功能应该也可以在css中完成，但我认为一是css的结构并不适合阅读与有条理地编写，二是css在多处引用时也许会有问题，所以我偏爱angular的这种处理模式。

### Angular的便利性

还是刚才那个highlight的例子，我们的html文件可以是如下这样，将数据hardcode进去。

``` html
<p class="subtitle" myHighlight>子夜四时歌：春歌</p>
    <p myHighlight>
        秦地罗敷女，采桑绿水边。
        素手青条上，红妆白日鲜。
        蚕饥妾欲去，五马莫留连。
    </p>

    <p class="subtitle" myHighlight>子夜四时歌：夏歌</p>
    <p myHighlight>
        镜湖三百里，菡萏发荷花。
        五月西施采，人看隘若耶。
        回舟不待月，归去越王家。
    </p>

    <p class="subtitle" myHighlight>子夜四时歌：秋歌</p>
    <p myHighlight>
        长安一片月，万户捣衣声。
        秋风吹不尽，总是玉关情。
        何日平胡虏，良人罢远征？
    </p>

    <p class="subtitle" myHighlight>子夜四时歌：冬歌</p>
    <p myHighlight>
        明朝驿使发，一夜絮征袍。
        素手抽针冷，那堪把剪刀。
        裁缝寄远道，几日到临洮？
    </p>
```

但这种重复出现的段落会trigger程序员写循环的本能，在之前写临时代码时我还真就用java生成了一部分写死的重复性html文件。根据我们第二篇，这个功能是完全可以使用dart:html库来实现的，这并不是一件令人愉快的事情，找id增加元素，添加到元素的children中去，这件事本身也是一种不大需要动脑的体力劳动。

Angular提供了一些便捷修改dom文档结构的指令，我们这里举个NgFor的例子。我们看看修改过后的html是什么样子：

``` html
<div class="wrapper" *ngFor="let poem of poems">
    <p class="subtitle" myHighlight>{{poem.title}}</p>
    <p myHighlight>{{poem.contents}}</p>
</div>
```
里面使用了ngFor，会在相应的dart文件中找一个名叫poems的List，然后遍历它的每一个元素，将每一个元素的title和contents显示出来。这里是hardcode的data，实际中大多是需要从后台拉取的数据。
``` dart
class AppEntry {
  List<Poem> poems = [
    Poem("子夜四时歌：春歌", "秦地罗敷女，采桑绿水边。素手青条上，红妆白日鲜。蚕饥妾欲去，五马莫留连。"),
    Poem("子夜四时歌：夏歌", "镜湖三百里，菡萏发荷花。五月西施采，人看隘若耶。回舟不待月，归去越王家。"),
    Poem("子夜四时歌：秋歌", "长安一片月，万户捣衣声。秋风吹不尽，总是玉关情。何日平胡虏，良人罢远征？"),
    Poem("子夜四时歌：冬歌", "明朝驿使发，一夜絮征袍。素手抽针冷，那堪把剪刀。裁缝寄远道，几日到临洮？"),
  ];
}
class Poem {
  String title;
  String contents;
  Poem(this.title, this.contents);
}
```

## 课后练习

- 试着写一个component，然后引用它
- 实现一下hightlight directive
- 使用ngFor来显示一个列表