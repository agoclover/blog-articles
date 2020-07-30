---
title: SSH登录认证简析
date: 2020-05-02 23:55:00
categories: 
- Computer Network
tags:
- SSH
- Git
---

# 公钥与私钥

公钥 (Public Key) 与私钥 (Private Key) 是通过一种算法得到的一个密钥对 (即一个公钥和一个私钥), 公钥是密钥对中公开的部分, 私钥则是非公开的部分. 公钥通常用于加密会话密钥, 验证数字签名, 或加密可以用相应的私钥解密的数据. 通过这种算法得到的密钥对能保证在世界范围内是独一的. 使用这个密钥对的时候, 如果用其中一个密钥加密一段数据, 必须用另一个密钥解密. 比如用公钥加密数据就必须用私钥解密, 如果用私钥加密也必须用公钥解密, 否则解密将不会成功.

通过[这篇文章](https://zhuanlan.zhihu.com/p/31477508)也可以很好地理解公钥与私钥. 还可以理解, 公钥是你家的地址, 私钥是你家的钥匙, 地址是公开的, 大家都可以知道, 但钥匙最后一把, 只有你自己才能打开方子.

**公钥和私钥到底哪个才是用来加密和哪个用来解密？**

一般来说, 既然是加密, 那肯定是不希望别人知道我的消息, 所以只有我才能解密, 所以可得出**公钥负责加密, 私钥负责解密**; 同理, 既然是签名, 那肯定是不希望有人冒充我发消息, 只有我才能发布这个签名, 所以可得出**私钥负责签名, 公钥负责验证**.



# RSA

[RSA](https://zh.wikipedia.org/wiki/RSA%E5%8A%A0%E5%AF%86%E6%BC%94%E7%AE%97%E6%B3%95) 加密算法是一种非对称加密算法, 在公开密钥加密和电子商业中被广泛使用. RSA是由罗纳德·李维斯特 (Ron Rivest), 阿迪·萨莫尔 (Adi Shamir) 和伦纳德·阿德曼 (Leonard Adleman) 在1977年一起提出的. 当时他们三人都在麻省理工学院工作. RSA 就是他们三人姓氏开头字母拼在一起组成的.

对**极大整数做因数分解的难度**决定了 RSA 算法的可靠性, 换言之, 对一极大整数做因数分解愈困难, RSA 算法愈可靠. 假如有人找到一种快速因数分解的算法的话, 那么用 RSA 加密的信息的可靠性就会极度下降. 但找到这样的算法的可能性是非常小的. 今天只有短的 RSA 钥匙才可能被强力方式破解. 到当前为止, 世界上还没有任何可靠的攻击 RSA 算法的方式. 只要其钥匙的长度足够长, 用RSA加密的信息实际上是不能被破解的. 



# SSH 认证登录的过程和原理

包含四个阶段:

1. 协议协商阶段
2. 服务端认证
3. 客户端验证
4. 数据传输

## 协议协商阶段

服务端监听端口 22, 客户端通过 TCP 三次握手与服务器的 SSH 端口建立TCP连接.

服务器通过建立好的连接向客户端发送一个包含 SSH 版本信息的报文, 格式为`SSH-<SSH协议大版本号>.<SSH协议小版本号>-<软件版本号>` , 软件版本号主要用于调试.

客户端收到版本号信息后, 如果服务器使用的协议版本号低于自己的, 但是客户端能够兼容这个低版本的 SSH 协议, 则就使用这个版本进行通信. 否则, 客户端会使用自己的版本号.

客户端将自己决定使用的版本号发给服务器, 服务器判断客户端使用的版本号自己是否支持, 从而决定是否能够继续完成 SSH 连接, 可以则协商成功, 否则失败断开连接. 如果协商成功, 则进入密钥和算法协商阶段.



## 服务端认证

协商成功后，服务端明文发送:

- `Host Public Key`. 或者简写为 `Host Key`, SSH 安装后 `Host Private Key` 在 `/etc/ssh/ssh_host_rsa_key`, `Host Public Key` 在  `/etc/ssh/ssh_host_rsa_key.pub`
- `Server Key`. 是 SSH-1版本中使用的临时非对称密钥, 每隔一定时间 (默认一小时) 都会在服务端重新生成, 用于对会话密钥 `Session Key` 加密, SSH-2 对 Server Key 进行了加强.
- 一个 8Bytes 的**随机数检测字节**,  防止IP地址欺诈.
- 服务端支持的**加密算法**.
- 压缩方式.
- 认证方式.

客户端收到后, 查询该用户的 `~/.ssh/` 下的 `known_hosts` 是否存在对应服务端 IP 和机器名的 Host Key, 若不存在交由用户判断是否信任该服务端. 

问题就在于**如何对服务器的 Host key 进行认证？** 在 https 中可以通过 CA 来进行公证, 可是 SSH 的 host key 和 host private key 都是自己生成的, 没法公证. 只能通过客户端自己对 Host key 进行确认. 通常在第一次登录的时候, 系统会出现下面提示信息:

```shell
The authenticity of host 'ssh-server.example.com (12.18.429.21)' can't be established.
RSA key fingerprint is 98:2e:d7:e0:de:9f:ac:67:28:c2:42:2d:37:16:58:4d.
Are you sure you want to continue connecting (yes/no)? 
```

之所以用 fingerprint 代替 Host key，主要是 Host key过于长 ( RSA 算法生成的公钥有1024位), 很难直接比较. 所以, 对公钥进行 hash 生成一个 128 位的指纹, 这样就方便比较了. 如果输入 `yes` 后, 会出现下面信息:

```shell
Warning: Permanently added 'ssh-server.example.com,12.18.429.21' (RSA) to the list of known hosts. 
Password: (enter password) 
```

该 Host key 已被确认, 并被追加到文件 known_hosts 中.

服务端的身份验证成功之后, 双方用服务端发来的参数和 Diffie-Hellman 算法生成 `Session Key`. `Session Key` 是**会话密钥, 是随机生成的对称密钥, 用于之后通讯时对消息进行加密解密, 会话结束时被销毁**. 这个 `Session Key` 的机制被称作对称加密 (Symmetric Encryption), 也就是两端使用的相同的 `Session key` 来加密和解密信息. 可以看出 SSH 信息的加密解密时并不是用大家自己生成的 Public/ Private Key, 而是用双方都一致的 `Session Key`. 生成 `Session Key` 的步骤大致如下：

1. 客户端和服务端使用**沟通时的信息**, 协商**加密算法**以及一个**双方都知道的数字**.
2. **双方各自生成只有自己才知道的 private 密码**, 并使用上一步中的数字进行加密, 再次生成密码. 
3. 双方交换再次加密后的密码. 
4. 双方在对方发来的密码基础上, 加上第二步自己的 private 密码再次加密. 本次加密之后得到的结果就是在双方处都相同的 `Session Key`.

从这个算法中, 可以看出客户端和服务端没有直接传输自己在第二步生成的密码, 而是通过**加密互换再加密**的方式来生成 `Session Key`, 从而保障了 `Session Key` 无法被泄露.

双方根据协商的加密算法 (例如 MD5, 这里可能就是 MD5 ) 将 Host Key, Server Key 和检测字节生成一个 128 位 ( 16 字节) 的 MD5 值作为会话 ID (Session ID). 这里也有说服务器生成 Session ID 发给客户端的, 本质一样. 



## 客户端验证

客户端验证有多种验证方式, 常用的包括**密码验证**和**密钥验证**. 服务端配置了密钥验证方式后 (默认是开启) 优先使用密钥方式登录. 

### 密码验证

客户端使用 `Session Key` 对 用户名和密码加密, 发给服务端, 服务端使用 `Session Key` 解密后验证是否合法. 有说, 客户端使用上一步服务端发送的 `Server Key/Host Key` 对用户和密码加密, 然后发给服务端, 服务端使用私钥解密, 这个描述不太正确, 感觉更容易被攻击.

### 密钥验证

客户端需要事先将自己的公钥存放到服务端. 可用 `ssh-keygen` 生成, 在 `/.ssh/id_rsa.pub` 下.

然后通过以下命令, 将公钥追加到要登陆用户的家目录中的 `/.ssh/authorized_keys` 文件中, 这里 user 如果是 root, 则在 `/root/,ssh/authorized_keys` 下, 如果是普通用户, 则是 `/home/user/.ssh/authorized_keys`:

```shell
$ ssh-copy-id user@host
```

那么在之后的连接中, 客户端若生成了公钥和私钥, 则发送公钥认证 (Public Key) 请求, 发送用 `Session Key` 加密的包含公钥的模作为标识符 (KeyID) 的信息, 服务端接收到客户端的连接请求后, 用 `Session Key` 解密拿到公钥的Key ID 从 `authorized_keys` 文件中找到匹配的对应该客户端的公钥, 若找不到则失败, 客户端则可继续采取密码登陆. 若找到, 服务端生成一个 256 位 ( 32 字节) 随机数 R, 并用该公钥加密, 最后使用 `Session Key` 加密后发送给客户端.

客户端收到后先用 `Session Key` 和自己的私钥解密, 得到随机数R, 然后将随机数和 Session ID 结合 (防止攻击者重放攻击, replay attack) 生成一个 MD5 值同时用 `Session Key` 加密发给服务端. 服务端收到后, 也用同样的认证方式 (随机数 R 结合 `Session ID`) 生成 MD5 值, 然后用 Session Key 解密客户端发来的 MD5 值, 对比是否一致完成验证. 

## 数据传输

验证成功后就是数据传输阶段, 该阶段使用 `Session Key` 进行加密传输.



# 总结

SSH 分为两大步:

第一步是客户端和服务端建立连接, 最终生成双方都一致的 Session Key.

第二步使用 Authorized Key 进行登录, 登录过程使用 Public/Private Key 验证身份. 连接建立完成后, 在通讯过程中使用 Session Key 对信息进行加密解密.



# Git 与 SSH

git 基于多种传输协议, 其中最常用的就是 https 和 ssh. 都是为了数据传输安全, 那么设置 ssh 密钥的目的是为了节省输入用户名密码的过程, 同时保证传输安全. 并不是必须设置.

比如 github, 就可以通过将自己的公钥配置到 github 端, 这样传输的时候就不用每次都输入密码了.

使用 ssh-keygen 可以生成公钥和私钥, 具体可以参考[这篇文章](https://www.liaohuqiu.net/cn/posts/ssh-keygen-abc/).



# 参考资料

1. [SSH 详解](https://segmentfault.com/a/1190000011395818)

2. [SSH认证登陆的过程与原理](https://blog.csdn.net/xufox/article/details/105623400)

3. [每天都在用 SSH，你知道 SSH 的原理吗？](https://zhuanlan.zhihu.com/p/108161141)

4. [SSH原理与运用（一）：远程登录](https://www.ruanyifeng.com/blog/2011/12/ssh_remote_login.html)