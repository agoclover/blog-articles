---
title: log4j configuration
date: 2020-07-02 20:19:36
categories:
- Java
tags:
- Maven
---

# log4j

log4j 是 apache 的一个开源项目, 通过 log4j, 可以控制日志信息输送的目的地是 console, file, GUI 组件, 甚至是套接口服务器, NT 的时间记录器等; 也可以控制每一条日志的输出格式; 还可以通过定义每一条日志信息的级别, 更加细致地控制日志生成发的过程. 

这些都可以通过一个配置文件来灵活地进行配置, 而不需要修改应用的代码.

具体来说, 比如:

- 日志监控打印, 在项目试运行期间需要记录用户所有的操作;
- 添加新的内容, 比如时间和线程;
- 程序调试期间,记录运行的步骤和运行行;
- 成功上线稳定运行后, 不再需要打印了;
- 多个日志的输出源, 比如到数据库, idea console, 或者日志文件到 linux 服务器下.



# Maven dependency

log4j 只需要引入一个 jar 包即可:

```xml
<dependency>
 <groupId>log4j</groupId>
 <artifactId>log4j</artifactId>
 <version>1.2.17</version>
</dependency>
```



# Logging

在代码中, 我们通常如下创建 Logger 实例:

```java
package com.amos.log;

import org.apache.log4j.Logger;
import org.slf4j.LoggerFactory;

public class User{
    private static final Logger logger = Logger.getLogger(User.class); // log4j
    // private Logger logger = LoggerFactory.getLogger(this.getClass()); // slf4j
    
    public static void main(String[] args){
        logger.debug("hello, this is a piece of DEBUG information.");
        logger.info("hello, this is a piece of INFO information.");
        logger.warn("hello, this is a piece of WARN information.");
        logger.error("hello, this is a piece of ERROR information.");
    }
}
```



# Configuration

配置 log4j 需要在 Maven 工程的 `src/main/resources` 目录下创建 `log4j.properties` 或 `log4j.xml` 文件. 

配置一个完整的 `log4j.properties` 文件包括四个部分:

- Appender
- Layout
- Logger
- Level



## Level

首先介绍日志的级别. log4j 有如下级别 OFF, FATAL, ERROR, WARN, INFO, DEBUG, ALL. 但 log4j 建议只使用四个级别, 分别是 debug, info, warn, error.

这四个级别等级为 debug < info < warn < error, 假如你选择的级别是 info, 那么会打印出大于等于 info 级别的全部标注日志.



## Appender

常见的 Appender 有以下这些, 其中前三个比较常用:

```text
org.apache.log4j.ConsoleAppender // 控制台
org.apache.log4j.FileAppender // 文件
org.apache.log4j.DailyRollingFileAppender // 每天产生一个文件日志
org.apache.log4j.RollingFileAppender // 文件大小到达指定尺寸的时候产生一个新的文件
org.apache.log4j.WriterAppender // 将日志信息以流格式发送到任意指定的地方
org.apache.log4j.jdbc.JDBCAppender // 把日志用 JDBC 记录到数据库中
```



## Layout

布局就是指日志输出的格式, 常见的 Layout 有如下几种, 其中第二种使用比较多, 因为是我们自定义:

```
org.apache.log4j.HTMLLayout // 以 HTML 表格形式布局
org.apache.log4j.PatternLayout // 可以灵活地指定布局模式
org.apache.log4j.SimpleLayout // 包含日志信息的级别和信息字符串
org.apache.log4j.TTCCLayout // 包含日志产生的时间, 线程, 类别等等信息
```

常用的 PatternLayout 如下:

```text
%m	// 输出代码中指定的消息
%p	// 输出的 priority, 即 DEBUG, INFO, WARN, ERROR, FATAL
$r	// 输出自应用启动到输出该 log 信息耗费的毫秒数
%C	// 输出所属的类目, 通常就是所在类的全类名
%t	// 输出产生日志的线程名
%n	// 输出一个回车符, Unix 平台为 "\n", Windows 平台为 "\r\n"
%d	// 输出日志时间点的日期或时间, 默认格式为 ISO8601, 也可以在其后指定格式.
	// 比如 %d{yyyy-MM-dd HH:mm:ss,SSS}, 输出类似: 2020-01-01 12:00:00,123
```



## Logger

log4j 中有两个 Logger 概念, 一个是为了在代码中嵌入打印代码而定义的一个 `Logger logger` 的实例, 调用 `logger.debug("xxx")` 等方法来打印日志. 另一个就是我们在配置 log4j 时配置的 Logger 项, 通常会有一个 `RootLogger`, 自己也可以定义各种级别的 Logger. 具体配置方法在下面 Case 实例中会展示.



# Case

## log4j.properties

在 `log4j.properties` 中, Appender, Layout 和 Logger 三者之间的关系:

1. 每个 appender 后面必须跟随 layout, 指定自己的风格样式;
2. 每个 Logger 都可以指定一个级别, 可以同时引用多个 Appender;
3. 每个 Appender 也同时可以被多个 Logger 引用.

以下定义了三个 Logger, 一个根 Logger 和两个不同包级别的 Logger.

打印时, 会找到**最精确**的 Logger, 比如这里是 `log4j.logger.com.amos.log`, 那么其父 Logger 会接受广播, 即 `log4j.logger.com.amos` 和 `log4j.rootLogger` 也会按照自己设置的 appender 进行打印.

即**级别取精确, 输出为各自**.

```properties
# priority  :debug<info<warn<error
#you cannot specify every priority with different file for log4j 
log4j.rootLogger=debug,stdout,info,debug,warn,error 
log4j.logger.com.amos=info,stdout,info,debug,warn,error 
log4j.logger.com.amos.log=info,stdout,info,debug,warn,error 
 
#console
log4j.appender.stdout=org.apache.log4j.ConsoleAppender 
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout 
log4j.appender.stdout.layout.ConversionPattern= [%d{yyyy-MM-dd HH:mm:ss a}]:%p %l%m%n

#info log
log4j.logger.info=info
log4j.appender.info=org.apache.log4j.DailyRollingFileAppender 
log4j.appender.info.DatePattern='_'yyyy-MM-dd'.log'
log4j.appender.info.File=./src/com/hp/log/info.log
log4j.appender.info.Append=true
log4j.appender.info.Threshold=INFO
log4j.appender.info.layout=org.apache.log4j.PatternLayout 
log4j.appender.info.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss a} [Thread: %t][ Class:%c >> Method: %l ]%n%p:%m%n

#debug log
log4j.logger.debug=debug
log4j.appender.debug=org.apache.log4j.DailyRollingFileAppender 
log4j.appender.debug.DatePattern='_'yyyy-MM-dd'.log'
log4j.appender.debug.File=./src/com/hp/log/debug.log
log4j.appender.debug.Append=true
log4j.appender.debug.Threshold=DEBUG
log4j.appender.debug.layout=org.apache.log4j.PatternLayout 
log4j.appender.debug.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss a} [Thread: %t][ Class:%c >> Method: %l ]%n%p:%m%n

#warn log
log4j.logger.warn=warn
log4j.appender.warn=org.apache.log4j.DailyRollingFileAppender 
log4j.appender.warn.DatePattern='_'yyyy-MM-dd'.log'
log4j.appender.warn.File=./src/com/hp/log/warn.log
log4j.appender.warn.Append=true
log4j.appender.warn.Threshold=WARN
log4j.appender.warn.layout=org.apache.log4j.PatternLayout 
log4j.appender.warn.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss a} [Thread: %t][ Class:%c >> Method: %l ]%n%p:%m%n

#error
log4j.logger.error=error
log4j.appender.error = org.apache.log4j.DailyRollingFileAppender
log4j.appender.error.DatePattern='_'yyyy-MM-dd'.log'
log4j.appender.error.File = ./src/com/hp/log/error.log 
log4j.appender.error.Append = true
log4j.appender.error.Threshold = ERROR 
log4j.appender.error.layout = org.apache.log4j.PatternLayout
log4j.appender.error.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss a} [Thread: %t][ Class:%c >> Method: %l ]%n%p:%m%n
```



## log4j.xml

另一种配置 log4j 的方法是配置 `log4j.xml` 文件, 同样放在 Maven 工程的 `src/main/resources` 目录下, `log4j.properties` 和 `log4j.xml` 同时存在听 `.xml` 的.

`.xml` 功能更强大, 可以只打印 debug 而不打印更高级别的 info warn 和 error. 或者说, 可以选取自由的区间, 比如 `debug ~ info`使日志打印更加灵活:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE log4j: configuration SYSTEM "log4j.dtd">

<log4j:Configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
	<!-- 
		配置了一个叫 log.console 的 appender; 
		输出类型是控制台输出;
 		Layout 自定义;
		以 info~warn 的等级范围打印;
		-->
    <appender name="log.console" class="org.apache.log4j.ConsoleAppender">
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%d{HH:mm:ss, SSS} %5p (%C{1}:%M) - %M%N"/>
        </layout>
        <filter class="org.apache.log4j.varia.LevelRangeFilter">
            <param name="levelMin" value="info"/>
            <param name="levelMax" value="warn"/>
            <param name="AcceptOnMatch" value="true"/>
        </filter>
    </appender>
	
    <!-- 
  		配置了一个叫 log.file 的 appender; 
      	类型是每日滚动输出输出;
		Layout 自定义;
      	以 info~warn 的等级范围打印;
     	-->
    <appender name="log.file" class="org.apache.log4j.DailyRollingFileAppender">
        <param name="File" value="~/log/dest.log"/>
        <param name="Append" value="true"/>
        <param name="DatePattern" value="'.'yyyy-MM-dd"/>
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%d{HH:mm:ss, SSS} %5p (%C{1}:%M) - %M%N"/>
        </layout>
        <filter class="org.apache.log4j.varia.LevelRangeFilter">
            <param name="levelMin" value="info"/>
            <param name="levelMax" value="warn"/>
            <param name="AcceptOnMatch" value="true"/>
        </filter>
    </appender>
    
    <!-- 
  		配置了一个范围为 com.amos 的 logger; 
      	不向父 Logger 广播;
		打印级别 info 及以上;
      	Appender 有 log.console 和 log.file 两个;
     	-->
    <logger name="com.amos" additivity="false">
        <level value="info"/>
        <appender-ref ref="log.console"/>
        <appender-ref ref="log.file"/>
    </logger>

    <!-- 
  		配置了一个范围为 com.amos.log 的 logger; 
      	不向父 Logger 广播;
		打印级别 info 及以上;
      	Appender 有 log.console 和 log.file 两个;
     	-->
    <logger name="com.amos.log" additivity="false">
        <level value="info"/>
        <appender-ref ref="log.console"/>
        <appender-ref ref="log.file"/>
    </logger>

    <!-- 
  		配置根 logger; 
		打印级别 debug 及以上;
      	Appender 有 log.console 和 log.file 两个;
     	-->
    <root>
        <level value="debug"/>
        <appender-ref ref="log.console"/>
        <appender-ref ref="log.file"/>
    </root>

</log4j:configuration>
```

**log4j acceptonmatch**

包括选择过滤器和设置过滤条件, 可选择的过滤器包括: `LogLevelMatchFilter`, `LogLevelRangeFilter` 和 `StringMatchFilter`.

`LogLevelMatchFilter`	过滤条件包括 `LogLevelToMatch` 和 `AcceptOnMatch`, 只有当 log 信息的 `LogLevel` 值与 `LogLevelToMatch` 相同, 且 `AcceptOnMatch = true` 时才会匹配.

`LogLevelRangeFilter`	过滤条件包括 `LogLevelMin`, `LogLevelMax` 和 `AcceptOnMatch`, 只有当 log 信息的 `LogLevel` 在 `LogLevelMin`, `LogLevelMax` 之间, 同时 `AcceptOnMatch = true` 时才会匹配.

`StringMatchFilter`	过滤条件包括 `StringToMatch` 和 `AcceptOnMatch` , 只有当 log 信息的 `LogLevel` 值与 `StringToMatch` 对应的 `LogLevel` 值与相同, 且 `AcceptOnMatch = true` 时会匹配.

**log4j.additivity**

`log4j.additivity` 是子 Logger 是否继承父 Logger 的输出源 (appender)  的标志位. 具体说, 默认情况下子Logger 会继承父 Logger 的a ppender, 也就是说子 Logger 会在父 Logger 的 appender 里输出. 若是 additivity 设为 false, 则子 Logger 只会在自己的 appender 里输出, 而不会在父 Logger 的 appender 里输出.



## logger.isDebugEnabled()

我们在一些成熟框架源代码中, 经常看到如下代码:

```java
if (logger.isDebugEnabled()){
    logger.debug("debug: " + name);
}
```

为什么不直接用 `logger.debug("debug: " + name);` 呢?

这是因为在配置文件中虽然可以使用控制级别为比 debug 级别更高的级别, 而不输出 debug 信息; 但是, 这里的字符串连接操作仍然会影响执行效率; 所以如果先判断当前 logger  的级别, 如果级别不合适的话, 连这句字符串连接都可以不做.



## Summary

- 打印自身, 往后靠;

- 级别找就近, 输出找各自;

- xml 在 properties 前.



# log4j2

log4j2 和 log4j 是一个作者, 只不过 log4j2 是重新架构的一款日志组件, 他抛弃了之前 log4j 的不足, 以及吸取了优秀的 logback 的设计重新推出的一款新组件. log4j2 的社区活跃很频繁而且更新的也很快. 

## 配置文件类型

log4j 是通过一个 `.properties` 的文件作为主配置文件的, 而现在的 log4j2 则已经弃用了这种方式, 采用的是 `.xml`, `.json` 或者 `.jsn` 这种方式来做, 可能这也是技术发展的一个必然性，毕竟 `properties` 文件的可阅读性真的是有点差.

## 核心 JAR 包

log4j 只需要引入一个 jar 包即可:

```xml
<dependency>
 <groupId>log4j</groupId>
 <artifactId>log4j</artifactId>
 <version>1.2.17</version>
</dependency>
```

而 log4j2 则是需要 2 个核心:

```xml
<dependency>
 <groupId>org.apache.logging.log4j</groupId>
 <artifactId>log4j-core</artifactId>
 <version>2.5</version>
</dependency>

<dependency>
 <groupId>org.apache.logging.log4j</groupId>
 <artifactId>log4j-api</artifactId>
 <version>2.5</version>
</dependency>
```

log4j 和 log4j2 的包路径是不同的, Apache 为了区分包路径都更新了.



## Logger 调用

log4j 和 log4j2 调用都是很简单:

```
import org.apache.log4j.Logger;
private final Logger LOGGER = Logger.getLogger(Test.class.getName());
```

log4j2:

```
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
private static Logger logger = LogManager.getLogger(Test.class.getName());
```



## 配置文件方式

最关键的最大的不同，那就是配置文件的区别了, 大家具体使用的时候再根据你的情况进行配置就行了.

log4j2 例子如下:

```xml
<?xml version="1.0" encoding="UTF-8"?> 
<configuration status="error"> 
<!--  先定义所有的appender --> 
 <appenders> 
<!--   这个输出控制台的配置 --> 
  <Console name="Console" target="SYSTEM_OUT"> 
<!--    控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch） --> 
   <ThresholdFilter level="trace" onMatch="ACCEPT" onMismatch="DENY"/> 
<!--    这个都知道是输出日志的格式 --> 
   <PatternLayout pattern="%d{HH:mm:ss.SSS} %-5level %class{36} %L %M - %msg%xEx%n"/> 
  </Console> 
 
<!--   文件会打印出所有信息，这个log每次运行程序会自动清空，由append属性决定，这个也挺有用的，适合临时测试用 --> 
<!--   append为TRUE表示消息增加到指定文件中，false表示消息覆盖指定的文件内容，默认值是true --> 
  <File name="log" fileName="log/test.log" append="false"> 
   <PatternLayout pattern="%d{HH:mm:ss.SSS} %-5level %class{36} %L %M - %msg%xEx%n"/> 
  </File> 
 
<!--   添加过滤器ThresholdFilter,可以有选择的输出某个级别以上的类别 onMatch="ACCEPT" onMismatch="DENY"意思是匹配就接受,否则直接拒绝 --> 
  <File name="ERROR" fileName="logs/error.log"> 
   <ThresholdFilter level="error" onMatch="ACCEPT" onMismatch="DENY"/> 
   <PatternLayout pattern="%d{yyyy.MM.dd 'at' HH:mm:ss z} %-5level %class{36} %L %M - %msg%xEx%n"/> 
  </File> 
 
<!--   这个会打印出所有的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档 --> 
  <RollingFile name="RollingFile" fileName="logs/web.log"
      filePattern="logs/$${date:yyyy-MM}/web-%d{MM-dd-yyyy}-%i.log.gz"> 
   <PatternLayout pattern="%d{yyyy-MM-dd 'at' HH:mm:ss z} %-5level %class{36} %L %M - %msg%xEx%n"/> 
   <SizeBasedTriggeringPolicy size="2MB"/> 
  </RollingFile> 
 </appenders> 
 
<!--  然后定义logger，只有定义了logger并引入的appender，appender才会生效 --> 
 <loggers> 
<!--   建立一个默认的root的logger --> 
  <root level="trace"> 
   <appender-ref ref="RollingFile"/> 
   <appender-ref ref="Console"/> 
   <appender-ref ref="ERROR" /> 
   <appender-ref ref="log"/> 
  </root> 
 
 </loggers> 
</configuration>
```



# References

1. [CSDN - log4j的详细配置 (最省心完美配置)](https://blog.csdn.net/manmanxiaohui/article/details/79922546)
2. [Blog - og4j和Log4j2的区别](https://www.cnblogs.com/KylinBlog/p/7841217.html)
3. [CSDN - log4j与log4j2性能对比及log4j升级至log4j2方案](https://blog.csdn.net/hanchao5272/article/details/92381170)