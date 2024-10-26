
# luci-app-partexp

luci-app-partexp 一键自动格式化分区、扩容、自动挂载插件
[![若部分图片无法正常显示，请挂上机场浏览或点这里到末尾看修复教程](https://visitor-badge.glitch.me/badge?page_id=sirpdboy-visitor-badge)](#解决-github-网页上图片显示失败的问题)

[luci-app-partexp](https://github.com/sirpdboy/luci-app-partexp)
======================


请 **认真阅读完毕** 本页面，本页面包含注意事项和如何使用。

## 功能说明：


#### 一键自动格式化分区、扩容、自动挂载插件，专为OPENWRT设计，简化OPENWRT在分区挂载上烦锁的操作。本插件是sirpdboy耗费大量精力制作测试，请勿删除制作者信息！！

<!-- TOC -->

- [partexp](#luci-app-partexp)
  - [特性](#特性)
  - [使用方法](#使用方法)
  - [说明](#说明)
  - [界面](#界面)
  - [捐助](#捐助)

<!-- /TOC -->

## 特性
 luci-app-partexp 自动获格式化分区扩容，自动挂载插件

## 使用方法

- 将luci-app-partexp添加至 LEDE/OpenWRT 源码的方法。

### 下载源码方法：

 ```Brach
 
    # 下载源码
	
    git clone https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp
    make menuconfig
	
 ``` 
### 配置菜单

 ```Brach
    make menuconfig
	# 找到 LuCI -> Applications, 选择 luci-app-partexp, 保存后退出。
 ``` 
 
### 编译

 ```Brach 
    # 编译固件
    make package/luci-app-partexp/compile V=s
 ```

## 说明

![screenshots](https://raw.githubusercontent.com/sirpdboy/openwrt/master/doc/说明2.jpg)

## 界面

![screenshots](https://raw.githubusercontent.com/sirpdboy/openwrt/master/doc/partexp.jpg)
