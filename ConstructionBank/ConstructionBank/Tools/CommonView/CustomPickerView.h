//
//  CustomPickerView.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerView : UIView

typedef void(^ResultBlock)(id result);

- (void)show;
- (void)dismiss;
- (instancetype)initWithTitles:(NSArray *)titleArr resultBlock:(ResultBlock)resultBlock;
- (instancetype)initWithDicArray:(NSArray *)dicArray keyName:(NSString*)keyName resultBlock:(ResultBlock)resultBlock;
@end
