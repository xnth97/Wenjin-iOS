Wenjin-iOS
======================
问津社区 iOS 版客户端

# 简介

> 寻师讲道，结友问津。

问津 是天外天工作室出品的天津大学校内问答社区。本项目为问津社区 iOS 客户端，适配 iPhone, iPod touch, iPad 平台。

# 项目架构

本项目遵循 MVC 架构规范。项目结构主要为：

* Main
	* AppDelegate
	* Localizeable.Strings
	* main.m
	* info.plist
	* Base.lproj & zh-Hans.lproj
* Model
	* 数据模型
	* 各模块数据管理器
	* 消息显示模块
	* 本地数据管理
		* 缓存管理
		* Cookie 管理
		* 数据库管理
		* 数据库数据模型
	* 字符串处理
	* App 外观颜色管理
	* API 调用及加密模块
	* 单例模式实现
	* UIActivity
* View
	* UITableViewCell
	* 各种自定义 View
* Controller
	* MainTabBarController
	* UIViewController
	* Main.storyboard
	* XIB
* Resource
	* Images.xcassets
	* Bootstrap
	* 第三方 framework

# 数据结构

## 问题草稿

* questionTitle __String__
* questionDetail __String__
* topicArrData __NSData__: 使用 NSKeyedArchiver 打包的 NSArray
* attachAccessKey __NSString__
* anonymous __NSInteger__
* time __NSDate__

## 答案草稿

* questionId __NSString__
* answerContent __NSString__
* attachAccessKey __NSString__
* anonymous __NSInteger__
* time __NSDate__

# 开源项目

衷心感谢以下开源项目为 问津 作出的不可磨灭的贡献。

* CocoaPods
* AFNetworking
* BlocksKit
* MJExtension
* SVProgressHUD
* SVPullToRefresh
* POP
* KVOController
* FXForms
* NYSegmentedControl
* TLTagsControl
* Realm

为适应 问津 的需求，部分代码被做出了一些更改并 fork 到我自己的分支中（而未通过 Cocoapods 进行管理）。具体详见代码。







