---
title: Mac创建虚拟机并设置静态IP
date: 2020-05-05 18:15:46
categories:
- Linux
tags:
- VMWare
- Linux
---

# 创建虚拟机

## 装机

`新建` - `继续` - `拖入 CentOS7 ISO` - `继续` - `继续` - `自定设置` 设置**名称**与**存储位置** - `存储` 到达设置界面:

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/截屏2020-05-05下午5.08.22.png" alt="设置界面" style="zoom:50%;" />

**处理器和内存**: 2 核	2G

**硬盘**: 50G

`关闭` - `开始装机`

## 安装系统

在以下界面, 上下键选择 `Install CentOS 7` - `Enter`

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/截屏2020-05-05下午5.15.09.png" alt="安装系统" style="zoom:50%;" />

选择语言为中文, 进入**安装信息摘要**:

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/截屏2020-05-05下午5.18.21.png" alt="截屏2020-05-05下午5.18.21" style="zoom: 33%;" />

**日期和时间**, 调整为正确的时间:

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505171920295.png" alt="调整日期和时间" style="zoom:33%;" />

**软件选择**, 选择**最小安装**, 新手可以选择 **GNOME 界面**, 开发人员可以选择**开发及生成工作站**.

**安装位置:** 

-  `我要配置分区` - `完成` - `+` 
-  `挂载点1: /boot 1G` - `添加挂载点` - `设备类型: 标准分区, 文件系统: ext4` 
-  `挂载点2: swap 2G` - `添加挂载点` - `设备类型: 标准分区, 文件系统: swap` 

-  `挂载点3: / 47G` - `添加挂载点` - `设备类型: 标准分区, 文件系统: ext4`
-  `完成` - `接受更改` 

**KDUMP**, 关闭

**网络和主机名**, 打开网络, 自定义主机名.

`开始安装` - 同时设置 `root 密码`

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505173059414.png" alt="安装系统中" style="zoom: 33%;" />

系统安装完成后**重启**, 进入系统:

![系统进入界面](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505173425790.png)

输入 root 用户和密码即可进入系统, 这里是默认最小安装界面, GNOME 界面当然不是这样的.

![系统界面](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505173528765.png)

至此, 虚拟机安装完毕.



# 设置静态 IP

由于 mac 的 VMWare Fusion 的默认是 `Internet 共享 - 与我的 Mac 共享`, 不像 Windows 可以很方便地选择 NAT 网络. 此时还是动态 IP, 我们需要将其设置为静态 IP.

## 创建 NAT 网络

关闭虚拟机, 通过快捷键 `cmd + ,` 打开配置, 选择 `网络`, 打开最下方的锁, 输入系统密码, 选择 `+` 

- **勾选** 允许该网络上的虚拟机链接到外部网络 (使用 NAT)
- **勾选** 将 Mac 主机连接到该网络
- **不勾选** 通过 DHCP 在该网络上的地址
- 应用

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505174713957.png" alt="创建NAT网络" style="zoom:50%;" />

## 修改 Nat 网络配置

打开终端, 进入以下目录:

```shell
cd /Library/Preferences/VMware\ Fusion/

sudo vim networking
```

输入密码, `VNET_2 `开头的配置就是我们创建的那块网卡, 上面是**子网掩码**，下面**子网地址**:

![创建好的NAT](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505175031817.png)

再执行以下命令:

```shell
# amos @ amosmbp in /Library/Preferences/VMware Fusion [17:52:37]
$ cd vmnet2

# amos @ amosmbp in /Library/Preferences/VMware Fusion/vmnet2 [17:52:45]
$ sudo vim nat.conf
```

如下图所示, 修改这里的配置即可, 第一个是 ip, 下面的是子网掩码, 与前面的子网掩码保持一致, 上面的ip除了子网的第一个和最后一个ip不能用, 其他都可以用, 这里我们配置为`192.168.232.2`:

![image-20200505175331319](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505175331319.png)

再重新打开 VMWare 的网络配置, 为了让 VMware 更新我们手动修改的配置, 首先我们选中这个网络, 然后将 2 所示的选项取消选中, 这是后 3 会被点亮, 点击应用, 然后在将 2 选中, 再点击应用, 这样网络配置就更新了. 实际上不更改配置, 就是为了点击应用, 让 VMware 更新一下配置:

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200505180040680.png" alt="image-20200505180040680" style="zoom:50%;" />

## 虚拟机静态 IP配置

选择已经装好的虚拟机 - 右键 - 设置 - 网络适配器 - 选择 `vmnet2`.

打开并进入虚拟机, 进入以下目录:

```shell
cd /etc/sysconfig/network-scripts

vi ifcfg-ens33
```

进行编辑:

```shell
  BOOTPROTO="static"
  ONBOOT="yes"
  IPADDR=192.168.232.100
  NETMASK=255.255.255.0
  GATEWAY=192.168.232.2
  DNS1=192.168.232.2
```

 注意: 232 是我 vmnet2 的网段, 需要按照自己的来修改。

<img src="https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200506111247877.png" alt="虚拟机网络静态 IP 配合"  />

如上图, 其中子网掩码要与之前保持一致, 然后 ip 只要在同一网段就可以, 网关和DNS配置到我们之前配置的网关上去. 保存并退出.

重启网路服务: `systemctl restart network`

查看网络状态: `systemctl status network`, 如果如下图则网络已重启:

![查看网络状态](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200506111602099.png)

查看 ip: `ip a`, 如果显示如下则配置成功:

![静态 IP 配置成功](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200506111757011.png)

这个时候可以再通过虚拟机 `ping` 主机, 或者主机 `ping` 虚拟机, 用虚拟机 `ping baidu.com` 来测试网络连接.

## 可能遇到的问题

- 物理机能 `ping` 通虚拟机, 但是虚拟机 `ping` 不通物理机, 一般是因为物理的防火墙问题, 需要关闭物理机的防火墙.
- 虚拟机能 `ping` 同物理机, 但是虚拟机 `ping` 不通外网, 一般是因为 DNS 设置有问题.
- 虚拟机 `ping  www.baidu.com` , 提示未知的域名等信息, 一般要查看 GATEWAY 和 DNS设置是否正确.
- 如果如上设置没问题，需要关闭NetworkManager服务:

```shell
systemctl stop NetworkManager
systemctl disable NetworkManager
```
