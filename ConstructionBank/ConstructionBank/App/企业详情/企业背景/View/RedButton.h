//
//  RedButton.h
//  jusfounData
//
//  Created by clj on 15/7/16.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedButton : UIButton

+(RedButton *)btnWithFrame:(CGRect)frame title:(NSString *)title taeget:(id)target action:(SEL)sel;


//创建任意按钮
+(RedButton *)createAnybtnWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel andBackGroudColor:(UIColor *)backgroundColor andTextColor:(UIColor *)textColor;


/*
 *为了让button的图片和文字居中垂直显示
 *
 */

-(void)centerImageAndTitle;
-(void)centerImageAndTitle:(float)space;

@end
