Wenjin-iOS
======================
The iOS Client of WENJIN

# Introduction

> 寻师讲道，结友问津。

WENJIN(问津) is a question-and-answer community developed by TWT Studio, Tianjin University. This project is intend to build an iOS client for WENJIN Community in Objective-C.

# Project Structure

The structure of this project follows the standard of MVC pattern as below.

* Main
	* AppDelegate
	* Localizeable.Strings
	* main.m
	* info.plist
	* Base.lproj & zh-Hans.lproj
* Model
	* Data Model
	* Data Manager
	* Message Display
	* Local Data Manager
		* Cache Manager
		* Cookie Manager
		* Database Manager
		* Database Data Model
	* String Processor
	* Appearance Manager
	* APIs
	* Encryption
	* Singleton
	* UIActivity
* View
	* Table View Cells
	* Custom Views
* Controller
	* MainTabBarController
	* UIViewController
	* Main.storyboard
	* XIB
* Resource
	* Images.xcassets
	* Built-in Bootstrap
	* 3rd Party Frameworks

# Data Structure

## Question Draft

* questionTitle __String__
* questionDetail __String__
* topicArrData __NSData__: NSKeyedArchiver-archived NSArray
* attachAccessKey __NSString__
* anonymous __NSInteger__
* time __NSDate__

## Answer Draft

* questionId __NSString__
* answerContent __NSString__
* attachAccessKey __NSString__
* anonymous __NSInteger__
* time __NSDate__

# Acknowledgements

I would like to extend my sincere gratitude to the included open-source projects, without which this project would never be completed.

To meet specific demands of this project, some open-source projects were modified manually and forked into my own repositories instead of being managed by CocoaPods. 

> Copyright 2002-2015 TWT Studio