# Dart的Web应用 之二

上一篇只说了使用dart自带库来实现网页界面的操作，那么这一篇就来说说，如何使用dart自带库写一个非常简单的Http Server。

等等，我们不是前端吗，为何要写Server？简易的Server写起来真的就是几行代码的问题，但它可以在开发过程中为你提供一个类似的真实环境，而且明白一些后台运行的知识，也有助于今后与后台程序员交流。而且啊，现在大多数的情况，前端也是需要前端服务器的，比如说我们这个项目。

## Hello Dart Server

一个Http Server是绑在服务器(例如localhost)的某一端口的程序，它监听到来的http request，然后为这个request返回一个http response。按照程序员惯例，我们用server打个招呼。例子来自[官方文档](https://www.dartlang.org/tutorials/server/httpserver)。

``` dart
import 'dart:io';

Future main() async {
  // 绑定特定端口
  var server = await HttpServer.bind(
    // loopback即localhost或127.0.0.1
    // 这里也可以是特定IP
    InternetAddress.loopbackIPv4, 4040,
  );

  // 监听此端口上到来的request，并返回一条问候  
  await for (HttpRequest request in server) {
    request.response
      ..write('Hello from Dart Server!')
      ..close();
  }
}
```

## Guess Number

这也是[来自官方](https://www.dartlang.org/tutorials/server/httpserver#httprequest-object)的一个例子，它在后台生成一个1～10之间的数字，用户使用网页来猜。每次猜测就是发送了一个http request，后台server就会根据这个request来回应用户他们猜的对还是不对，若是猜对了则会开启一个新的随机数，下一轮猜测就开始了。

程序代码放在src_dart_basics3文件夹内，这个server和dart命令行程序一样，使用以下命令即可，html文件用浏览器打开，然后就可以猜测了。

``` bash
dart guess_server.dart
```

## 课后练习

自己搭建一个简单Server，功能随意。