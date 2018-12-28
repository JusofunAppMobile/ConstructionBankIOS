//
//  ContentInsetsLabel.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/26.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "ContentInsetsLabel.h"

@implementation ContentInsetsLabel

- (void)setContentInsets:(UIEdgeInsets)contentInsets{
    _contentInsets = contentInsets;
}

- (CGSize)intrinsicContentSize{
    CGSize size = super.intrinsicContentSize;
    if (size.width>0) {//text不为空
        size.width = size.width+_contentInsets.left+_contentInsets.right;
    }
    if (size.height>0) {
        size.height = size.height+_contentInsets.top+_contentInsets.bottom;
    }
    return size;
}

- (void)drawTextInRect:(CGRect)rect{
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _contentInsets)];
}

@end
