//
//  JAddField.h
//  jusfounCore
//
//  Created by WangZhipeng on 2018/3/23.
//  Copyright © 2018年 jusfoun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JAddField : NSObject

+(NSString *)debugAddField:(NSDate *)time;
+(NSString *)releaseAddField:(NSDate *)time;
+(NSDate *)convertHeaderDateToNSDate:(NSString *)headerdate;


@end
