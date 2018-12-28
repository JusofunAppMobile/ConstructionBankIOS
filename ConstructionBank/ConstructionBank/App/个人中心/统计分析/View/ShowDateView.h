//
//  ShowDateView.h
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIButton+LXMImagePosition.h>
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import "DatePickerView.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ShowDateDelegate <NSObject>

-(void)chooseDateStartDayStr:(NSString *)startDayStr endDayStr:(NSString *)endDayStr;

@end

@interface ShowDateView : UIView<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,assign)id<ShowDateDelegate>delegate;






@property (nonatomic ,strong) UITextField *startField;
@property (nonatomic ,strong) UITextField *endField;

@property (nonatomic ,strong) NSString *startDayStr;
@property (nonatomic ,strong) NSString *endDayStr;



@end

NS_ASSUME_NONNULL_END
