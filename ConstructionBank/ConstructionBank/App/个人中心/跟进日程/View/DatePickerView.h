//
//  DatePickerView.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/20.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "ZJPickBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ZJDateResultBlock)(NSString *selectValue);
typedef void(^ZJDateCancelBlock)(void);
@interface DatePickerView : ZJPickBaseView

+ (void)showDatePickerWithTitle:(NSString *)title
                        minDate:( NSDate * _Nullable )minDate
                        maxDate:( NSDate * _Nullable )maxDate
                    resultBlock:(ZJDateResultBlock)resultBlock
                    cancelBlock:(ZJDateCancelBlock)cancelBlock;

+ (void)showDatePickerWithTitle:(NSString *)title
                        minDate:( NSDate * _Nullable )minDate
                        maxDate:( NSDate * _Nullable )maxDate
                   defaultValue:(NSString *)defaultValue
                    resultBlock:(ZJDateResultBlock)resultBlock
                    cancelBlock:(ZJDateCancelBlock)cancelBlock;

//
//- (instancetype)initWithWithTitle:(NSString *)title
//                          minDate:(NSDate *)minDate
//                          maxDate:(NSDate *)maxDate
//                      resultBlock:(ZJDateResultBlock)resultBlock
//                      cancelBlock:(ZJDateCancelBlock)cancelBlock;
//
//- (void)show;

@end

NS_ASSUME_NONNULL_END
