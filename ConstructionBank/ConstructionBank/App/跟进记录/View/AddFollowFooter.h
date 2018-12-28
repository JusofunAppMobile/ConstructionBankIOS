//
//  AddFollowFooter.h
//  ConstructionBank
//
//  Created by wzh on 2018/12/23.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddFollowFooterDelegate <NSObject>

- (void)didClickCheckbox:(BOOL)check section:(NSInteger)section;
@end

@interface AddFollowFooter : UIView
@property(nonatomic ,weak)id<AddFollowFooterDelegate>delegate;
@property(nonatomic ,assign) NSInteger section;
- (void)setContent:(NSMutableDictionary *)content section:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
