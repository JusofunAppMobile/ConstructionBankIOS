//
//  UIView+BorderLine.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/15.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BorderLine)

- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

@end
