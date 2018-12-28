//
//  UIColor+Tool.h
//  GiftExchange
//
//  Created by JUSFOUN on 2017/8/8.
//  Copyright © 2017年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tool)
//根据16进制颜色值返回UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

//根据16进制颜色值返回UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert alpha:(CGFloat)alpha;

//根据颜色值返回一张纯色图片
+(UIImage *)ImageFromColor:(UIColor *)color frame:(CGRect)frame;
@end
