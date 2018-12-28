//
//  NSNumber+StringValue.m
//  GCarClub
//
//  Created by 海易出行 on 16/9/18.
//  Copyright © 2016年 hycx. All rights reserved.
//

#import "NSNumber+StringValue.h"

@implementation NSNumber (StringValue)

- (NSUInteger)length{
    NSString *strValue = [self stringValue];
    return [strValue length];
}

- (BOOL)isEqualToString:(NSString *)string{
    NSString *strValue = [self stringValue];
    return [strValue isEqualToString:string];
}



@end
