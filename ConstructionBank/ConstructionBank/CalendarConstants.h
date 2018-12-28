//
//  CalendarConstants.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#ifndef CalendarConstants_h
#define CalendarConstants_h
/*------------------------------视图大小位置------------------------------*/

// 屏幕尺寸
#define kScreen_WIDTH [UIScreen mainScreen].bounds.size.width
#define kScreen_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREEN_RATIO (kScreen_WIDTH/375)

// iPhone机型
#define IS_iPhone5s_Before ((kScreen_WIDTH == 320) ? YES : NO)
#define IS_iPhone6s_Later ((kScreen_WIDTH == 375) ? YES : NO)
#define IS_iPhone6sPlus_Later ((kScreen_WIDTH == 414) ? YES : NO)
#define IS_iPhoneX ((kScreen_WIDTH == 375 && kScreen_HEIGHT == 812) ? YES : NO)

// iPhone版本
#define IS_iOS11_Later (([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) ? YES : NO)

// 系统性参数
#define SYS_StatusBar_HEIGHT ((!IS_iPhoneX) ? 20 : SYS_SafeArea_TOP)
#define SYS_NavigationBar_HEIGHT (SYS_StatusBar_HEIGHT+44)
#define SYS_Toolbar_HEIGHT 44
#define SYS_TabBar_HEIGHT ((!IS_iPhoneX) ? 49 : (49+SYS_SafeArea_BOTTOM))
#define SYS_Spacing_HEIGHT 8

#define SYS_SafeArea_TOP ((IS_iPhoneX) ? 44 : 0)
#define SYS_SafeArea_BOTTOM ((IS_iPhoneX) ? 34 : 0)

// 最小间隔
#define minimumSpacing 10


/*------------------------------字体、颜色------------------------------*/

// 系统颜色
#define SYS_Black_Color [UIColor blackColor]
#define SYS_DarkGray_Color [UIColor darkGrayColor]
#define SYS_LightGray_Color [UIColor lightGrayColor]
#define SYS_White_Color [UIColor whiteColor]
#define SYS_Gray_Color [UIColor grayColor]
#define SYS_Red_Color [UIColor redColor]
#define SYS_Green_Color [UIColor greenColor]
#define SYS_Blue_Color [UIColor blueColor]
#define SYS_Cyan_Color [UIColor cyanColor]
#define SYS_Yellow_Color [UIColor yellowColor]
#define SYS_Magenta_Color [UIColor magentaColor]
#define SYS_Orange_Color [UIColor orangeColor]
#define SYS_Purple_Color [UIColor purpleColor]
#define SYS_Brown_Color [UIColor brownColor]
#define SYS_Clear_Color [UIColor clearColor]
#define SYS_Random_Color [UIColor randomColor]

// 字体
#define AppFont(x) [UIFont systemFontOfSize:x]
#define AppBoldFont(x) [UIFont boldSystemFontOfSize:x]

// 颜色
#define AppColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define AppAlphaColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define AppHTMLColor(html) [UIColor colorWithHexString:html]


/*------------------------------图片------------------------------*/

#define ImageNamed(name) [UIImage imageNamed:name]
#define URLWithString(url) [NSURL URLWithString:url]


/*------------------------------其它------------------------------*/

#import "UIColor+LX.h"
#import "UIImage+LX.h"

// tag基数
#define BASE_TAG 100

// tableView注册
#define RegisterClass_for_Cell(tableViewCell) [self.tableView registerClass:[tableViewCell class] forCellReuseIdentifier:NSStringFromClass([tableViewCell class])]
#define RegisterClass_for_HeaderFooterView(tableViewHeaderFooterView) [self.tableView registerClass:[tableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([tableViewHeaderFooterView class])]
#define RegisterNib_for_Cell(tableViewCell) [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([tableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([tableViewCell class])]
#define RegisterNib_for_HeaderFooterView(tableViewHeaderFooterView) [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([tableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([tableViewCell class])]

// tableView出列
#define DequeueReusable_Cell [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])]
#define DequeueReusable_HeaderFooterView [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([self class])]


#endif /* CalendarConstants_h */
