# Angular常用操作

个人对事物的认识方式都很不一样，我倾向于先体验一下是怎么回事，再来看原理，之后再体验，这个loop重复个几回，对这个事物就能有个可用的认识了。

所以这一篇我来总结一下Angular中的基础功能，知道这些之后，即使你对Angular还是一头雾水，也可以写出一个可用的交互页面啦。我们先把Angular运作起来，再对照着文档来理解它们的设计概念，以及构架原理。

这一篇是基于[官方文档 CheatSheet](https://webdev.dartlang.org/angular/cheatsheet)一章，并举了一些例子。

## html中的模版语法

一开始我认为是编写html应用时选择了Angular，所以Angular中使用html作为它的视图结构是必然，后来发现是angular使用一定规则生成了一个标准的html+css+js形式，而在开发中使用html只是Angular的一个选择。

实际上，在Angular中当作模版使用的html也并不是标准的html，直接拿到浏览器上是要报错的，但它们之间的这种差别也没有那么大。html中的大多数元素都可以在Angular中使用，但也不是全部，例如`<script>`，由于安全原因，这在angular模版中是被禁止的。

所以可以说，在angular中使用的html是一个有增有减的特制版本，在这种定制化的html语言中，我们可以用特定的关键字/语法格式来将数据和视图绑定起来。

### 插值 Interpolation {{…}}

用双大括号包裹起来的部分，会插入这部分的计算值，可以是一个变量名称，也可以是一个表达式。使用位置可以是元素的text，也可以是属性的值。
``` dart
@Component(
  ...
  template: ''' 
  <div>{{fromInterpolation}}</div>
  <img src="{{fromInterpolationUrl}}">
  <p>The sum of 1 + 1 is not {{1 + 1 + getVal()}}</p>
  ''',
)
class SyntaxPlay {
  String fromInterpolation = "Interpolation from code side";
  String fromInterpolationUrl = "assets/iceburg.png";
  num getVal() { return 3.14; }
}
```
显示出来就是：

![interpolation](src_5_interpolation.png)

### 绑定 Bind-In [...] bind-

方括号内是这个元素的某个属性，等号之后是赋值的表达式，以下这两种写法，效果是等同的：

``` html
<p [style.font-size.px]="mySize">Sized Word</p>
<p bind-style.font-size.px="mySize">Sized Word</p>
```
运行时，bind的属性会接收mySize中的值，赋予style.font-size.px，效果如图。

![bind-in](src_5_bind_in.gif)

### 绑定 On-Action (...) on-

小括号内是接收的属性/响应类型，等号之后就是处理它的函数，以下两种写法，效果是等同的：

``` html
<button (click)="doSomething()">Save</button>
<button on-click="doSomething()">Save</button>
```

### Angular中的主要指令 NgIf NgFor NgSwitch NgClass

使用这些指令前，需要在component的directives中声明。

``` dart
@Component(
    ...
    directives: [NgIf, NgFor, NgSwitch, NgClass]
)
```

`NgIf`之后跟着一个返回布尔值的表达式，用于决定是否在当前页面保留这个元素。当值为`false`时，会从dom tree中移除这个元素，这和hidden是不一样的。使用时需要在之前加一个星号。

``` html
<p *ngIf="randomBool()">我是薛定谔的段落</p>
```

`NgFor`之后会跟着一个固定格式的句子，用来遍历一个集合，并将集合中的每一个元素用于增加一个相应的视图元素。使用时需要在之前加一个星号。

``` html
<div>姜汁撞奶的做法</div>
    <ol>
      <li *ngFor="let step of steps">{{step}}</li>
    </ol>
</div>
```
``` dart
// 在定义此component的dart文件中有一个名为steps的可遍历的变量
List<String> steps = [...];
```
![ngfor](src_5_ngfor.png)

`NgSwitch`