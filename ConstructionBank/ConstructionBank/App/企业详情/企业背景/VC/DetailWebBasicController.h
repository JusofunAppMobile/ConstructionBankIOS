//
//  DetailWebBasicController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicWebViewController.h"
#import "RiskSegmentView.h"
#import "TabListModel.h"


@protocol DetailWebBasicDelegate <NSObject>

@optional
-(void)detailWebPush:(NSString*)title;

-(void)detailWebPop;

@end


@interface DetailWebBasicController : BasicWebViewController<RiskSegmentDelegate>

@property(nonatomic,assign)id<DetailWebBasicDelegate>detailWebBasicDelegate;

@property (nonatomic ,strong) RiskSegmentView *segment;

@end
