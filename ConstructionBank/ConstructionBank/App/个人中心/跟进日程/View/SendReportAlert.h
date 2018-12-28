//
//  SendReportAlert.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/12/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendReportDelegate <NSObject>

- (void)textFieldDidSelectAtIndex:(NSInteger)index;
- (void)sendReportAction:(NSDictionary *)params;

@end

@interface SendReportAlert : UIView
@property (nonatomic ,weak) id <SendReportDelegate>delegate;
@property (nonatomic ,strong) UITextField *startField;
@property (nonatomic ,strong) UITextField *endField;
- (void)showInView:(UIView *)view;
@end
