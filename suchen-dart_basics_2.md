# Dart的Web应用 之一

这个题目起的比较宽泛，Web应用又分前端/前端服务器/后端服务器，好消息是Dart是一个比较完备的语言，其语言能力可以胜任这些功能的实现，更好的是，dart sdk就提供可以实现这些的基础功能，并且也有可靠的前端/后台框架可以选择。简言之，dart完全可以做全栈。

这一篇我们不用其他框架，只用dart sdk自带的功能库，来建一个可交互的网页和一个能响应的后台。

## 前置准备

我们需要webdev工具。

``` bash
pub global activate webdev
```

我们的html页面应用都是需要浏览器(内核)来解释运行的，google没法让除了Chrome之外的浏览器都支持dart，所以dart在release时会转成功能相等的javascript的脚本。在开发调试中，为了做到随改随见，又需要在dart vm环境上操作。这些转换就需要webdev。

## 一个简单的交互页面

首先说一下dart web app（后面简称为app）的结构，它的入口实在web文件夹下的main.dart文件中的main()函数，其指向的是web文件夹下的index.html文件。其结构如下图所示，这几个文件(夹)的名字不能更换。

![structure_image](src_2_structure.png)

那么这个app需要哪些依赖库呢，我们看一下pubspec.yaml文件。里面比前一篇中多出来dev_dependencies，这块是在开发调试时需要的依赖库，在编译release版本时是不包含进去的。里面的build_runner和build_web_compilers就是我们在调试运行时生成脚本所需要的库了。

``` yaml
name: dart_web_simple

environment:
  sdk: '>=2.1.0 <3.0.0'

dev_dependencies:
  build_runner: ^1.1.2
  build_web_compilers: ^1.0.0
```

我们的起步简单一点，页面是这样的(index.html)，其中head中的script指向的就是main.dart转成js之后的文件。结构非常简单，就是一个id为my-title的元素。

``` html
<!DOCTYPE html>
<html>
<head>
    <script defer src="main.dart.js"></script>
</head>

<body>
    <h1 id="my-title">Hello Dart Web App</h1>
</body>
</html>
```

我们来做点什么吧，比如在3s之后更改一下标题内容(main.dart)：

``` dart
import 'dart:html';

void main() {
  Future.delayed(Duration(seconds: 3), () {
    querySelector("#my-title").text = "I changed title from the code!";
  });
}
```

怎么运行呢？在pubspec.ymal所在的文件夹下，1. 使用*pub get*下载需要的依赖库，2.使用*webdev serve*命令，会在本地起一个服务，挂在8080端口，你就可以通过浏览器访问localhost:8080来访问app了。

3，2，1，标题内容就变了。这里用了dart sdk中的html库，里面的querySelector方法类似于jQurey中的选择元素，这样就可以绑定html文件中的特定元素，然后修改它们的属性了。

我觉得3s时间太长/短，我觉得标题要更风骚一些怎么办？记得刚刚使用的*webdev serve*吗，只要你不终止它，它是一直在运行的，更改代码后保存，这时应该能看到terminal下出现：看到Succeeded之后刷新浏览器就可以看到修改过后的代码运行了。

```
[INFO] Starting Build
[INFO] Updating asset graph completed, took 5ms
[INFO] Running build completed, took 221ms
[INFO] Caching finalized dependency graph completed, took 137ms
[INFO] Succeeded after 368ms with 6 outputs (4 actions)
```

## 数字谜

作为一个前端，最主要的功能就是与用户交互，我们之前的功能实在太简陋，最起码要能接收用户的输入，并根据用户的输入来动态更改页面吧。那么我们就来升级一下。

我向来觉得数字有点不可思议，它是完全抽象没有实体的东西，现在却用来表达了有实体世界的方方面面。网上有一个有趣的接口，叫做[NumbersAPI](http://numbersapi.com/#random/math)，可以告诉人们关于数字的有趣事实。但是有一个问题，它是英文的，中文不友好！幸好，现在也有许多翻译接口，比如可以免费调用的[Google翻译](https://ctrlq.org/code/19909-google-translate-api)。

[数字谜](http://www.imandui.com/fun/number_mystery/)就是这样一个简单的app，它提供一个交互，让用户输入或是点击按钮，从NumberAPI中获取数字的英文事实，再调用Google翻译将它们翻译成中文，最后展示给用户。

听起来很简单吧，里面涵盖了用户交互和网页元素修改，这两项就是web app的基石啦。

我们的index.html结构复杂了一些，但也是一目了然，head区增加了css的引用，body区添加了用户输入、按钮以及结果显示区域。

``` html
<!DOCTYPE html>
<html>
<head>
    <title>数字谜</title>
    <link rel="stylesheet" href="styles/bulma.css">
    <link rel="stylesheet" href="my_styles.css">
    <script defer src="main.dart.js"></script>
</head>

<body>
    <div class="box">
        <div class="title">输入一个你喜欢的四位数</div>
        <input id="digit-input" type="number" pattern="\d{4}"/>
        <div class="title">或者 你想掷一下骰子</div>
        <button id="btn-trivia" class="button is-info">数字琐事</button>
        <button id="btn-year" class="button is-info">世界那年</button>
        <button id="btn-day" class="button is-info">世界那天</button>
        <button id="btn-math" class="button is-info">数学事实</button>
    </div>

    <div class="result-section">
        <ul id="result-list"></ul>
    </div>

</body>
</html>
```

### dart中的html模型是什么样子的？

html文件是一个树形结构，大多数语言会把它parse成DOM树，dart也不例外。dart:html库就实现了这个功能，让每一个元素都可以应不同的规则被找到，[官方文档](https://webdev.dartlang.org/tutorials/low-level-html/connect-dart-html#about-the-dart-source-code)中也有说明。

在这个例子中只使用了ButtonElement，InputElement，LIElement，实际上dart:html中定义的element种类很多，有兴趣可以看一下源码。它们都继承自Element，若用到一些通用属性，使用这个也很方便。

每个元素也会有自己的属性，比如说在html中设置button的属性disabled为true，这个按钮就不能被点击了，dart中也提供了修改接口，这里写一个例子：

``` dart
// 找到需要的input元素
InputElement digitInput = querySelector("#digit-input");
// 将disabled属性加到元素属性中去，此时input不可点击使用
digitInput.setAttribute("disabled", "true");
// 删除disabled属性，此时input又可再次使用
digitInput.removeAttribute("disabled");
```

### 如何handle用户点击／输入事件呢？

[官方文档](https://webdev.dartlang.org/tutorials/low-level-html/add-elements#about-eventlistener-functions)是讲的最好的，这里我也简单写一下，先举一个例子。点击「世界那年」按钮会得到一个随机数字年份的描述，在main.dart中这样来接收处理。

``` dart
void main() {
  // 通过元素的id找到这个button
  ButtonElement year = querySelector("#btn-year");
  // 然后告诉这个button在被click的时候用randomYear来处理
  year.onClick.listen(randomYear);
}

// 定义callback
void randomYear(Event e) => _getNumericFact(ApiType.random_year);
```

app元素可以监听的用户事件种类很多，比如说mouse move，key down之类的有二十多个，有空的时候可以试一下，这里有一个小task：**如何使用event判断用户输入了几位数字**，可以自己试着找找如何实现。

### 如何向html中添加／删除元素

html中的父节点子节点是比较宽松的，基本上所有元素都可以添加子节点。dart:html的模型中，每个Element中是有children属性的，可以向里面添加／修改／移除某个元素，children是有顺序的，更改children的排列顺序，就可以移动它在html中的位置。

``` dart
// 找到unordered list元素
UListElement resultList = querySelector("#result-list");
// 新建一个list元素
final liElement = LIElement();
// 把这个list元素添加到unordered list中去，tada～ 这时list中就多了一行了
resultList.children.add(liElement);
```

## 课后作业

现在，你知道了如何从code中操纵html中的元素，也知道如何获得用户的输入，并且也有API的说明，那么可以试试自己写一下数字谜的网页app啦，或是有什么有趣的想法，都可以自己实现。