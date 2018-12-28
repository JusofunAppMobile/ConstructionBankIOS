//
//  GFCalendarScrollView.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayModel.h"

typedef void (^DidSelectDayHandler)(NSInteger year, NSInteger month, NSInteger day ,CalendarDayModel *model);

@interface GFCalendarScrollView : UIScrollView


@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler; // 日期点击回调

@property (nonatomic, strong) NSDate *currentMonthDate;

@property (nonatomic ,strong) NSArray *datelist;

@property (nonatomic ,strong) NSString *selectedDay;

- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份

@end
