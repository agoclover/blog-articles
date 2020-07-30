---
title: 以Hexo框架腾讯云服务器搭建博客记录
date: 2020-05-04 23:54:13
categories:
- Blog
tags:
- Hexo
- Linux
- SSH
- Git
---

记录一下博客搭建的过程, 之后遇到问题也会及时更新.

# 服务与框架

服务器: 腾讯云云服务器标准型SA2,配置1核 2GB 1Mbps

框架: [Hexo](https://hexo.io/)

Hexo 主题: [cactus](https://github.com/probberechts/hexo-theme-cactus)



# 本地端

## 安装依赖

由于 Hexo 是基于 Node.js 的, 所以需要先安装 Node.js.

从[官方网站](https://nodejs.org/zh-cn/)下载长期支持版本, 然后安装即可, 安装完之后会显示安装的路径, 可以发现同时安装了 Node.js 和随之的包管理工具 npm. 可以通过在终端输入以下命令查看是否安装成功:

```shell
# user @ usermbp in ~ [22:41:59]
$ node -v
v12.16.3

# user @ usermbp in ~ [22:42:01]
$ npm -v
6.14.4
```

由于可能 npm 的镜像源访问速度慢, 可以通过 `npm` 来安装淘宝的镜像源 `cnpm`, 之后所有 `npm ...` 命令都可以改成 `cnpm ...` 命令 ( `-g` 为全局安装):

```shell
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

接着通过 `cnpm` 安装 hexo ( `-g` 为全局安装):

```shell
cnpm install -g hexo-cli
```

同样可以 `hexo -v` 进行验证是否安装成功.

## 初始化

接着在合适的位置创建一个空文件夹用以存放博客资源, 并切换终端目录至其中:

```shell
# user @ usermbp in ~/blog [22:49:37]
$ pwd
/Users/user/blog
```

使用以下命令即可初始化博客:

```shell
# user @ usermbp in ~/blog [22:49:37]
$ hexo init
```

以下是一些常用命令:

```
hexo new "article name"   # 创建一篇博文
hexo g					  # 生成博客资源
hexo s			    	  # 本地展示博客
hexo d					  # 部署博客
```

通过 `hexo new "article name"` 后, 在 `/Users/user/blog/source/_posts ` 下可以看到生成的文章的 Markdown 文件, 编辑即可; 再通过第二第三条命令, 即可在本地浏览器的 `https://localhost:4000` 访问博客了.

## 主题下载

默认自带 landscape 合格主题, 可以在 hexo 的官方网站选择下载自己喜欢的主题至 `themes/` 这个目录下, 我选择的是 [cactus](https://github.com/probberechts/hexo-theme-cactus) 这个主题. 接着将 `blog/_config.yml` 这个配置文件打开, 将主题更换成 `themes` 下新主题的文件夹的名字:

```yml
# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: cactus
```

你也可以使用[我的主题](https://github.com/agoclover/my-cactus), 我的主题是基于 cactus 进行的微小的更改, 将其 `.zip` 下载到本地解压并移到  `themes/` 即可.

你可以参考 [cactus](https://github.com/probberechts/hexo-theme-cactus) 的官方文档或者 hexo 的[官方文档](https://hexo.io/docs/)来了解更多 hexo 主题或其他的配置方法.

至此本地端配置完成.



# 服务器端

## 安装 nginx

nginx 是一款轻量级的 Web 服务器, 反向代理服务器, 由于它的内存占用少, 启动极快, 高并发能力强, 在互联网项目中广泛应用. 

我们需要首先安装 nginx, 而安装 nginx 之前需要安装相关的依赖库, 我们先进行库的安装:

**安装 gcc gcc-c++**

```shell
yum install -y gcc gcc-c++
```

**安装 PCRE 库**

```shell
# 先切换到这个目录下
cd /usr/local/
# 下载 PCRE 库的压缩包
wget http://downloads.sourceforge.net/project/pcre/pcre/8.37/pcre-8.37.tar.gz
# 解压到当前目录
tar -xvf pcre-8.37.tar.gz
# 切换到我们解压后的文件的目录下
cd pcre-8.37
# 生成 Makefile, 为下一步的编译做准备
./configure
# 进行编译
make && make install
# 编译结束后, 查看版本
pcre-config --version
```

**安装 openssl, zlib, gcc 依赖**

```shell
yum -y install make zlib zlib-devel gcc-c++ libtool openssl openssl-devel
```

**安装 nginx**

安装 nginx 一定要在 `/usr/local` 文件夹下:

```shell
# 切换到这个目录
cd /usr/local/
# 下载
wget http://nginx.org/download/nginx-1.17.9.tar.gz
# 解压
tar -xvf nginx-1.17.9.tar.gz
# 进入解压后的文件目录
cd nginx-1.17.9
# 生成 Makefile, 为下一步的编译做准备
./configure
# 编译
make && make install
```

至此 nginx 安装结束.

## 安装 git及配置仓库

**安装 git**

```shell
yum install git
```

**新建 git 用户并更改权限**

我们本身是 root 用户, 创建一个新的用户叫做 git, 不要搞混, 这里是 linux 的一个用户的名字叫 git:

```shell
adduser git
```

修改其权限, 让其可以执行 `sudo` 命令:

```shell
chmod 740 /etc/sudoers

vim /etc/sudoers
```

在如下位置:

![20200330120825](https://strawberryuserzc.oss-cn-shanghai.aliyuncs.com/img/20200330120825.png)

添加 `git ALL=(ALL) ALL`, 并保存关闭, 这一步还是扩大其权限, 让 git 用户在任何地方都可以执行任何命令.

接着更改这个文件的权限:

```shell
chmod 400 /etc/sudoers
```

 `400   -r--------`   表示拥有者能够读, 其他任何人不能进行任何操作.

目前我们还是在 root 用户下的, 接着给 git 用户设置密码:

```shell
sudo passwd git
```

接着切换至 git 用户, 这里加 `-` 的原因可以参考我写的[这篇文章](http://106.54.55.7/2020/05/03/Linux%E5%AE%B6%E7%9B%AE%E5%BD%95%E4%B8%8E%E7%94%A8%E6%88%B7%E5%88%87%E6%8D%A2/).

```shell
su - git
```

接着**建立秘钥**. 这里多说几句, 为什么要配置秘钥呢? hexo 的部署是靠 git 远程部署的, 其实就相当于 github 了, 我们在 github 里其实就存放了本机的秘钥 (公钥), 这样, github 就认识本地端了, 那么之后从本地 push 到 github 就不用输入账户和密码了. 这里也一样, 你可以认为服务器就是 github, 我们要将本地的公钥存放到服务器, 这样本地博客进行远程部署的时候, 服务器就能认出来, 就不用每次都输入密码, 这样提高了效率. 其实, 这就是 SSH 的核心, SSH 本身就是 git 的一种协议. 比如我们从 github 下载或克隆时, 就可以选择 SSH 协议, 也可以选择 http 协议. 关于 SSH 协议更多请参考我写的[这篇文章](http://106.54.55.7/2020/05/02/SSH%E7%99%BB%E5%BD%95%E8%AE%A4%E8%AF%81%E7%AE%80%E6%9E%90/).

而 SSH 对于别人的公钥存放地址默认是当前用户的家目录的 `.ssh` 这个隐藏文件夹下的. 家目录就是 `~` 这个目录, 也就是用户刚登录的地址. 在 linux 上, root 用户的家目录是 `/root`, 而一般用户的家目录是 `/home/user/` 这个是不一样的! 所以, 我们既然新建了 git 用户用来进行部署, 就要在 git 用户的加目录下存放我们本地的密钥:

```shell
mkdir .ssh

cd .ssh

vi authorized_keys
```

然后回到我们自己的计算机, 比如 mac 的秘钥地址在 `/user/.ssh/` 下的 `rsa_pub`, 打开并将其内容复制到我们刚创建的文件中, 这个文件 `authorized_keys` 存放的就是服务器的 git 用户信任或认识的客户端.

接着修改权限让其他人不能轻易操作:

```shell
chmod 600 ~/.ssh/authorized_keys

chmod 700 ~/.ssh
```

接着[创建 git 裸仓](http://zhangchao.top/2020/05/07/git-init%E5%92%8Cgit-init-bare%E7%9A%84%E5%8C%BA%E5%88%AB/):

```shell
cd ~

git init --bare blog.git

vi ~/blog.git/hooks/post-receive
```

输入:

```shell
git --work-tree=/home/www/website --git-dir=/home/git/blog.git checkout -f
```

保存退出后, 给这个文件执行权限, 就是让它可以执行:

```shell
chmod +x ~/blog.git/hooks/post-receive
```

**注意**, 以上指令都需要在 `su - git` 之后执行, 如果中途断开重新连接过, 需要重新执行 `su - git` 指令进入 git 账户.

在 root 用户下, 在家目录下创建仓库用于存储博客文件, 并修改文件权限:

```shell
su - root
mkdir -p /home/www/website
chmod 777 -r /home/www
```

## 修改本地配置

在本地 `_config.yml` 配置文件中修改:

```xml
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
    type: git
    repo: git@XX.XX.XX.X:/home/git/blog.git
    branch: master
```

其中 `XX.XX.XX.X`  替换为自己的服务器公网地址.

## 启动脚本

当服务器系统重启后, nginx 需要重新开启, 写以下脚本以便于自己开启 nginx 服务.

在 `/etc/init.d/` 路径下添加脚本文件, 名称为 nginx, 内容如下:

```shell
#!/bin/bash
#Startup script for the nginx Web Server
#chkconfig: 2345 85 15
nginx=/usr/local/nginx/sbin/nginx
conf=/usr/local/nginx/conf/nginx.conf
case $1 in 
start)
echo -n "Starting Nginx"
$nginx -c $conf
echo " done."
;;
stop)
echo -n "Stopping Nginx"
killall -9 nginx
echo " done."
;;
test)
$nginx -t -c $conf
echo "Success."
;;
reload)
echo -n "Reloading Nginx"
ps auxww | grep nginx | grep master | awk '{print $2}' | xargs kill -HUP
echo " done."
;;
restart)
$nginx -s reload
echo "reload done."
;;
*)
echo "Usage: $0 {start|restart|reload|stop|test|show}"
;;
esac
```

修改权限以可以执行:

```shell
chmod +x nginx
```

在 `/etc/init.d/` 路径下的脚本以 `service` 开启:

```shell
service nginx start
service nginx stop
service nginx restart
```



# 参考文章

1. [如何将博客部署到云服务器]([https://lneverl.gitee.io/posts/2092ec56.html#2-2%E5%AE%89%E8%A3%85Git%E5%8F%8A%E9%85%8D%E7%BD%AE%E4%BB%93%E5%BA%93](https://lneverl.gitee.io/posts/2092ec56.html#2-2安装Git及配置仓库))

