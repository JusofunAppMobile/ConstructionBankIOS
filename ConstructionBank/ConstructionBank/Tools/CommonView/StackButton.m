//
//  StackButton.m
//  SimpleDecision
//
//  Created by WangZhipeng on 17/3/2.
//  Copyright © 2017年 jusfoun. All rights reserved.
//

#import "StackButton.h"

@implementation StackButton

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y =  (CGRectGetHeight(self.frame) - CGRectGetHeight(self.imageView.frame)-CGRectGetHeight(self.titleLabel.frame))/2+CGRectGetHeight(self.imageView.frame)/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
@end
