# Dart究竟是如何玩的？

我一直觉得在学习语言之前对语言是如何运行的有一个大概的了解是非常有益的，在这一篇中我就写一下dart语言的极简运行。

## 前置条件

### [安装dart sdk](https://www.dartlang.org/install)

这里会有三个，其中Flutter是针对手机端，里面除了包含dart sdk还有flutter的sdk，web与server的安装都是dart sdk。

这里提一句，flutter为何不同呢，因为flutter使用dart语言开发，但它还需要将dart语言转成可在android/ios上可使用的代码，而且还需要提供通过flutter使用android/ios系统功能的通道等等，故而会比dart sdk多出一些来。

Google是一家想要统一三界的公司(笑cry)，目前flutter可以编译成android/ios应用，之后他们似乎还有计划将flutter直接编译成web应用。android还是基于linux内核，两三年前他们就有一个新os项目叫做Fuchsia，使用自研内核，针对实时系统，UI也是使用flutter。所以如何大家有兴趣，可以看一下flutter。

### 更换国内镜像

我相信我们墙Google是有正当理由的，但不能影响我们学习他们的技术，故而各大学都提供了镜像地址。

根据系统不同，需要将以下变量添加到各自的Path中去：

```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

这样在更新依赖库的时候就不会有问题了。

### 其他

度娘还是挺可靠的，找篇教程吧～

## Hello Dart !

按照程序员惯例，第一个程序我们就来打个招呼～

``` dart
void main() {
    print("hello dart!");
}
```

dart执行入口找的是main()函数，任何位置你保存了一个dart文件，就可以在此目录下使用*dart file_name.dart*就能看到命令行运行结果了。

这里写两个传送门：

1. [dart语法](http://dart.goodev.org/guides/language/language-tour)：如果之前写java比较多的话，可以凭直觉写，不对的地方来查查样例；
2. [代码规范](http://dart.goodev.org/guides/language/effective-dart#%E5%A6%82%E4%BD%95%E9%98%85%E8%AF%BB%E6%9C%AC%E6%8C%87%E5%8D%97)：这个有空就看看，有助于帮你写出更简洁有效好维护的代码。

## 我需要许多库

现在没人从0开始写代码了，我们都需要库，需要许多许多库。不过还好，dart也提供了许多库，更有不少质量不错的框架，完全可以满足我们项目的要求。

### 如何添加一个库

dart的依赖库管理是使用pub，要类比的话就像是android中的gradle。

当你需要某种功能时，首先到[pub网站](https://pub.flutter-io.cn/web)，找一下。这里我们以[http](https://pub.flutter-io.cn/packages/http)这个库为例，我们项目中会需要它来处理发送接受http request。

承接hello dart那一节，此时我们仅有hello.dart这一个文件，因为我们不需要任何外部库，现在我们得增加一点东西来让dart知道我需要http这个库，并且能正确引用它。

1. 在目录下增加一个pubspec.yaml文件，这个文件就是用来告诉dart用了哪些库，都是什么版本；
``` yaml
name: hello_dart
environment:
  sdk: '>=2.1.0 <3.0.0'

dependencies:
  http: ^0.12.0+2
```
2. 在pubspec.yaml所在目录下使用命令*pub get*，这时dart就会到PUB_HOSTED_URL定义地址去下载库，完成后，在文件中就可以引用http这个库啦。这时文件夹下会生成一个pubspec.lock，我想它是用来存储当前依赖库版本，以做对照；
3. 使用http库来完成一次http request：
``` dart
import 'package:http/http.dart' as http;

void main() async {
    //print("hello dart!");
    final url = "http://www.imandui.com/example";
    final response = await http.get(url);
    print(response.body);
}
```

## 课后练习

现在你应该知道如何使用dart，如何自己实验啦。那么根据项目的需求，你可能需要知道如下功能如何写：

刚刚使用的是http request的get方法，实际项目中，我们会使用post方法，将参数用json格式传给后台，并等待一个json格式的回复，那么：

1. 如何使用post方法
2. 如何正确写request body
3. 如何将回复的内容decode成json格式，并根据这个来实例
4. 若是回复代码不是200/超时/数据格式不符合规范如何处理异常

这些问题是应该考虑的～

之后我会在后台起一个service当作我们的练习场地。
