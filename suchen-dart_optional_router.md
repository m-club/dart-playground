# OPTIONAL Angular中的页内路由

Angular是一种工具，用于构建你想要的页面，它可以做多页面应用，也可以做单页面应用，不过我觉得它更适合写单页面应用，实际上它也提供了后台match路径来显示不同页面的路由功能，只是它是通过添加/删除页内节点来实现的。

我来举个例子，假设我们的应用地址为：`www.m-club.com/fun/`，里面有一个数字谜的子页面，我们把它的路径定为`www.m-club.com/fun/number_mystery/`，当使用浏览器输入这个路径时，它会主动找其地址指向下的index.html文件，这就是加载了两个页面。使用Angular页内路由时，通过页内点击跳转，只是将当前页面的组件元素换成指向组件。

当页面与页面有明确的功能区别时，当然应该当作两个页面来开发，但对于Angular这种写一行hello world也可以收获一万七千多行js代码的架子（笑），需要谨慎对待其中的tradeoff。

## 添加必要库

在[pub](https://pub.dartlang.org/packages/angular_router/versions/2.0.0-alpha+17)中找到这个库，页内路由是一个单独的库，需在`pubspec.yaml`中添加依赖：
``` yaml
dependencies:            
    angular_router: ^2.0.0-alpha+19
```

## 定义路由

以目前的需求来看，router也并不是必需，完全可以通过ngSwitch来绕过，比如说在主页面增加一个变量控制switch到哪一个显示模块，并给每一个模块一个修改此变量的接口。这样一定程度上是要简单一点，但就是有点损失了代码的可读性，在语义上有损失。

定义路由分为三步：
- 为需要路由的组件添加路径配置
- 为app加一个router的引用（这个描述并不很确切）
- 在视图模版中为能路由的组件制造一块显示区域

### 增加组件路径配置

从前面的描述可以看出，页内路由是需要地址的，那么他们的路径就要有一个规则生成。Angular中提供了两种生成方式：`PathLocationStrategy`和`HashLocationStrategy`，举个例子，都是页内指向数字谜'页面'。
``` dart
// 使用PathLocationStrategy，路径为
www.m-club.com/fun/number_mystery/
// 使用HashLocationStrategy，路径为
www.m-club.com/fun/#/number_mystery
```
我比较倾向于使用`HashLocationStrategy`，虽然PathLocationStrategy的路径看起来更符合平常url，但当直接路由至自页面时，浏览器会default寻找其路径下的index.html，但我们知道它只是页内模块，当然会返回404。使用Hashtag就不会有这种歧义，在开发调试时比较方便。当然到生产环境时，比如说子页面就不应该被直接访问到，那么使用PathLocationStrategy就更为合理了。

除了选择路径生成方式，你还需要告诉Angular哪个组件对应哪个地址，这需要配置：

`route_paths.dart`
``` dart
import 'package:angular_router/angular_router.dart';
class RoutePaths {
  static final numbers = RoutePath(path: 'number_mystery');
}
```

`routes.dart`
``` dart
import 'package:angular_router/angular_router.dart';
import 'route_paths.dart';
import 'number_mystery.template.dart' as numbers_template;
// when code under lib/src it is private, then need export to be accessable
export 'route_paths.dart';
class Routes {
  static final numbers = RouteDefinition(
    routePath: RoutePaths.numbers,
    component: numbers_template.NumberMysteryNgFactory,
  );

  static final all = <RouteDefinition>[
    numbers,
  ];
}
```

`route_path.dart`就是告诉Angular数字谜的地址是什么。`routes.dart`则是告诉Angular当这个路径被选择时，应该如何来实例化这个Component。

你可能会问，里面的template.dart是什么，NgFactory又是什么。[万能的Stackoverflow](https://stackoverflow.com/questions/50317847/what-does-somecomponent-template-dart-import-in-angulardart-point-to)里面的回答就很好，我这里也再说两句。前面提到了Angular使用了自制的html语言将视图和dart逻辑绑定起来，我们在编写的时候不必管它如何实现，但其实它是需要一个factory来将它们组合起来，这个生成的template文件就包含了这块factory代码。当路由至此页面时，Angular需要知道如何实例化这个组件，所以就需要这个包含factory部分的代码，准确的说是它的NgFactory。

### 为app添加路由器

现在我们让Angular知道了哪个地址对应哪个组件，但当我们在某一组件时，想要跳转到其他页面还需要一个工具，用来唤起跳转。

这里绕不过[DI（Dependency Injection 依赖注入）](https://webdev.dartlang.org/angular/guide/dependency-injection)，它是一种设计模式，并不是两三句话讲得清楚的，可能一两篇也未必能，所以，我们这样来理解：我们在app初始的时候，创建了一个路由器，这个路由器可以被它所有的子组件所使用。

那么是如何使用的呢：

`web/main.dart`：对，就是页面入口main.dart文件
``` dart
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:your_package/app_entry.template.dart' as ng;

import 'main.template.dart' as self;

@GenerateInjector(
    // 使用PathLocationStrategy
    // routerProviders
    // 使用HashLocationStrategy
    routerProvidersHash, 
)
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
```

我可以理解这看起来一点都不human，但还是可以阅读的，里面可变的也非常少，你每回使用完全copy也是不影响开发的。

首先使用@GenerateInject生成一个特定location策略的路由器，然后找到根组件的注入器工厂，在运行整个app时，将生成的这个路由器注入到app中去。然后在其子组件的任何地方，就可以通过以下方式使用这个路由器了：

``` dart
@Component()
class WhateverNameComponent {
    // in constructor
    WhateverNameComponent(this._router);
    Router _router;

    void someFunction() {
        _router.navigate(RoutePaths.numbers.toUrl());
    }
}
```

### 这个子页面在哪儿显示的呢

点击了跳转之后，替换的组件是在哪里显示的呢？这需要在主页面上用html模版告知。

``` html
<!-- 一个实现页内路由的a元素是这样的 -->
<a  [routerLink]="RoutePaths.numbers.toUrl()">数字谜</a>
<!-- router-outlet就是插座，用于'页面'展示的地方 -->
<router-outlet [routes]="Routes.all"></router-outlet>
```

至此，你应该知道实现Angular页内路由的所有基础知识了。

## 课后练习

我当时看的时候是懵的，大概写写改改好几回才大概知道是怎么回事，所以现在轮到你们懵啦！自己写个页面跳转吧！
