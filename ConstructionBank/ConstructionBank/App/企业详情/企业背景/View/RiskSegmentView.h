//
//  RiskSegmentView.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RiskSegmentDelegate <NSObject>

- (void)didSelectBarAtIndex:(NSInteger)index;

@end

@interface RiskSegmentView : UIView

@property (nonatomic ,strong) NSArray *tabList;

@property (nonatomic ,weak) id <RiskSegmentDelegate>delegate;

@end
