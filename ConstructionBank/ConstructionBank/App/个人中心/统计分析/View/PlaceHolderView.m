//
//  PlaceHolderView.m
//  VocationalEdu
//
//  Created by WangZhipeng on 2018/12/8.
//  Copyright © 2018年 WangZhipeng. All rights reserved.
//

#import "PlaceHolderView.h"

@implementation PlaceHolderView
{
    YYLabel *label;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        label = [[YYLabel alloc]initWithFrame:KFrame(0, 0, self.width, self.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无数据";
        label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = KFont(16);
        
        
        [self addSubview:label];
    }
    return self;
}

-(void)layoutSubviews{
    label.frame = KFrame(0, 0, self.width, self.height);
}


-(void)remove
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}





@end
