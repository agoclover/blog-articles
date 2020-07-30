---
title: git init和git init --bare的区别
date: 2020-05-07 18:59:45
categories:
- Git
tags:
- Git
---

在本文中我将:

1. 使用**普通库**代指用 `git init` 命令创建的 GIT 库;
2. 使用**裸库**代指用 `git init --bare xx.git` 命令创建的 GIT 库.

当你创建一个普通库时, 在工作目录下, 除了 `.git` 目录之外你还可以看到库中所包含的所有源文件. 你拥有了一个可以进行浏览和修改 (`add, commit, delete` 等) 的本地库.

当你创建一个裸库时, 在工作目录下, 只有一个 `.git` 目录, 而没有类似于本地库那样的文件结构可供你直接进行浏览和修改. 但是你仍旧可以用 `git show` 命令来进行浏览, 举个例子 (参数为某个 `commit` 的 SHA1 值):

```shell
git show 921dc435a3acd46e48e3d1e54880da62dac18fe0
```

一般来说, 一个裸库往往被创建用于作为大家一起工作的共享库, 每一个人都可以往里面 `push` 自己的本地修改. 一个惯用的命名方式是在库名后加上 `.git`, 举个例子:

```shell
mkdir example.git
cd example.git
git init --bare .
```

这样你便拥有了一个叫做 example 的共享库. 在你自己的本地机器上, 你可以用 `git remote add` 命令做初始化 `check-in`:

```shell
// assume there're some initial files you want to push to the bare repo you just created,
// which are placed under example directory
cd example
git init
git add *
git commit -m "My initial commit message"
git remote add origin git@example.com:example.git
git push -u origin master
```

项目团队里面的每个人都可以 `clone` 这个库, 然后完成本地修改之后, 往这个库中 `push` 自己的代码:

```shell
git clone git@example.com:example.git
```



**参考资料**

1. [普通库与裸库的区别](http://stackoverflow.com/questions/7861184/what-is-the-difference-between-git-init-and-git-init-bare)
2. [该如何使用一个裸库](http://stackoverflow.com/questions/7632454/how-do-you-use-git-bare-init-repository)
3. [什么是GIT裸库](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)
4. [如何设置一个远程共享库并进行团队协作](http://thelucid.com/2008/12/02/git-setting-up-a-remote-repository-and-doing-an-initial-push/)
5. [git remote add与git clone的区别](http://stackoverflow.com/questions/4855561/difference-between-git-remote-add-and-git-clone)

6. [Git 本地仓库和裸仓库](https://zhuanlan.zhihu.com/p/24151683)
