---
title: Linux家目录,sudo,用户切换
date: 2020-05-03 11:20:45
categories: 
- Linux
tags: 
- Shell
---

# 家目录与根目录

`~` 代表是 `home` 目录, 也就是家目录,  `/` 代表的是根目录. 

**用户登录后默认在 `家` 目录**, 可用 `pwd` 命令查看, 普通用户为 `/home/用户名`, 比如我的服务器有一个用户叫 `git`, 那么登录或 SSH 登录后默认目录为:

```shell
[git@VM_0_14_centos ~]$ pwd
/home/git
```

它的上一层是 `/home` 这个目录, 再上一层才是根目录 `/`. 这个时候 git 用户其实是可以访问根目录 `/` 的, 但其权限毕竟有限, 你想让它访问 `/root` 就会提示权限不够. 

而 `root` 用户为 `/root`, 比如用 `root` 用户登录:

```shell
[root@VM_0_14_centos ~]# pwd
/root
```

它的上一级就直接是 `/`. 当然, root 用户自然可以读写普通用户, 比如 git 用户.

而 mac 是类 unix 系统, 系统目录其实和 linux 差不多, mac 登录终端默认也是家目录:

```zsh
# amos @ zhangchaodembp in ~/.ssh [20:09:08]
$ pwd
/Users/amos/.ssh
```

但是, 可以发现, mac 上的家目录用的是 `/Users`, 而不是 `/home`. 我们平常使用的用户其实是一个权限比较大的普通用户. 但不是 root 用户, 默认情况下, root 用户处于停用状态. 苹果也不建议使用 root 用户来更改计算机的文件, 而是建议使用 sudo 命令获取更高的权限: "与启用 root 用户相比, 在 "终端" 中使用 `sudo` 命令更为安全. " 可以在[这篇文章](https://support.apple.com/zh-cn/HT204012)中了解更多关于 mac 的 root 权限启用.

这里顺便说一下 `sudo`, 要了解 `sudo`, 请打开“终端”应用, 然后输入 `man sudo`. `sudo ` 是 `superuser do` 的简写, `sudo` 是 `linux` 系统管理指令, 是允许系统管理员让普通用户执行一些或者全部的 `root` 命令的一个工具, 如`halt`, `reboot`, `su` 等等。 这样不仅减少了root用户的登陆和管理时间，同样也提高了安全性。



# 为普通用户添加 sudo 权限

在使用Linux系统过程中, 通常情况下, 我们都会使用普通用户进行日常操作, 而 root 用户只有在权限分配及系统设置时才会使用, 而 root 用户的密码也不可能公开. 普通用户执行到系统程序时, 需要临时提升权限, `sudo` 就是我们常用的命令, 仅需要输入当前用户密码, 便可以完成权限的临时提升. 但普通用户默认是不能使用 `sudo` 命令的, 在使用 `sudo` 命令的过程中, 我们经常会遇到当前用户不在 `sudoers` 文件中的提示信息, 需要 root 用户修改系统配置从而给予权限.

首先需要切换至 root 用户, 查看 `/etc/sudoers` 文件权限, 如果只读权限, 修改为可写权限:

```shell
[root@hadoop etc]# ll sudoers
-r--r-----. 1 root root 4328 8月   6 2019 sudoers
[root@hadoop etc]# chmod 777 /etc/sudoers
[root@hadoop etc]# ll sudoers
-rwxrwxrwx. 1 root root 4328 8月   6 2019 sudoers
```

执行 `vim` 命令, 编辑 `/etc/sudoers` 文件, 添加要提升权限的用户. 在文件中找到 `root ALL=(ALL) ALL` , 在该行下添加提升权限的用户信息, 如:

```shell
root    ALL=(ALL)       ALL
user    ALL=(ALL)       ALL
```

说明: 格式为 (用户名  网络中的主机= (执行命令的目标用户)  执行的命令范围)

保存退出, 并恢复 `/etc/sudoers` 的访问权限为 `440`:

```shell
[root@hadoop etc]# chmod 440 /etc/sudoers
[root@hadoop etc]# ll sudoers
-r--r-----. 1 root root 4347 5月   7 18:45 sudoers
```

切换到普通用户, 测试用户权限提升功能.



# 用户切换

在 linux 系统切换用户也很常见, 如果我们通过 ssh 登录, 那么切换用户再 logout 再重新登录, 或者再打开一个新的 ssh 连接, 难免有点麻烦. 这个时候就可以使用 `su` 这个命令.

这里有一点需要注意, `su` 和 `su -` 的区别:

不带 `-` 的 `su` 不会读取目标用户的环境配置文件, 带 `-` 的su才会读. `su` 只是切换了 root 身份, 但 shell 环境仍然是普通用户的 shell; 而后者连用户和 shell 环境一起切换成 root 身份了. 只有切换了 shell 环境才不会出现 PATH 环境变量错误. `su` 切换成 root 用户以后,` pwd` 一下, 发现工作目录仍然是普通用户的工作目录; 而用 `su -` 命令切换以后, 工作目录变成 `root` 的工作目录了. 用 `echo $PATH` 命令看一下 `su` 和 `su -` 以后的环境变量有何不同. 以此类推，要从当前用户切换到其它用户也一样, 应该使用 `su -`命令:

从 root 切换至 git 用户, 应该用:

```shell
[root@VM_0_14_centos ~]# su - git
Last login: Sat May  2 20:32:19 CST 2020 on pts/2
Last failed login: Sat May  2 20:32:50 CST 2020 on pts/2
There was 1 failed login attempt since the last successful login.
[git@VM_0_14_centos ~]$ pwd
/home/git
[git@VM_0_14_centos ~]$ echo $PATH
/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/git/.local/bin:/home/git/bin
```

从 git 直接切换至 root 用户用 `su` 命令:

```shell
[git@VM_0_14_centos ~]$ su
Password:
[root@VM_0_14_centos git]# pwd
/home/git
[root@VM_0_14_centos git]# echo $PATH
/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/git/.local/bin:/home/git/bin
```

可以发现, shell 环境和环境变量都没有改变, 默认位置也还是未执行命令前的位置. 而通过 `su -` 这个命令就可以连同 shell 环境和环境变量都切换到 root 用户:

```
[git@VM_0_14_centos ~]$ su -
Password:
Last login: Sat May  2 20:34:49 CST 2020 on pts/2
[root@VM_0_14_centos ~]# pwd
/root
[root@VM_0_14_centos ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
```

这个时候 `logout` 会回到原来的 git 用户:

```shell
[root@VM_0_14_centos ~]# logout
[git@VM_0_14_centos ~]$
```

这里还要注意, 通过 SSH 连接服务器, 切换用户后, 建议使用 `logout` 或 `exit` 来退出当前用户回到上一层用户, 而不是再使用 `su` 命令切换回去, 这样相当于再登录了另一个账户, 相当于套娃, 要退出就要一直 `logout` 或 `exit`.