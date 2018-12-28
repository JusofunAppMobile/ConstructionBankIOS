//
//  ZJDatePickerView.h
//  ZJKitTool
//
//  Created by 邓志坚 on 2018/7/4.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "ZJPickBaseView.h"



typedef void(^ZJDateResultBlock)(NSString *selectValue);
typedef void(^ZJDateCancelBlock)(void);

typedef enum : NSUInteger {
    ZJDatePickerModelDay,
    ZJDatePickerModelTime,
    ZJDatePickerModelNoon,
} ZJDatePickerModel;

@interface ZJDatePickerView : ZJPickBaseView



/**
 显示时间选择器（支持 设置自动选择、最大值、最小值、取消选择的回调）
 
 @param title    标题
 @param defaultSelValue 默认值
 @param minDate 时间最小值
 @param maxDate 时间最大值
 @param isAutoSelect 是否自动选择
 @param resultBlock 确认回调
 @param cancelBlock 取消回调
 */
+ (void)zj_showDatePickerWithTitle:(NSString *)title
                         dateModel:(ZJDatePickerModel)model
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                       resultBlock:(ZJDateResultBlock)resultBlock
                       cancelBlock:(ZJDateCancelBlock)cancelBlock;


@end
