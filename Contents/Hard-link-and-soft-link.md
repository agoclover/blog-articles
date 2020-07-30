---
title: Hard link and soft link
date: 2020-07-02 11:54:21
categories:
- Linux
tags:
- Linux
---



当我整理自己的笔记和资料时, 经常会将整理好的笔记推送至此博客, 在此过程中发现了一个问题, 即笔记源文件经常需要复制多份. 比如我写了 [Git commit message specification](http://zhangchao.top/2020/07/02/Git-commit-message-specification/) 这篇文章, 既需要在自己的博客仓库中存储一份用以博客推送, 又需要在另一个资料仓库中存储一份用于文件归档.

在以前, 我会将资料仓库中的文件复制一份到博客仓库中, 但这样带来了两个问题:

1. 一样的文件占了两份空间;
2. 当需要修改这个文件时, 只能每个文件都修改一遍, 效率十分低下.

其实通过硬链接就可以解决这个问题, 由于 Mac 是类 Unix 系统, 所以以下介绍 Linux 系统中的 Hard link 和 Soft link.



# Files and directories in Linux

现代操作系统为解决信息能独立于进程之外被长期存储引入了文件, 文件作为进程创建信息的逻辑单元可被多个进程并发使用. 在 UNIX 系统中, 操作系统为磁盘上的文本与图像, 鼠标与键盘等输入设备及网络交互等 I/O 操作设计了一组通用 API, 使他们被处理时均可统一使用字节流方式. 换言之, UNIX 系统中除进程之外的一切皆是文件, 而 Linux 保持了这一特性. 为了便于文件的管理, Linux 还引入了目录 (有时亦被称为文件夹) 这一概念. 目录使文件可被分类管理, 且目录的引入使 Linux 的文件系统形成一个**层级结构的目录树**. 以下所示的是普通 Linux 系统的顶层目录结构, 其中 /dev 是存放了设备相关文件的目录.

```text
/              根目录
├── bin     存放用户二进制文件
├── boot    存放内核引导配置文件
├── dev     存放设备文件
├── etc     存放系统配置文件
├── home    用户主目录
├── lib     动态共享库
├── lost+found  文件系统恢复时的恢复文件
├── media   可卸载存储介质挂载点
├── mnt     文件系统临时挂载点
├── opt     附加的应用程序包
├── proc    系统内存的映射目录，提供内核与进程信息
├── root    root 用户主目录
├── sbin    存放系统二进制文件
├── srv     存放服务相关数据
├── sys     sys 虚拟文件系统挂载点
├── tmp     存放临时文件
├── usr     存放用户应用程序
└── var     存放邮件、系统日志等变化文件
```

Linux 与其他类 UNIX 系统一样并不区分文件与目录: **目录是记录了其他文件名的文件**. 使用命令 mkdir 创建目录时, 若期望创建的目录的名称与现有的文件名 (或目录名) 重复, 则会创建失败.



# Hard link

我们知道文件都有文件名与数据, 这在 Linux 上被分成两个部分: **用户数据** (user data) 与**元数据** (metadata). 用户数据, 即文件数据块 (data block), 数据块是记录文件真实内容的地方; 而元数据则是文件的附加属性, 如文件大小, 创建时间, 所有者等信息. 在 Linux 中, 元数据中的 **inode** 号 (**inode 是文件元数据的一部分但其并不包含文件名, inode 号即索引节点号**) 才是文件的唯一标识而非文件名. 文件名仅是为了方便人们的记忆和使用, **系统或程序通过 inode 号寻找正确的文件数据块**. 下图展示了程序通过文件名获取文件内容的过程:

![image-20200702141052685](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200702141052685.png)

在 Linux 系统中查看 inode 号可使用命令 `stat`, `ls -i` 或 `ll -i` (以下为 Mac 系统下的演示):

```bash
amos ~/testln [14:13:51]
$ touch old.file

amos ~/testln [14:14:01]
$ ll -i
total 0
16348806 -rw-r--r--  1 amos  staff     0B  7  2 14:14 old.file

amos ~/testln [14:14:05]
$ stat old.file
16777221 16348806 -rw-r--r-- 1 amos staff 0 0 "Jul  2 14:14:01 2020" "Jul  2 14:14:01 2020" "Jul  2 14:14:01 2020" "Jul  2 14:14:01 2020" 4096 0 0 old.file
```

我们接下来再此文件下创建另一个文件夹并移动 `old.file` 至其中, 观察移动后的文件的 inode 是否改变:

```bash
amos ~/testln [14:14:23]
$ mkdir subdir

amos ~/testln [14:17:18]
$ mv old.file subdir

amos ~/testln [14:17:26]
$ ll -i ./subdir/
total 0
16348806 -rw-r--r--  1 amos  staff     0B  7  2 14:14 old.file
```

可以发现, 改变文件位置并不改变一个文件的 inode.

为解决文件的共享使用, Linux 系统引入了两种链接: 硬链接 (hard link) 与软链接 (又称符号链接, 即 soft link 或 symbolic link). 链接为 Linux 系统解决了文件的共享使用, 还带来了隐藏文件路径, 增加权限安全及节省存储等好处. 若一个 inode 号对应多个文件名, 则称这些文件为硬链接. 换言之, 硬链接就是同一个文件使用了多个别名. 硬链接可由命令 link 或 ln 创建. 如下是对文件 old.file 创建硬链接:

```zsh
amos ~/testln [14:21:46]
$ ln old.file new.file

amos ~/testln [14:21:59]
$ ll -i
total 0
16348806 -rw-r--r--  2 amos  staff     0B  7  2 14:14 new.file
16348806 -rw-r--r--  2 amos  staff     0B  7  2 14:14 old.file
```

可以发现他们有相同的 inode. 接着我们分别先后在 old.file 和 new.file 中写入一句话并观察另一个文件中是否有这句话:

```zsh
$ echo "words written in old file" >> old.file | cat new.file
words written in old file

$ echo "words written in new file" >> new.file | cat old.file
words written in old file
words written in new file

$ rm old.file | cat new.file
words written in old file
words written in new file
```

可以发现, 这两个文件的内容是完全一样的, 因为其 inode 一样, 文件的数据块就是一样的, 这样也就实现了**数据共享**. 同时, 我们可以尝试删除 old.file 文件, 发现 new.file 文件还完好无损, 这对我们管理需要共享的文件式非常方便的.



# Soft link

另外一种链接称之为软链接 (Soft link)，也叫符号链接 (Symbolic Link). 软链接文件类似于 Mac 系统中的替身或 Windows 的快捷方式.它实际上是一个特殊的文件. 在软链接中, 文件实际上是一个文本文件, 其中包含的有另一文件的位置信息. 

我们依然以一个 old.file 创建一个硬链接文件 new.file, 再创建一个软链接文件 soft.file:

```zsh
$ ln -s old.file soft.file

$ ll -i
total 16
16348806 -rw-r--r--  2 amos  staff    52B  7  2 14:24 new.file
16348806 -rw-r--r--  2 amos  staff    52B  7  2 14:24 old.file
16349321 lrwxr-xr-x  1 amos  staff     8B  7  2 14:34 soft.file -> old.file
```

可以发现, 软链接其实就是一个新的文件了, 它的 inode 与 old.file 是不一样的.

```zsh
$ rm old.file | cat new.file
words written in old file
words written in new file

$ cat soft.file
cat: soft.file: No such file or directory
```

接着如上, 我们删除 old.file 发现 new.file 不受影响, 但 soft.file 变成一个死链接 (dangling link, 若被指向路径文件被重新创建, 死链接可恢复为正常的软链接).

当然软链接的用户数据也可以是另一个软链接的路径, 其解析过程是递归的. 但需注意: 软链接创建时原文件的路径指向使用绝对路径较好. 使用相对路径创建的软链接被移动后该软链接文件将成为一个死链接, 因为链接数据块中记录的亦是相对路径指向.

我们可以通过下图更好理解硬链接和软连接的文件访问机制:

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200702144037012.png" alt="image-20200702144037012" style="zoom:67%;" />



# Differences

由于硬链接是有着相同 inode 号仅文件名不同的文件, 因此硬链接存在以下几点特性: 

- 文件有相同的 inode 及 data block;
- 只能对已存在的文件进行创建;
- 不能交叉文件系统进行硬链接的创建;
- 不能对目录进行创建，只可对文件创建;
- 删除一个硬链接文件并不影响其他有相同 inode 号的文件.

软链接与硬链接不同, 若文件用户数据块中存放的内容是另一文件的路径名的指向, 则该文件就是软连接. 软链接就是一个普通文件, 只是数据块内容有点特殊. 软链接有着自己的 inode 号以及用户数据块. 因此软链接的创建与使用没有类似硬链接的诸多限制:

- 软链接有自己的文件属性及权限等;
- 可对不存在的文件或目录创建软链接;
- 软链接可交叉文件系统;
- 软链接可对文件或目录创建;
- 创建软链接时，链接计数 i_nlink 不会增加;
- 删除软链接并不影响被指向的文件, 但若被指向的原文件被删除, 则相关软连接被称为死链接 (即 dangling link, 若被指向路径文件被重新创建, 死链接可恢复为正常的软链接).



# References

1. [IBM Developer - 理解 Linux 的硬链接与软链接](https://www.ibm.com/developerworks/cn/linux/l-cn-hardandsymb-links/index.html)
2. [知乎 - 硬链接与软链接有什么不同 (ln)](https://zhuanlan.zhihu.com/p/27187147)

