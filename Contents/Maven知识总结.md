---
title: Maven知识总结
date: 2020-05-04 14:02:45
categories: 
- Framework
tags: 
- Maven
- Homebrew
---

# 下载与配置

## 下载

**下载方式一**

地址: [link](http://maven.apache.org/download.cgi?Preferred=https%3A%2F%2Fmirrors.tuna.tsinghua.edu.cn%2Fapache%2F), 下载 Binary zip archive 核心代码和 Source zip archive 源码.

安装到自己喜欢的位置, 然后配置**环境变量** `$MAVEN_HOME` 和 **PATH**, 不再赘述.

**下载方式二**

```bash
brew install maven
```

然后只用配置**环境变量**, PATH 会自己设置好.

安装好之后, 查看是否安装成功和安装路径:

```zsh
# amos @ amosmbp in ~/.m2 [11:30:23]
$ mvn -v
Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
Maven home: /usr/local/Cellar/maven/3.6.3_1/libexec
Java version: 1.8.0_241, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk1.8.0_241.jdk/Contents/Home/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "mac os x", version: "10.15.3", arch: "x86_64", family: "mac"
```

## 配置 maven 设置

在 `$MAVEN_HOME/conf/settings.xml`  这个文件可以设置重要参数.

### maven 仓库位置

 `/amos/.m2`, 其实默认挺好的, 所以可以把这个目录做成替身, 以便于自己访问.

maven 如果要用到一些插件或者 jar 包, 会优先到本地仓库中找, 如果本地仓库中有则直接使用, 如果本地仓库没有会自动联网下载, 下载好的东西会自动存储到本地仓库中, 后续如果再使用, 则不需要再下载.

### 镜像

默认 maven 会联网到中央仓库下载东西  https://repo.maven.apache.org/maven2, 速度比较慢.

在配置文件中, 将以下阿里云镜像设置放入 `<mirrors> </mirrors>` 中: 

```xml
<mirror>
    <id>nexus-aliyun</id>
    <mirrorOf>central</mirrorOf>
    <name>Nexus aliyun</name>
    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
</mirror>
```

### JDK

在 `<profiles> </profiles>` 中添加:

```xml
<profile>
<id>jdk-1.8</id>
<activation>
<activeByDefault>true</activeByDefault>
<jdk>1.8</jdk>
</activation>
<properties>
<maven.compiler.source>1.8</maven.compiler.source>
<maven.compiler.target>1.8</maven.compiler.target>
<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
</properties>
</profile>
```



## IDEA 配置

`preferences-build-maven`, 设置 maven 的安装目录及本地仓库

![image-20200504142025086](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200504142025086.png)



# Maven 命令

进入 Hello 项目根目录( `pom.xml` 文件所在目录)执行 `mvn compile` 命令，查看根目录变化:

```shell
mvn clean			清理: 删除以前的编译结果, 为重新编译做好准备
mvn compile			编译:	将 Java 源程序编译为字节码文件
mvn test-compile	编译测试源代码
mvn test			测试: 针对项目中的关键点进行测试, 确保项目在迭代开发过程中关键点的正确性报告. 在每一次测试后报告以标准的格式记录和展示测试结果
mvn package			打包: 将一个包含诸多文件的工程封装为一个压缩文件用于安装或部署. Java 工程对应jar包, Web工程对应 war包。
mvn install			安装: 在Maven环境下特指将打包的结果——jar 包或 war 包安装到本地仓库中。
mvn deploy			部署: 将打包的结果部署到远程仓库或将 war 包部署到服务器上运行
```



# 核心概念

## POM

Project Object Model: 项目对象模型. 将 Java 工程的相关信息封装为对象作为便于操作和管理的模型. Maven 工程的核心配置. 可以说学习 Maven 就是学习 pom.xml 文件中的配置.

## 约定的目录结构

现在 JavaEE 开发领域普遍认同一个观点: **约定>配置>编码**. 意思就是能用配置解决的问题就不编码, 能基于约定的就不进行配置. 而 Maven 正是因为指定了特定文件保存的目录才能够对我们的 Java 工程进行自动化构建.

## 坐标

使用如下三个向量在 Maven 的仓库中唯一的确定一个 Maven 工程:

- `groupId`: 公司或组织的域名倒序 + 当前项目名称

- `artifactId`: 当前项目的模块名称

- `version`: 当前模块的版本

```xml
<groupId>com.atguigu.maven</groupId>
<artifactId>Hello</artifactId>
<version>0.0.1-SNAPSHOT</version>
```

 **如何通过坐标到仓库中查找 jar 包？**

1. 将 `gav` 三个向量连起来

```java
com.atguigu.maven+Hello+0.0.1-SNAPSHOT 
```

2. 以连起来的字符串作为目录结构到仓库中查找

```java
com/atguigu/maven/Hello/0.0.1-SNAPSHOT/Hello**-**0.0.1-SNAPSHOT.jar  
```

注意：我们自己的 Maven 工程必须执行安装操作才会进入仓库, 安装的命令是: `mvn install`

## 依赖

### 依赖的范围

#### compile

- main 下的 Java 代码**可以**访问这个范围的依赖

- test 目录下的 Java 代码**可以**访问这个范围的依赖

- 部署到 Tomcat 服务器上运行时**要**放在WEB-INF的 lib 目录下

- 例如: 对 Hello 的依赖, 主程序, 测试程序和服务器运行时都需要用到

#### test

- main 目录下的 Java 代码**不能**访问这个范围的依赖

- test 目录下的 Java 代码**可以**访问这个范围的依赖

- 部署到 Tomcat 服务器上运行时**不会**放在WEB-INF的 lib 目录下

- 例如: 对junit的依赖, 仅仅是测试程序部分需要.

#### provided

- main 目录下的 Java 代码**可以**访问这个范围的依赖

- test 目录下的 Java 代码**可以**访问这个范围的依赖

- 部署到 Tomcat 服务器上运行时**不会**放在WEB-INF的 lib 目录下

- 例如: servlet-api 在服务器上运行时, Servlet 容器会提供相关 API, 所以部署的时候不需要.

#### 其他

runtime、import、system 等, 各个依赖范围的作用可以概括为下图:

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200504162438138.png" alt="image-20200504162438138" style="zoom:50%;" />

### 依赖的传递

当存在间接依赖的情况时, 主工程对间接依赖的 jar 可以访问吗? 这要看间接依赖的 jar 包引入时的依赖范围: 只有依赖范围为 `compile` 时可以访问. 

### 依赖的原则

用于解决 jar 包冲突. 但我们正常开发都会约定好 jar 包的版本的, 项目管理很严格.

1. 路径最短者优先

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200504163248900.png" alt="image-20200504163248900" style="zoom:67%;" />

2. 路径相同时先声明者优先: 这里**声明**的先后顺序指的是 dependency 标签配置的先后顺序. 

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200504163325922.png" alt="image-20200504163325922" style="zoom:67%;" />

### 依赖的排除

有的时候为了确保程序正确可以将有可能重复的间接依赖排除:

```xml
...
<dependency>
    <groupId>com.atguigu.maven</groupId>
    <artifactId>OurFriends</artifactId>
    <version>1.0-SNAPSHOT</version>
    <!--依赖排除-->
    <exclusions>
        <exclusion>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
...
```

### 统一管理目标jar包的版本

以对 Spring 的 jar 包依赖为例: Spring 的每一个版本中都包含 `spring-context`, `springmvc` 等 jar 包. 我们应该导入版本一致的 Spring jar 包, 而不是使用 4.0.0 的 `spring-context`的同时使用 4.1.1 的 `springmvc`.

```xml
<!--统一管理当前模块的jar包的版本-->
<properties>
    <spring.version>4.0.0.RELEASE</spring.version>
</properties>
...
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>${spring.version}</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>${spring.version}</version>
</dependency>
...
```



## 仓库

**分类**

包括**本地仓库**和**远程仓库**, 远程仓库又包括**私服**, **中央仓库**和中央仓库在各大洲的**镜像**.

**仓库中的文件**

- Maven的插件

- 我们自己开发的项目的模块

- 第三方框架或工具的jar包. 不管是什么样的jar包, 在仓库中都是按照坐标生成目录结构, 所以可以通过统一的方式查询或依赖.



 

## 生命周期

### Maven 的生命周期

Maven 生命周期定义了各个构建环节的执行顺序, 有了这个清单, Maven 就可以自动化的执行构建命令了. Maven 有**三套**相互独立的生命周期, 分别是: 

- Clean Lifecycle: 在进行真正的构建之前进行一些清理工作

- Default Lifecycle: 构建的核心部分, 编译, 测试, 打包, 安装, 部署等等

- Site Lifecycle: 生成项目报告, 站点, 发布站点

它们是**相互独立的**, 你可以仅仅调用 clean 来清理工作目录, 仅仅调用 site 来生成站点. 当然你也可以直接运行 **mvn clean install site** 运行所有这三套生命周期。

每套生命周期都由一组阶段 (Phase) 组成, 我们平时在命令行输入的命令总会对应于一个特定的阶段. 比如运行 `mvn clean`, 这个 clean 是 Clean 生命周期的一个阶段. 有 Clean 生命周期, 也有 clean 阶段.

### Clean 生命周期

Clean 生命周期一共包含了三个阶段:

pre-clean 执行一些需要在 clean 之前完成的工作 

clean 移除所有上一次构建生成的文件 

post-clean 执行一些需要在clean之后立刻完成的工作 

### Site 生命周期

pre-site 执行一些需要在生成站点文档之前完成的工作

site 生成项目的站点文档

post-site 执行一些需要在生成站点文档之后完成的工作, 并且为部署做准备

site-deploy 将生成的站点文档部署到特定的服务器上

这里经常用到的是 site 阶段和 site-deploy 阶段，用以生成和发布 Maven 站点, 这可是Maven 相当强大的功能, Manager 比较喜欢, 文档及统计数据自动生成, 很好看. 

### Default 生命周期

Default 生命周期是 Maven 生命周期中最重要的一个, 绝大部分工作都发生在这个生命周期中. 这里, 只解释一些比较重要和常用的阶段：

```
validate
generate-sources
process-sources
generate-resources
process-resources 复制并处理资源文件，至目标目录，准备打包。
**compile** 编译项目的源代码。
process-classes
generate-test-sources
process-test-sources
generate-test-resources
process-test-resources 复制并处理资源文件，至目标测试目录。
**test-compile** 编译测试源代码。
process-test-classes
**test** 使用合适的单元测试框架运行测试。这些测试代码不会被打包或部署。
prepare-package
**package** 接受编译好的代码，打包成可发布的格式，如JAR。
pre-integration-test
integration-test
post-integration-test
verify
**install**将包安装至本地仓库，以让其它项目依赖。
deploy将最终的包复制到远程的仓库，以让其它开发人员与项目共享或部署到服务器上运行。
```

### 生命周期与自动化构建

**运行任何一个阶段的时候, 它前面的所有阶段都会被运行**. 例如我们运行 `mvn install` 的时候, 代码会被编译, 测试, 打包. 这就是 Maven 为什么能够自动执行构建过程的各个环节的原因. 此外, Maven 的插件机制是完全依赖 Maven 的生命周期的, 因此理解生命周期至关重要.

 

## 插件和目标

- Maven 的核心仅仅定义了抽象的生命周期, 具体的任务都是交由插件完成的
- 每个插件都能实现多个功能, 每个功能就是一个插件目标
- Maven 的生命周期与插件目标相互绑定, 以完成某个具体的构建任务

例如: compile 就是插件 maven-compiler-plugin 的一个功能; pre-clean 是插件 maven-clean-plugin 的一个目标.



# 继承

## 为什么需要继承

由于非 compile 范围的依赖信息是不能在 "依赖链" 中传递的, 所以有需要的工程只能单独配置. 

例如若干模块都使用了 `junit` 作为 `test` 范围的依赖, 那么如果需要修改版本, 到各个模块中手动修改无疑是非常不可取的. 使用继承机制就可以将这样的依赖信息统一提取到父工程模块中进行统一管理.

## 创建父工程

父工程只需要保留 `pom.xml` 即可, 并且注意打包方式应设定为 `pom` :

```xml
	<groupId>com.amos.maven</groupId>
	<artifactId>Parent</artifactId>
	<version>1.0-SNAPSHOT</version>

	<!-- 父类打包方式设定为 pom -->
	<packaging>pom</packaging>

	<!-- 以下依赖被继承的还需要写, 但版本不需要写 -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>4.12</version>
                <scope>test</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!-- 以下依赖被默认继承, 不需要再写 -->
    <dependencies>
        <dependency>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
            <version>1.2.12</version>
        </dependency>
    </dependencies>
```

## 在子工程中引用父工程

如下, 此时此工程继承父工程, `junit` 是可选的, 不用写版本号, 相当于统一版本控制, 但父工程中的 `log4j` 就默认被继承到了子工程中, 所以其实子工程中这时有 3 个直接依赖.

```xml
    <parent>
        <groupId>com.atguigu.maven</groupId>
        <artifactId>Parent</artifactId>
        <version>1.0-SNAPSHOT</version>
        <relativePath>../Parent/pom.xml</relativePath>
    </parent>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>4.0.0.RELEASE</version>
            <scope>compile</scope>
        </dependency>
    </dependencies>
```



# 聚合

将多个工程拆分为模块后, 需要手动逐个安装到仓库后依赖才能够生效.

修改源码后也需要逐个手动进行 `clean` 操作, 而使用了聚合之后就可以批量进行Maven工程的安装, 清理工作.

在总的聚合工程中使用 `modules/module` 标签组合, 指定模块工程的相对路径即可:

```xml
<!--聚合-->
<modules>
    <module>../MakeFriend</module>
    <module>../OurFriends</module>
    <module>../HelloFriend</module>
    <module>../Hello</module>
</modules>
```

Maven可以根据**各个模块的继承和依赖关系自动选择安装的顺序**.



# Maven 酷站

http://mvnrepository.com/

http://search.maven.org/







