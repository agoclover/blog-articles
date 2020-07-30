---
title: Homebrew常见问题
date: 2020-05-06 10:56:19
categories:
- Software
tags:
- Homebrew
- Software
---

# 安装

请按照官网的命令进行安装即可: [https://brew.sh/](https://brew.sh/)

需要注意的是，homebrew 本身安装的位置是:

```shell
/usr/local/Homebrew
```

并在 `/usr/local/bin `内创建了 homebrew 的启动程序 brew 的软连接:


```shell
# amos @ amosmbp in /usr/local/bin [7:36:03]
$ ll brew
lrwxr-xr-x  1 amos  admin    28B  1 25 23:37 brew -> /usr/local/Homebrew/bin/brew
```



# 常用命令

很多命令会打印出额外的调试和安装信息


- `$ brew --version 或 -v` 查看版本
- `$ brew install formula` 安装软件包
- `$ brew uninstall formula` 卸载某个软件包
- `$ brew update` 更新 homebrew 到最新版
- `$ brew list` 列出所有安装的软件包
- `$ brew search formula` 搜索某个软件包

更多命令请参考这篇[官方文档](http://docs.brew.sh/Manpage.html).



# 安装软件

## 非图形化软件安装

比如安装 `maven`,


```shell
$ brew install maven
```

homebrew 会将所有非图形化软件包安装到这个目录:

```shell
/usr/local/Cellar
```

然后将它们的启动程序**软链接**到 `/usr/local/bin` 这个地址:


```shell
# amos @ amosmbp in /usr/local/bin [7:50:46] C:1
$ ll mvn
lrwxr-xr-x  1 amos  admin    31B  5  4 11:16 mvn -> ../Cellar/maven/3.6.3_1/bin/mvn
```

也就是说, 通过 homebrew 已经**默认配置好了环境变量**, 不用在 `~/.zshrc` 中配置 `$MAVEN_HOME`  和 `$PATH` 了. 当然, 你仍然可以配置 `$XX_HOME` 以供其他程序依赖, 但至少 `$PATH` 不用再配置了, 每次 `echo $PATH` 不会出来那么一大堆了.

所以可以发现, 通过 homebrew 来安装软件是非常方便和简单的.

## 图形化软件安装

比如安装 `QQ`,

```shell
$ brew cask install dozer
```

homebrew 会将所有图形化软件包安装到这个目录:

```shell
/usr/local/Caskroom
```

而图形化软件并不会配置环境变量.



# 替换镜像

> 前提, homebew 本身没有走代理.

homebrew 主要由四个部分组成:

- `brew`  homebrew 源代码仓库;
- `homebrew-core`  homebrew 核心源;
- `homebrew-cask`  提供 MacOS 应用和大型二进制文件的安装
- `homebrew-bottles`  预编译二进制软件包

设置镜像时, `brew`, `homebrew/core`是必备项目, `homebrew/cask`, `homebrew/bottles`按需设置.

## 清华源

[镜像源地址](https://mirror.tuna.tsinghua.edu.cn/help/homebrew/)

```shell
git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git

# 长期替换 homebrew-bottles
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc
```

## 中科大

[镜像源地址](http://mirrors.ustc.edu.cn/help/brew.git.html)

```shell
git -C "$(brew --repo)" remote set-url origin
https://mirrors.ustc.edu.cn/brew.git

git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git

# 长期替换 homebrew-bottles
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc
```

## 腾讯源

[镜像源地址](https://mirrors.cloud.tencent.com/)

```shell
git -C "$(brew --repo)" remote set-url origin https://mirrors.cloud.tencent.com/homebrew/brew.git

git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.cloud.tencent.com/homebrew/homebrew-core.git

git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.cloud.tencent.com/homebrew/homebrew-cask.git/

# 长期替换 homebrew-bottles
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.cloud.tencent.com/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc
```

## 恢复默认源

[源地址](https://github.com/Homebrew/)

```
git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git

git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git

git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git

brew update
```

`homebrew-bottles` 配置只能手动删除, 将 `~/.zshrc` 文件中的 `HOMEBREW_BOTTLE_DOMAIN=https://mirrors.xxx.com` 内容删除, 并执行 `source ~/.zshrc` .

如果有代理的, 可以自己配置脚本设置终端代理, 这样, 终端使用命令就可以走代理了, 这里不再赘述.

但 Homebrew 本身是依赖 git 的, 所以在设置代理时一定要注意自己的 git 是否已经设置代理了, 可以通过 `/Users/amos/.gitconfig` 这个文件来查看是否设置了 git 的代理.

如果 git 已经设置了代理, 那么 Homebrew 是不需要设置镜像的, 设置了访问反而会变慢或无法访问. 如果 git 没有设置代理, 可以考虑为 Homebrew 设置镜像.



# 常用软件

## git

版本控制工具.



## tig

git 的日志记录, 请参考[这篇文章](https://www.jianshu.com/p/e4ca3030a9d5).



## **git-open**

在当前 git 仓库的目录下使用 `git-opnen` 命令可以打开远程仓库, 比如 Github, 非常有用.



## **wget**

GNU Wget 是一个在网络上进行下载的简单而强大的自由软件，其本身也是GNU计划的一部分。它的名字是“World Wide Web”和“Get”的结合，同时也隐含了软件的主要功能。当前它支持通过HTTP、HTTPS，以及FTP这三个最常见的TCP/IP协议协议下载。



## watch

watch是一个非常实用的命令，基本所有的Linux发行版都带有这个小工具，如同名字一样，watch可以帮你监测一个命令的运行结果，省得你一遍遍的手动运行。在Linux下，watch是周期性的执行下个程序，并全屏显示执行结果。你可以拿他来监测你想要的一切命令的结果变化，比如 tail 一个 log 文件，ls 监测某个文件的大小变化. 更多查看[这篇文章](https://www.cnblogs.com/peida/archive/2012/12/31/2840241.html).



## tmux

命令行的典型使用方式是，打开一个终端窗口（terminal window，以下简称"窗口"），在里面输入命令。**用户与计算机的这种临时的交互，称为一次"会话"（session）** 。

会话的一个重要特点是，窗口与其中启动的进程是连在一起的。打开窗口，会话开始；关闭窗口，会话结束，会话内部的进程也会随之终止，不管有没有运行完。

一个典型的例子就是，SSH 登录远程计算机，打开一个远程窗口执行命令。这时，网络突然断线，再次登录的时候，是找不回上一次执行的命令的。因为上一次 SSH 会话已经终止了，里面的进程也随之消失了。

为了解决这个问题，会话与窗口可以"解绑"：窗口关闭时，会话并不终止，而是继续运行，等到以后需要的时候，再让会话"绑定"其他窗口。

更多请查看[这篇文章](https://www.ruanyifeng.com/blog/2019/10/tmux.html).



# 常用 cask

## cakebrew

homebrew 软件图形化管理工具.



## dozer

状态栏整理工具.



## aerial

4K 屏保.
