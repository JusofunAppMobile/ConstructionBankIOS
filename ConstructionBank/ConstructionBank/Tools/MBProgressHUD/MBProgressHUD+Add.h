//
//  MBProgressHUD+Add.h
//
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <MBProgressHUD.h>

@interface MBProgressHUD (Add)

/**
 *  展示错误信息，一秒后消失
 *
 *  @param error 错误信息
 *  @param view  假如view为nil，默认显示keywindow
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  展示成功信息，一秒后消失
 *
 *  @param success 成功信息
 *  @param view    假如view为nil，默认显示keywindow
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  展示信息，带转圈，不会自动消失
 *
 *  @param message 信息
 *  @param view    假如view为nil，默认显示keywindow
 *
 *  @return HUD
 */
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;


/**
 *  显示一个提示消息，1秒之后再消失
 *
 *  @param hint 要提示的信息
 *  @param view 假如view为nil，默认显示keywindow
 */
+ (void)showHint:(NSString *)hint toView:(UIView *)view;

/**
 *  隐藏界面
 *
 *  @param view 假如view为nil，默认显示keywindow
 */
+(void)hideHudToView:(UIView *)view animated:(BOOL)animated;

@end
