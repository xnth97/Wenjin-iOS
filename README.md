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
	* FoundationKits
		* UIActivity
* View
	* Table View Cells
	* Custom Views
* Controller
	* MainTabBarController
	* WJPageController
	* UIViewController
	* Main.storyboard
	* XIB
* Resource
	* Images.xcassets
	* Built-in Bootstrap & JQuery
	* 3rd Party SDKs

# Data Structure

## NSUserDefault

There aren't so many things other than some settings. Saved as key-value pairs.

```json
{
    "autoFocus": BOOL,
    "userIsLoggedIn": BOOL
}
```

## Cache

Currently I simply cache data by archiving `id` into `NSData` and save them to `Cache` directory through `writeToFile:` method.

## Draft

Drafts are saved in SQLite database `/Documents/draft.db`, which consists of 2 tables: Question and Answer. I use FMDB to operate SQLite database and all methods are extracted in `wjDatabaseManager` class, through which SQLite queries and NSObjects are converted to each other.

### Question Draft

* questionTitle __String__
* questionDetail __NSAttributedString__
* topicArrData __NSData__: NSKeyedArchiver-archived NSArray
* attachAccessKey __NSString__
* anonymous __NSInteger__
* time __NSDate__

### Answer Draft

* questionId __NSString__
* answerContent __NSAttributedString__
* attachAccessKey __NSString__
* anonymous __NSInteger__
* time __NSDate__

In database, `NSInteger` should be converted to `NSNumber`. `NSAttributedString` and `NSArray` should be archived to `NSData` through `NSKeyedArchiver`. `NSDate` should be converted to `NSNumber` as UNIX timestamp.

# Acknowledgements

I would like to extend my sincere gratitude to the included open-source projects, without which this project would never be completed.

To meet specific demands of this project, some open-source projects were modified manually and forked into my own repositories instead of being managed by CocoaPods. 

> Copyright 2002-2015 TWT Studio