//
//  UILabel+Placeholder.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UILabel+Placeholder.h"

//static const char key = '\0';

@implementation UILabel (Placeholder)


#pragma mark - Swizzle Dealloc
//+ (void)load {
//    // is this the best solution?
//    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
//                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
//}
//
//- (void)swizzledDealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
//    if (label) {
//        for (NSString *key in self.class.observingKeys) {
//            @try {
//                [self removeObserver:self forKeyPath:key];
//            }
//            @catch (NSException *exception) {
//                // Do nothing
//            }
//        }
//    }
//    [self swizzledDealloc];
//}
//
//
//
//+ (NSArray *)observingKeys {
//    return @[@"bounds",
//             @"font",
//             @"frame",
//             @"text",
//             @"textAlignment"];
//}
//
//#pragma mark - Properties
//#pragma mark `placeholderLabel`
//
//- (UILabel *)placeholderLabel{
//
//    UILabel *label = objc_getAssociatedObject(self, &key);
//
//    if (!label) {
//        label = [[UILabel alloc]init];
//        label.textColor = [UIColor redColor];
//        label.numberOfLines = 0;
//        objc_setAssociatedObject(self, &key, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//        self.needsUpdateFont = YES;
//        [self updatePlaceholderLabel];
//        self.needsUpdateFont = NO;
//    }
//    return label;
//}
//
//#pragma mark `placeholder`
//- (NSString *)placeholder {
//    return self.placeholderLabel.text;
//}
//
//- (void)setPlaceholder:(NSString *)placeholder {
//    self.placeholderLabel.text = placeholder;
//    [self updatePlaceholderLabel];
//}
//
//
//#pragma mark `placeholderColor`
//
//- (UIColor *)placeholderColor {
//    return self.placeholderLabel.textColor;
//}
//
//- (void)setPlaceholderColor:(UIColor *)placeholderColor {
//    self.placeholderLabel.textColor = placeholderColor;
//}
//
//#pragma mark `needsUpdateFont`
//- (BOOL)needsUpdateFont {
//    return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
//}
//
//- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
//    objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//#pragma mark - Update
//- (void)updatePlaceholderLabel{
//    if (self.text.length) {
//        [self.placeholderLabel removeFromSuperview];
//        return;
//    }
//
//    [self insertSubview:self.placeholderLabel atIndex:0];
//
//    if (self.needsUpdateFont) {
//        self.placeholderLabel.font = self.font;
//        self.needsUpdateFont = NO;
//    }
//    self.placeholderLabel.textAlignment = self.textAlignment;
//
//    self.placeholderLabel.frame = self.bounds;
//
//}

@end
