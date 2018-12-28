//
//  Macros.h
//  框架
//
//  Created by WangZhipeng on 16/5/18.
//  Copyright © 2016年 WangZhipeng. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

//全局高度
#define KDeviceW [UIScreen mainScreen].bounds.size.width

#define KDeviceH [UIScreen mainScreen].bounds.size.height

#define KFrame(x,y,w,h) ((CGRect){{x,y},{w,h}})

#define KImageName(image)   [UIImage imageNamed:image]

#define KNSString(str)   [NSString stringWithFormat:@"%@",str]

#define KUserDefaults   [NSUserDefaults standardUserDefaults]


//颜色
#define KRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define KHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define KHexRGB_Alpha(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.5]

#define KHexRGB_kAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define RGBHex(hexstr)   [UIColor hexStringToColor:[NSString stringWithFormat:@"%@",hexstr]]

//字体

#define KBlodFont(size)  [UIFont boldSystemFontOfSize:size]

#define KFont(size) [UIFont systemFontOfSize:size]

#define  KNotificationCenter [NSNotificationCenter defaultCenter]

#define KeyWindow [[UIApplication sharedApplication] keyWindow]

//适配
#define KScaleHight  ([UIScreen mainScreen].bounds.size.height / 568.0)
#define KScaleWidth  ([UIScreen mainScreen].bounds.size.width / 320.0)

#define KIsIOS8 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8)

//状态栏的高度
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//状态栏的高度+导航栏的高度
#define KNavigationBarHeight (KStatusBarHeight + 44)

//tabBar的高度+底部空间
#define KTabBarHeight (KIsIphoneX ? (49+KBottomHeight) : 49)


//iPhone X 底部按钮的高度
#define KBottomHeight (KIsIphoneX ? 34 : 0 )


//#define KWeakSelf(type)  __weak typeof(type) weak##type = type

#define KWeakSelf  __weak typeof (self)weakSelf = self;

#define KBolckSelf  __block typeof (self)blockSelf = self;

//获取系统版本
#define KIosVersion [[[UIDevice currentDevice] systemVersion] floatValue]


/**
 *  1 判断是否为3.5inch      320*480
 */
#define KScreen35 ([UIScreen mainScreen].bounds.size.height == 480)
/**
 *  2 判断是否为4inch        640*1136
 */
#define KScreen4 ([UIScreen mainScreen].bounds.size.height == 568)
/**
 *  3 判断是否为4.7inch   375*667   750*1334
 */
#define KScreen47 ([UIScreen mainScreen].bounds.size.height == 667)
/**
 *  4 判断是否为5.5inch   414*1104   1242*2208
 */
#define KScreen55 ([UIScreen mainScreen].bounds.size.height == 736)

// iPhone X  812pt x 375pt
#define KIsIphoneX ([UIScreen mainScreen].bounds.size.height == 812)

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"文件：%s\n行数:%d\n内容：%s\n\n\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) fprintf(stderr,"文件：%s\n行数:%d\n内容：%s\n\n\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif



//单例
#define SingletonH(name) + (instancetype)shared##name;
#define SingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone { \
return _instance; \
}



//忽略performSelector警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



#endif /* Macros_h */
