//
//  RedButton.m
//  jusfounData
//
//  Created by clj on 15/7/16.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import "RedButton.h"

@implementation RedButton


+(RedButton *)btnWithFrame:(CGRect)frame title:(NSString *)title taeget:(id)target action:(SEL)sel
{
    return [self createAnybtnWithFrame:frame title:title target:target action:sel andBackGroudColor:[UIColor redColor] andTextColor:[UIColor whiteColor]];
}


+(RedButton *)createAnybtnWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel andBackGroudColor:(UIColor *)backgroundColor andTextColor:(UIColor *)textColor
{
    RedButton *redButton = [self buttonWithType:UIButtonTypeCustom];
    if (redButton) {
        redButton.frame = frame;
        redButton.backgroundColor = backgroundColor ;
        [redButton setTitle:title forState:UIControlStateNormal];
        redButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        redButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        redButton.titleLabel.textColor = textColor;
        [redButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return  redButton;
}



-(void)centerImageAndTitle:(float)space
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight -imageSize.height) +10, 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, - imageSize.width, - (totalHeight - titleSize.height) -5, 0.0);
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}
@end
