//
//  Macros.h
//  ios+cordovaDemo
//
//  Created by 付金亮 on 2018/12/11.
//  Copyright © 2018 付金亮. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

//状态栏高度
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

#define SCREEN_WIDTH (SCREEN_RECT.size.width)

#define SCREEN_HEIGHT (SCREEN_RECT.size.height)

#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)

// keyWindow
#define KEY_WINDOW ([UIApplication sharedApplication].keyWindow)
// keyWindow to UIView
#define KEY_VIEW (UIView *)KEY_WINDOW
#endif /* Macros_h */

// 外边距
#define MARGIN ([UIScreen iPhonePlus] ? 20 : 15)
#define MARGIN_2 45

// color
#define PRIMARY_COLOR 0x4775f4

#define UIColorFromRGB(rgbHex) [UIColor colorWithRed:((float)((rgbHex & 0xFF0000) >> 16))/255.0 green:((float)((rgbHex & 0xFF00) >> 8))/255.0 blue:((float)(rgbHex & 0xFF))/255.0 alpha:1.0]

#define GSE_Blue UIColorFromRGB(0x326fff) //UIColorFromRGB(0x307fe2) //UIColorFromRGB(0x2199f8)

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
// 本地服务的内网地址
#define LOCAL_BASE_URL @"http://192.168.43.231"
// debug下的stripe支付的后台服务(本地服务)
#define STRIPE_SERVER_URL [NSString stringWithFormat:@"%@:3000", LOCAL_BASE_URL]
// debug下的ofo访问网站(本地服务)
#define OFO_H5_URL [NSString stringWithFormat:@"%@:8088", LOCAL_BASE_URL]
#else
#define NSLog(...)
// 非debug下的stripe支付的后台服务(远程服务)
#define STRIPE_SERVER_URL @"http://140.143.31.52:3000"
// 非debug下的ofo访问网站(远程服务)
#define OFO_H5_URL @"https://dapp.gsenetwork.co"
#endif
