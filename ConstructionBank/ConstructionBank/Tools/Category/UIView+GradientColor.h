//
//  UIView+GradientColor.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GradientColor)
- (void)setGradientColor:(NSArray *)colors locations:(NSArray<NSNumber *>*)locations;
- (void)clearGradientColor;
@end
