# OPTIONAL Dart中的多线程与异步

在写Aqueduct Server时，需要定时更新存储的token以供client获取。Aqueduct非常贴心地根据服务器的内核数选择了合适进程数，并行处理client来的request。于是在服务器启动之后，每一次token的更新，都执行了4回。

当然，这个问题是在写代码时就该考虑到的，在改bug之余，我也借这个机会，整理一下dart中多线程与异步的相关知识。

## Dart中的异步 async

我们先从简单的说起。

dart本身的设计是单线程的，这和javascript是一样的，在代码中常常使用的async并不会另起一个线程，使用时感到的异步，是它在消息队列中做的调整。

那么dart的消息队列是怎样的呢？

可以看到，里面有两种消息，一种是，另一种是。其中是可能占用