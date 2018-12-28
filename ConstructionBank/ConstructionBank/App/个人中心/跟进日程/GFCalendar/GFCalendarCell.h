//
//  GFCalendarCell.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayModel.h"

typedef enum : NSUInteger {
    DayTypeOtherMonth,
    DayTypeThisMonth,
    DayTypeToday,
} DayType;

@interface GFCalendarCell : UICollectionViewCell

@property (nonatomic, strong) UIView *todayCircle; //!< 标示'今天'
@property (nonatomic, strong) UILabel *todayLabel; //!< 标示日期（几号）
@property (nonatomic ,assign) DayType dayType;
@property (nonatomic ,strong) CalendarDayModel *model;
@end
