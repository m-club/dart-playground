# Dart的Web应用

这个题目起的比较宽泛，Web应用又分前端/前端服务器/后端服务器，好消息是Dart是一个比较完备的语言，其语言能力可以胜任这些功能的实现，更好的是，dart sdk就提供了基础功能，并且还有可靠的前端/后台框架可以选择，也就是说可以用dart做全栈。

这一章我们不用其他框架，只用dart sdk自带的功能库，来建一个可交互的网页和一个能响应的后台。

## 前置准备

我们需要webdev工具。

``` bash
pub global activate webdev
```

我们的html页面应用都是需要浏览器(内核)来解释运行的，google没法让除了Chrome之外的浏览器都支持dart，所以dart在release时会转成功能相等的javascript的脚本。在开发调试中，为了做到随改随测，又需要在dart vm环境上操作。这些转换就需要webdev。

## 一个简单的交互页面

