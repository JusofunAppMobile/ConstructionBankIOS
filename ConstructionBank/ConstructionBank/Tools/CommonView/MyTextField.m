//
//  MyTextField.m
//  EnterpriseInquiry
//
//  Created by clj on 15/12/2.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField
//禁用复制粘贴功能
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
if (action == @selector(paste:))//禁止粘贴
    return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return NO;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, self.leftView.maxX+10, 0, 0);
    return UIEdgeInsetsInsetRect(bounds, inset);
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, self.leftView.maxX+10, 0, 0);
    return UIEdgeInsetsInsetRect(bounds, inset);
}
- (CGRect)editingRectForBounds:(CGRect)bounds{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, self.leftView.maxX+10, 0, 0);
    return UIEdgeInsetsInsetRect(bounds, inset);
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x += 15;
    return textRect;
}

@end
