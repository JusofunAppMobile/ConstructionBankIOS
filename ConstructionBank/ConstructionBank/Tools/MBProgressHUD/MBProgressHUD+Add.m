//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.labelFont = [UIFont boldSystemFontOfSize:14];
    hud.yOffset = -30;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
    
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    
   
    if (view == nil)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    
    return hud;
}



#pragma mark 显示一些信息 没有转圈
+ (void)showHint:(NSString *)hint toView:(UIView *)view;
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
    //显示提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    //hud.yOffset = ([UIScreen mainScreen].bounds.size.height-64)/2.0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

#pragma mark 隐藏hud
+(void)hideHudToView:(UIView *)view animated:(BOOL)animated
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDForView:view animated:animated];

}



@end
