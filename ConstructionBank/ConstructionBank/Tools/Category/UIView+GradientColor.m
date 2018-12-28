//
//  UIView+GradientColor.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UIView+GradientColor.h"

const void *myKey = @"myKey";

@implementation UIView (GradientColor)

- (CAGradientLayer *)overlay{
    return objc_getAssociatedObject(self, myKey);
}

- (void)setOverlay:(CAGradientLayer *)layer{
    objc_setAssociatedObject(self, myKey, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setGradientColor:(NSArray *)colors locations:(NSArray<NSNumber *>*)locations{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors =colors;
    gradientLayer.locations = locations;//@[@0.38, @0.67, @0.8f]
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.bounds;
    self.overlay = gradientLayer;
    [self.layer insertSublayer:self.overlay atIndex:0 ];
}

- (void)clearGradientColor{
    if (self.overlay) {
        [self.overlay removeFromSuperlayer];
        self.overlay = nil;
    }
}

@end
