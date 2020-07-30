---
title: JUC-Executor Framework
date: 2020-07-17 13:48:45
categories:
- Java
tags:
- Concurrency
- JUC
---



# Executor 框架

Java 5 初次引入了Concurrency API, 并在随后的发布版本中不断优化和改进. Executor 框架简单地说是一个任务的执行和调度框架, 涉及的类如下图所示: 

![JUC-Executor-framework-1](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/JUC-Executor-framework-1.jpeg)



## Executor

其中, 最顶层是 Executor 接口, 它的定义很简单, 一个用于执行任务的 `execute` 方法, 如下所示:

```java
public interface Executor {
    void execute(Runnable command);
}
```



## Executors

这个类并不是 Executor 的实现类, 而是一个工具类, 相当于集合中的 `Collections` 工具类.

### 提供了各种类型的线程池

Executor 框架提供了各种类型的线程池, 主要有以下工厂方法:

● `public static ExecutorService newCachedThreadPool()`

本质返回 ThreadPoolExecutor.

创建一个**可缓存线程池**. 如果线程池长度超过处理需要, 可灵活回收空闲线程, 若无可回收, 则新建线程, 但是在以前构造的线程可用时将重用它们. 对于执行**很多短期异步任务的程序**而言, 这些线程池通常可提高程序性能.

- `public static ExecutorService newFixedThreadPool(int nThreads)`

本质返回 ThreadPoolExecutor.

创建一个**可重用固定线程数的线程池**, 以共享的无界队列方式来运行这些线程, 超出的线程会在队列中等待.

- `public static ExecutorService newSingleThreadExecutor()`

本质返回 ThreadPoolExecutor.

创建一个使用单个 worker 线程的 Executor, 以无界队列方式来运行该线程, 它只会用唯一的工作线程来执行任务, 保证所有任务按照指定顺序 (FIFO, LIFO, 优先级) 执行.

- `public static ScheduledExecutorService newScheduledThreadPool(int corePoolSize)`

本质返回 ScheduledThreadPoolExecutor.

创建一个定长线程池, 支持定时及周期性任务执行.

- `public static ExecutorService newWorkStealingPool(int parallelism)`

本质返回 ForkJoinPool.

会创建一个含有足够多线程的线程池, 来维持相应的并行级别, 它会通过工作窃取的方式, 使得多核的 CPU 不会闲置, 总会有活着的线程让 CPU 去运行. 所谓工作窃取, 指的是闲置的线程去处理本不属于它的任务. 每个处理器核, 都有一个队列存储着需要完成的任务. 对于多核的机器来说, 当一个核对应的任务处理完毕后, 就可以去帮助其他的核处理任务[6]. 由于能够合理的使用CPU进行对任务操作 (并行操作), 所以适合使用在很耗时的任务中.

### Runnable 适配器与 callable() 方法

将 Runnable 对象转换成 Callable 对象:

```java
static final class RunnableAdapter<T> implements Callable<T> {
    final Runnable task;
    final T result;
    RunnableAdapter(Runnable task, T result) {
        this.task = task;
        this.result = result;
    }
    public T call() {
        task.run();
        return result;
    }
}
```

可以发现, `T result` 完全与任务无关, `result` 结果返回的就是传入的值! 之后很多地方会对 Runnable 进行转换, 但其实传入的 result 只是一个笔记作用, 个人认为, 转换的作用主要是因为 **Future 任务可以取消**的特点.

借助于适配器, Executors 还提供了将 Runnable 实例等转换为 Callable 对象的方法:

```java
public static <T> Callable<T> callable(Runnable task, T result);
public static Callable<Object> callable(Runnable task);
```



## ExecutorService

ExecutorService 继承了 Executor 接口, 是一个比 Executor 使用更广泛的子类接口, 其提供了生命周期管理的方法, 以及可跟踪一个或多个异步任务执行状况返回 Future 的方法.

ExecutorService 算是 Java 中对**线程池定义的一个 API**, 在这个接口中定义了和后台任务执行相关的方法：

![image-20200720231446615](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200720231446615.png)

### 实现类

ExecutorService 的主要实现类是

- [ThreadPoolExecutor](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ThreadPoolExecutor.html) : 是一个基本的存储线程的线程池, 需要执行任务的时候就从线程池中拿一个线程来执行.
- [FolkJoinPool](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ForkJoinPool.html) : 是为了实现 "分治法" 这一思想而创建的, 通过把大任务拆分成小任务, 然后再把小任务的结果汇总起来就是最终的结果, 和MapReduce的思想很类似.
- [ScheduledThreadPoolExecutor](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ScheduledThreadPoolExecutor.html) : 支持周期性线程任务的调度.

在 Executors 工具类中也提供了创建这些类的不同参数的方法.

### 主要方法功能

**shutdown()**

- 调用后停止接收新任务, 但线程池会等待已提交的任务完成.
- 调用后会立即返回, 不会阻塞等待线程池关闭后再返回. 可以使用 `awaitTermination()` 来实现阻塞等待.

**shutdownNow() : List\<Runnable\>**

- 调用后立即返回, 不会阻塞等待.
- 调用后, 线程池会通过调用任务线程的 `interrupt()` 方法尽最大努力 (best-effort) 去 "终止" 已经运行的任务. 而对于那些阻塞队列中等待执行的任务, 线程池并不会再去执行这些任务, 而是返回这些等待执行的任务 `List<Runnable>`.
- 注意, 当调用一个线程的 `interrupt()` 方法后 (前提是 caller 线程有权限, 否则抛异常), 该线程并不一定会立马退出:
  - 如果线程处于被阻塞状态 (例如处于 sleep, wait, join等状态), 那么线程立即退出被阻塞状态, 并抛出一个 InterruptedException 异常.
  - 如果线程处于正常的工作状态, 该方法只会设置线程的一个状态变量为 `true` 而已, **线程会继续执行不受影响**. 如果想停止线程运行可以在任务中检查当前线程的状态 `Thread.isInterrupted()` 自己实现停止逻辑.

**awaitTermination(long timeOut, TimeUnit unit) : boolean**

当前线程阻塞, 直到

- 等所有已提交的任务（包括正在跑的和队列中等待的）执行完.
- 或者等超时时间到.
- 或者线程被中断，抛出 InterruptedException.

然后返回 `true` (shutdown 请求后所有任务执行完毕) 或 false (已超时).

`shuntdown()` 和 `awaitTermination()` 效果差不多, 方法执行之后, 都要等到提交的任务全部执行完才停. 区别在于:

- 执行后是否还能提交新的任务.
- 以及 `awaitTermination()` 是阻塞的返回线程池是否已经停止; `shutdown()` 不阻塞.

关闭功能**从强到弱**依次是: `shuntdownNow() > shutdown() > awaitTermination()`.

接下来看三种提交和执行任务的方法:

**execute(Runnable command)**

这个我们上面提过, 注意这里参数类型就是 Runnable, 然后对它进行异步执行.

**submit() : Future\<T\>**

提交有 3 个重载方法, `submit()` 方法会将一个 Callable 或 Runnable 任务提交给 ExecutorService 并返回 Future 类型的结果:

```java
<T> Future<T> submit(Callable<T> task);
<T> Future<T> submit(Runnable task, T result);
Future<?> submit(Runnable task);
```

`submit()` 方法主要是提交有返回值的任务, Runnable 的任务可以加结果也可以不加, 会配适配器转换成 Callable 对象执行, 所以最终均会有 Future 返回值.

**invokeAny(Collection<? extends Callable<T>> tasks, long timeout, TimeUnit unit) : \<T\> T**

`invokeAny()` 方法要求一系列的 Callable 或者实现类对象的集合. 调用这个方法并不会返回一个 Future, 但它返回其中一个 Callable 对象的结果. 无法保证返回的是哪个 Callable 的结果, 只能表明其中一个已执行结束.

如果其中一个任务执行结束(或者抛了一个异常) 或者超时, 其他 Callable 将被取消. 

**invokeAll(Collection<? extends Callable\<T\>> tasks) : \<T\> List<Future\<T\>>**

`invokeAll()` 方法参数一样, 返回 Future 对象的集合, 通过它们你可以获取每个 Callable 的执行结果. 由于一个任务可能会由于一个异常而结束, 因此它可能没有 "成功". 无法通过一个 Future 对象来告知我们是两种结束中的哪一种.

所以, 如果只想执行一个 `Runnable` 任务而且不需要返回值, 那就可以用 `execute`;

如果想执行 `Callable` 任务, 或者如果想执行一个 `Runnable` 任务并用一个标记结果来看是否完成, 或者如果想执行一个可以主动取消的任务, 那么可以考虑 `submit`.



## 其他相关接口和实现类

![Thread](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/Thread.jpg)

### Runnable

```java
package java.lang;

@FunctionalInterface
public interface Runnable {
    public abstract void run();
}
```

`Runnable` 接口是为了创建新的线程任务的, Thread 类就实现了这个接口. 最简单的创建线程的办法就是创建 Thread 类的子类并重写其 `run()` 方法. 但是我们知道, 类的继承一般意味着功能的修改或强化, 如果我们的一个任务仅仅只需要重写 `run()` 方法, 而并不需要改变 `Thread` 类中的其他方法, 就没必要去特意继承.

同时, 由于 Java 的单继承原则, 应该把更重要的类之间的关系留给继承. 如果我们通过实现 `Runnable` 接口就可以拥有线程创建的能力, 就不用占用唯一的继承名额了. 因此, 其实更多情况下是通过实现 `Runnable` 接口来创建线程的.

通过继承 `Thread` 类或实现 `Runnable` 接口来创建一个线程, 但这两种通过 `overrive run()` 的方法在执行完任务之后是没有返回值的.  如果我们想要得到一件事情的返回值, 又不想流程在运行期间阻塞, 那么就需要 `Callable<V>` 和 `Future<V>` 了. 从 Java 1.5 开始就引入了这两个接口, 用以异步执行任务, 并在任务执行结束之后得到一个返回值.

### Future\<V\>

 `java.util.concurrent.Future` 接口是 Java 标准 API 的一部分, `Future` 模式的实现, 可以来进行异步计算. 所含方法签名如下:

![image-20200721112446715](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200721112446715.png)

这里基本总结如下:

1. Future 主要用于有返回值的计算, 并提供了检查计算是否完成的方法;
2. `get()` 方法可以用来检索计算结果, 但在计算完成之前是阻塞的; `get()` 的重载还可以允许在一定时间内去等待获取执行结果, 如果超过这个时间, 会抛出 `TimeoutException`.
3. 提供了 `cancel()` 方法来取消计算, 并且可以检测到是正常完成 `isDone()` 还是被取消的  `isCancelled()`;
4. 如果想利用取消这个功能但又没有返回值, 可以声明为 `Future<?>` 并返回 `null`.



### RunnableFuture

`java.util.concurrent.RunnableFuture` 这个接口代码如下:

```java
public interface RunnableFuture<V> extends Runnable, Future<V> {
    void run();
}
```

实际就是让 `Future<V>` 可以创建线程了, 并且完成计算之后, 会返回计算结果.



### Callable\<V\>

```java
@FunctionalInterface
public interface Callable<V> {
    V call() throws Exception;
}
```

`Callable<V>` 和 `Runnable` 都是为了创建一个新的线程执行任务, 但 `Callable<V>` 有返回值和可以抛出受检异常异常.



### FutureTask\<V\>

`java.util.concurrent.Future` 是 `RunnableFuture` 的实现类,  是一个可取消的异步计算, 它既可以作为 `Runnable` 被线程执行, 又可以作为 `Future` 得到 `Callable` 的返回值. FutureTask 是 Future 接口的一个实现类.

 `run()` 用以开始计算, `cancel()` 用以取消计算, `isDone()` 用以判断是否计算结束, `isCancelled()` 用以判断在完成之前是否被取消, `get()` 以获取计算结果 (完成之前阻塞), 其重载方法制定一个最长时间, 如果到时间没有计算完成则抛出`TimeoutException` 等异常. 计算完成之后, 这个计算就不能被重启或取消了, 除非调用 `runAndReset()` 来重启.

`FutureTask` 有两个构造器:

```java
public FutureTask(Callable<V> callable) {
    if (callable == null)
        throw new NullPointerException();
    this.callable = callable;
    this.state = NEW;       // ensure visibility of callable
}

public FutureTask(Runnable runnable, V result) {
    this.callable = Executors.callable(runnable, result);
    this.state = NEW;       // ensure visibility of callable
}
```

这个 `Executors.callable()` 方法和这样设计的原因上面提到过了.



### Creating a Thread

比如, 我们可以只重写 `java.lang.Thread` 的 `run()`

```java
Thread t1 = new Thread("Method 1") {
    @Override
    public void run() {
        String res = "Method 1 for creating Thread.";
        System.out.println(res);
    }
};
t1.start();
```

`java.lang.Thread` 构造器有多种重载格式:

```java
Thread()
Thread(String name)
Thread(Runnable target)
Thread(ThreadGroup group, Runnable target)
```

另一种创建线程的方式是在 `java.lang.Thread`  的构造器中传入 `Runnable` 的实现类的实例:

```java
Thread t2 = new Thread(new Runnable() {
    @Override
    public void run() {
        String res = "Method 2 for creating Thread.";
        System.out.println(res);
    }
});
t2.setName("Method 2");
t2.start();
```

如果涉及到**返回值**或者想**取消任务**, 则可以考虑 FutureTask:

```java
FutureTask<String> ft = new FutureTask<>(new Callable<String>() {
    @Override
    public String call() throws Exception {
        String res = "Method 3 for creating Thread.";
        return res;
    }
});

Thread t3 = new Thread(ft);
t3.setName("Method 3");
t3.start();
// 线程执行完，才会执行get()，所以FutureTask也可以用于闭锁
String result = ft.get();
System.out.println(result);
```

最后还可以使用 Java 的 `java.util.concurrent.Executors` 来创建各种线程池来方便地创建和管理线程:

```java
ExecutorService threadPool = Executors.newFixedThreadPool(5);
Future<String> future = threadPool.submit(new Callable<String>() {
    @Override
    public String call() throws Exception {
        String res = "Method 4 for creating Thread.";
        return res;
    }
});

threadPool.shutdown(); // 执行完开始的线程后结束, 没开始IDE线程不执行.
System.out.println(future.get());
```



# References

1. [Java的Future机制详解](https://zhuanlan.zhihu.com/p/54459770)
2. [Java中RunnableFuture接口的作用是什么？](https://www.zhihu.com/question/36498883/answer/67739043)
3. [ExecutorService shutdown()和shutdownNow()方法区别](https://juejin.im/post/5c728e2851882562691195ef)

4. [threadPoolExecutor 中的 shutdown() 、 shutdownNow() 、 awaitTermination() 的用法和区别](https://blog.csdn.net/u012168222/article/details/52790400)

5. [Java线程池Executors的使用](https://blog.csdn.net/xuemengrui12/article/details/78543543)
6. [Java 8 对线程池有哪些改进？](https://cloud.tencent.com/developer/article/1362826)
7. [Java 并发工具包-常用线程池](https://www.jianshu.com/p/8e04a1b6e2a5)

