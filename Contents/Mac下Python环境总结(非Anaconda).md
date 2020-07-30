---
title: Mac 下 Python 环境总结 (非 Anaconda)
date: 2020-06-17 11:20:45
categories: 
- Python
tags: 
- Homebrew
- Python
- Shell
---

# Mac 自带的 Python

mac 本身自带了 python 2.7, 位置在

```shell
/usr/bin
```

通过 `ll | grep -i python` 查到相关的软连接:

```shell
lrwxr-xr-x   1 root   wheel    75B  3 10 09:21 python -> ../../System/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7
```

也就是自带 python 的地址:

```
/System/Library/Frameworks/Python.framework/
```

我们可以通过在终端输入 `python` 来打开:

```shell
$ python

WARNING: Python 2.7 is not recommended.
This version is included in macOS for compatibility with legacy software.
Future versions of macOS will not include Python 2.7.
Instead, it is recommended that you transition to using 'python3' from within Terminal.

Python 2.7.16 (default, Apr 17 2020, 18:29:03)
[GCC 4.2.1 Compatible Apple LLVM 11.0.3 (clang-1103.0.29.20) (-macos10.15-objc- on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

上面可以看出, 之后 mac os 可能不会再带 2.7 了, 但目前并不建议直接删除 python 2.7, 可能系统还有对此的依赖. 所以最好就放在那里. 我们之后安装好 `python3`  直接使用 `python3` 就好了.



# Homebrew 安装的 Python

## Python

通过 homebrew 可以很方便地安装 python:

```shell
brew install python3
```

安装的路径在:

```shell
/usr/local/Cellar/python/3.7.7
```

从上面可以看出可以安装多个版本的 python.

同时 homebrew 会自动在 `/usr/local/bin` 里配置软连接:

```shell
lrwxr-xr-x  1 user  admin    34B  4  5 20:50 python3 -> ../Cellar/python/3.7.7/bin/python3
```

也就是说我们可以通过输入 `python3` 来启动 python:

```shell
$ python3
Python 3.7.7 (default, Mar 10 2020, 15:43:33)
[Clang 11.0.0 (clang-1100.0.33.17)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

这里我们 `cd` 到 python 的安装目录 `/usr/local/Cellar/python/3.7.7` 下:

```shell user /usr/local/Cellar/python/3.7.7
$ ll
total 64
drwxr-xr-x   3 user  staff    96B  3 10 14:34 Frameworks
drwxr-xr-x   3 user  staff    96B  3 10 14:34 IDLE 3.app
-rw-r--r--   1 user  staff   3.0K  4  5 20:50 INSTALL_RECEIPT.json
-rw-r--r--   1 user  staff    12K  3 10 14:34 LICENSE
drwxr-xr-x   3 user  staff    96B  3 10 14:34 Python Launcher 3.app
-rw-r--r--   1 user  staff   9.6K  3 10 14:34 README.rst
drwxr-xr-x  20 user  staff   640B  4  5 20:50 bin
drwxr-xr-x   3 user  staff    96B  3 10 14:34 lib
drwxr-xr-x   6 user  staff   192B  3 10 14:34 libexec
drwxr-xr-x   3 user  staff    96B  3 10 14:34 share
```

注意上面的 `Frameworks` 这个东西, 之后我们会用到. 再 `cd` 到 `bin` 内:

```shell user /usr/local/Cellar/python/3.7.7/bin [12:46:16]
$ ll
total 32
lrwxr-xr-x  1 user  staff    52B  3 10 14:34 2to3 -> ../Frameworks/Python.framework/Versions/3.7/bin/2to3
lrwxr-xr-x  1 user  staff    56B  3 10 14:34 2to3-3.7 -> ../Frameworks/Python.framework/Versions/3.7/bin/2to3-3.7
-rwxr-xr-x  1 user  staff   431B  4  5 20:50 easy_install-3.7
lrwxr-xr-x  1 user  staff    53B  3 10 14:34 idle3 -> ../Frameworks/Python.framework/Versions/3.7/bin/idle3
lrwxr-xr-x  1 user  staff    55B  3 10 14:34 idle3.7 -> ../Frameworks/Python.framework/Versions/3.7/bin/idle3.7
-rwxr-xr-x  1 user  staff   386B  4  5 20:50 pip3
-rwxr-xr-x  1 user  staff   390B  4  5 20:50 pip3.7
lrwxr-xr-x  1 user  staff    54B  3 10 14:34 pydoc3 -> ../Frameworks/Python.framework/Versions/3.7/bin/pydoc3
lrwxr-xr-x  1 user  staff    56B  3 10 14:34 pydoc3.7 -> ../Frameworks/Python.framework/Versions/3.7/bin/pydoc3.7
lrwxr-xr-x  1 user  staff    55B  3 10 14:34 python3 -> ../Frameworks/Python.framework/Versions/3.7/bin/python3
lrwxr-xr-x  1 user  staff    62B  3 10 14:34 python3-config -> ../Frameworks/Python.framework/Versions/3.7/bin/python3-config
lrwxr-xr-x  1 user  staff    57B  3 10 14:34 python3.7 -> ../Frameworks/Python.framework/Versions/3.7/bin/python3.7
lrwxr-xr-x  1 user  staff    64B  3 10 14:34 python3.7-config -> ../Frameworks/Python.framework/Versions/3.7/bin/python3.7-config
lrwxr-xr-x  1 user  staff    58B  3 10 14:34 python3.7m -> ../Frameworks/Python.framework/Versions/3.7/bin/python3.7m
lrwxr-xr-x  1 user  staff    65B  3 10 14:34 python3.7m-config -> ../Frameworks/Python.framework/Versions/3.7/bin/python3.7m-config
lrwxr-xr-x  1 user  staff    54B  3 10 14:34 pyvenv -> ../Frameworks/Python.framework/Versions/3.7/bin/pyvenv
lrwxr-xr-x  1 user  staff    58B  3 10 14:34 pyvenv-3.7 -> ../Frameworks/Python.framework/Versions/3.7/bin/pyvenv-3.7
-rwxr-xr-x  1 user  staff   394B  4  5 20:50 wheel3
```

可以发现这里的 `python3` 也是一个软链接, 链接到了 `../Frameworks/Python.framework/Versions/3.7/bin/python3` 这个地方.

我们返回上一个目录, 实际上 python 安装到了以下这个目录下:

```
/usr/local/Cellar/python/3.7.7/Frameworks/Python.framework/Versions/3.7
```

这个时候再比较和系统自带的 python 路径:

```
/System/Library/Frameworks/Python.framework/Versions/2.7
```

目录结构就基本一样了. 

知道了 python3.7 具体安装在哪, 我们再返回看这个目录 `/usr/local/`, 这个目录下还有个 `Framework`

```shell user /usr/local [13:19:52]
$ ll
total 0
drwxrwxr-x   13 user  admin   416B  6  7 10:30 Caskroom
drwxrwxr-x   33 user  admin   1.0K  6 17 10:00 Cellar
drwxrwxr-x    4 user  admin   128B  4  5 20:50 Frameworks
drwxrwxr-x   21 user  admin   672B  6 17 10:04 Homebrew
drwxrwxr-x  114 user  admin   3.6K  6 17 12:25 bin
drwxrwxr-x   10 user  admin   320B  6 17 10:00 etc
drwxrwxr-x   37 user  admin   1.2K  6 17 10:00 include
drwxrwxr-x   71 user  admin   2.2K  6 17 10:00 lib
lrwxr-xr-x    1 root  wheel    30B  4 20 09:06 mysql -> mysql-8.0.19-macos10.15-x86_64
drwxr-xr-x   14 root  wheel   448B  4 27 09:30 mysql-8.0.19-macos10.15-x86_64
drwxrwxr-x   43 user  admin   1.3K  6 17 10:04 opt
drwxrwxr-x    3 user  admin    96B  5 18 10:21 sbin
drwxrwxr-x   26 user  admin   832B  6 17 10:04 share
drwxrwxr-x    4 user  admin   128B  5  7 20:38 var
```

我们进入这个目录, 发现里面还是 python

```shell user /usr/local/Frameworks [13:21:16]
$ ll
total 0
drwxr-xr-x  6 user  admin   192B  4  5 20:50 Python.framework
```

然后再进入就会发现, 其实还是前面安装的 python3.7 的软连接:

```shell user /usr/local/Frameworks/Python.framework/Versions [13:22:19]
$ ll
total 0
lrwxr-xr-x  1 user  admin    69B  4  5 20:50 3.7 -> ../../../Cellar/python/3.7.7/Frameworks/Python.framework/Versions/3.7
lrwxr-xr-x  1 user  admin    73B  4  5 20:50 Current -> ../../../Cellar/python/3.7.7/Frameworks/Python.framework/Versions/Current
```

这样, 通过 Homebrew 安装的 python3 的位置基本就清楚了.

## Pip

然后说包管理工具 pip.

通过 homebrew 安装的 python 是自带 pip3 的, 软连接命令也在这个目录内:

```shell
$ ll | grep -i pip
lrwxr-xr-x  1 user  admin    31B  4  5 20:50 pip3 -> ../Cellar/python/3.7.7/bin/pip3
lrwxr-xr-x  1 user  admin    33B  4  5 20:50 pip3.7 -> ../Cellar/python/3.7.7/bin/pip3.7
```

也就是原命令地址为:

```shell
/usr/local/Cellar/python/3.7.7/bin/pip3
/usr/local/Cellar/python/3.7.7/bin/pip3.7
```

pip 的程序目录在:

```shell
/usr/local/Cellar/python/3.7.7/libexec/pip
```

然后通过 `pip3 -V` 可以查看版本:

```shell
$ pip3 -V
pip 20.0.2 from /usr/local/lib/python3.7/site-packages/pip (python 3.7)
```

同时, 从上面显示的信息可以发现, 通过 `pip3` 安装的包在以下位置:

```shell
/usr/local/lib/python3.7/site-packages
```

比如我们安装 `pandas`, 同时会安装很多其他包, 比如 `numpy`, 可以通过以下命令:

```shell
pip3 install pandas
```

安装完成后查看:

```shell
$ pip3 list
Package         Version
--------------- -------
numpy           1.18.5
pandas          1.0.4
pip             20.0.2
python-dateutil 2.8.1
pytz            2020.1
setuptools      46.0.0
six             1.15.0
wheel           0.34.2
```

再看 `/usr/local/lib/python3.7/site-packages` 这个目录下的包:

```shell user /usr/local/lib/python3.7/site-packages [13:30:52]
$ ll
total 88
drwxr-xr-x   5 user  admin   160B  6 17 12:24 __pycache__
drwxr-xr-x  14 user  admin   448B  6 17 12:24 dateutil
-rw-r--r--   1 user  admin   126B  3 10 14:34 easy_install.py
drwxr-xr-x  30 user  admin   960B  6 17 12:25 numpy
drwxr-xr-x  10 user  admin   320B  6 17 12:25 numpy-1.18.5.dist-info
drwxr-xr-x  21 user  admin   672B  6 17 12:25 pandas
drwxr-xr-x  10 user  admin   320B  6 17 12:25 pandas-1.0.4.dist-info
drwxr-xr-x   7 user  admin   224B  4  5 20:50 pip
drwxr-xr-x   8 user  admin   256B  4  5 20:50 pip-20.0.2-py3.7.egg-info
drwxr-xr-x   8 user  admin   256B  4  5 20:50 pkg_resources
drwxr-xr-x   9 user  admin   288B  6 17 12:24 python_dateutil-2.8.1.dist-info
drwxr-xr-x  10 user  admin   320B  6 17 12:24 pytz
drwxr-xr-x  11 user  admin   352B  6 17 12:24 pytz-2020.1.dist-info
drwxr-xr-x  44 user  admin   1.4K  4  5 20:50 setuptools
drwxr-xr-x   9 user  admin   288B  4  5 20:50 setuptools-46.0.0-py3.7.egg-info
-rw-r--r--   1 user  admin   2.0K  4  5 20:50 sitecustomize.py
drwxr-xr-x   8 user  admin   256B  6 17 12:24 six-1.15.0.dist-info
-rw-r--r--   1 user  admin    33K  6 17 12:24 six.py
drwxr-xr-x  14 user  admin   448B  4  5 20:50 wheel
drwxr-xr-x   9 user  admin   288B  4  5 20:50 wheel-0.34.2-py3.7.egg-info
```

这其实也就是 python 默认的环境.

## Python 虚拟环境

### virtualenv

运行 python 需要一个运行环境, 这个环境里包含了诸多可用的包以供我们调用. 而通过上面我们已经知道默认的环境的位置了, 这样我们就可以通过 `pip3 install xxx` 来安装我们需要的包.

但是, 一个环境里包的版本只能有一个, 比如我们想在 A 项目中使用 numpy 的 1.18 版本, 想在 B 项目中使用 numpy 的 1.17 版本, 那么这样就无法实现了. 所以, 我们应该为不同的项目创建不同的运行环境, 以供不同需求的项目使用.

首先需要安装 `virtualenv`:

```shell
pip3 install virtualenv
```

安装成功后, 其实已经在 `/usr/local/bin` 比如我们创建一个项目并进入此目录:

```shell
$ pwd
/Users user/projects/mypyproject
```

接着创建一个名为 `venv` 的运行环境:

```shell
$ virtualenv venv
created virtual environment CPython3.7.7.final.0-64 in 403ms
  creator CPython3Posix(dest=/Users user/projects/mypyproject/venv, clear=False, global=False)
  seeder FromAppData(download=False, pip=latest, setuptools=latest, wheel=latest, via=copy, app_data_dir=/Users user/Library/Application Support/virtualenv/seed-app-data/v1.0.1)
  activators BashActivator,CShellActivator,FishActivator,PowerShellActivator,PythonActivator,XonshActivator
```

查看已经创建好的环境:

```shell
$ ll
total 0
drwxr-xr-x  6 user  staff   192B  6 17 15:30 venv
```

进入 `cd venv` 并查看:

```shell
$ ll
total 8
drwxr-xr-x  21 user  staff   672B  6 17 15:30 bin
drwxr-xr-x   3 user  staff    96B  6 17 15:30 lib
-rw-r--r--   1 user  staff   422B  6 17 15:30 pyvenv.cfg
```

接着通过以下命令启用此环境:

```shell
$ source ./bin/activate
```

这个时候前面会添加 `(venv)` 即环境的名称, 表示已经进入此环境, 此时查看新建的环境内的包:

```shell
(venv) user ~/projects/mypyproject/venv [15:31:16]
$ pip3 list
Package    Version
---------- -------
pip        20.1.1
setuptools 47.1.1
wheel      0.34.2
```

可以发现空空如也, 因此我们就为特定项目创建了一个特定的 python 运行环境.

当然如果你想创建的新的运行环境里想要添加系统运行环境中已经有的第三方包, 可以在创建时使用以下命令:

```shell
virtualenv --system-site-packages venv
```

想退出这个环境通过以下命令即可:

```shell
$ deactivate
```

我们在使用 PyCharm 创建项目时, 有以下配置项:

![image-20200617153910243](https://strawberr userzc.oss-cn-shanghai.aliyuncs.com/img/image-20200617153910243.png)

下面的红色方框即选择了我们通过 Homebrew 安装的 python3, 上面的方框就是默认为这个叫 untitled 的项目创建了一个名为 venv 的运行环境.

### virtualenvwrapper

直接通过上面的命令创建环境其实很不方便, 我们可以通过 virtualenvwrapper 这个工具来方便地管理.

下载:

```shell
$ pip3 install virtualenvwrapper
```

下载完成后可以发现同样在 `/usr/local/bin` 下已经有相应的脚本了 (上面两个是 virtualenv 的, 后面两个才是 virtualenvwrapper 的) :

```shell user /usr/local/bin [16:05:26]
$ ll | grep -i virtualenv
-rwxr-xr-x  1 user  admin   257B  6 17 15:26 virtualenv
-rwxr-xr-x  1 user  admin   233B  6 17 15:59 virtualenv-clone
-rwxr-xr-x  1 user  admin    41K  6 17 15:59 virtualenvwrapper.sh
-rwxr-xr-x  1 user  admin   2.2K  6 17 15:59 virtualenvwrapper_lazy.sh
```

根据 virtualenvwrapper 的[官网](https://virtualenvwrapper.readthedocs.io/en/latest/install.html), 发现需要配置环境变量, 来存放需要管理的运行环境:

- 首先需要创建一个文件夹来存放所有的虚拟环境, 我们就是用默认的即可 `WORKON_HOME=$HOME/.virtualenvs`.

-  其次, 我们本身电脑有一个 `python2.7`, 并且默认 `python` 也是指向 `python2.7` 的. 但是我们现在用的是 `python3`, 而 virtualenvwrapper 默认配的是 `python`, 所以我们需要其使用 `python3`, 需要配置 `VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3`.
- 最后需要将 `virtualenvwrapper.sh` 加载到系统环境中, 即 `source /usr/local/bin/virtualenvwrapper.sh`

总结下来就是, 我们将以下代码追加到 `~/.zshrc` 的最后

```shell
# python venv
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
   export WORKON_HOME=$HOME/.virtualenvs
   VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
   source /usr/local/bin/virtualenvwrapper.sh
fi
```

之后 `source ~/.zshrc` 一下, 会在指定目录下创建很多东西:

```shell
$ source ~/.zshrc
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/premkproject
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/postmkproject
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/initialize
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/premkvirtualenv
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/postmkvirtualenv
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/prermvirtualenv
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/postrmvirtualenv
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/predeactivate
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/postdeactivate
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/preactivate
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/postactivate
virtualenvwrapper.user_scripts creating /Users user/.virtualenvs/get_env_details
```

接着就可以愉快地创建虚拟环境了, 使用以下命令:

```shell
$ mkvirtualenv venv
```

当然, 还可以使用 `virtualenv` 创建环境时的参数, 比如 `-p /usr/local/bin/python3` 来指定 python 版本.

创建 `venv` 之后会自动切换至这个环境, 还有以下实用命令:

```shell
lsvirtualenv -b # 列出虚拟环境 
workon [venv_name] # 切换到 venv_name 这个环境
lssitepackages # 查看环境里安装了哪些包
cdvirtualenv [子目录名] # 进入当前环境的目录
cpvirtualenv [source] [dest] # 复制虚拟环境
deactivate # 退出虚拟环境
rmvirtualenv [虚拟环境名称] # 删除虚拟环境
```

这下就方便多了.

这样整理一遍发现关于 python 的环境问题基本没有了, 如果要进行数据分析和使用 Jupyter notebook 的话当然应该使用 Anaconda 会更方便一些. 而 Anaconda 的安装其实已经有很多人写了, 之后如果我安装了再补充吧.



# 参考文章

1. [macOS 安裝virtualenv 和 virtualenvwrapper](https://www.jianshu.com/p/219d7f543c15)

2. [Virtualenv 的安装与配置](https://juejin.im/post/5be1104fe51d4572e33a7145)

