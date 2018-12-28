//
//  CompanyListCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyListDelegate <NSObject>
- (void)jumpToFollowRecordVC:(NSString *)companyId;
- (void)jumpToMessagePushVC:(NSString *)companyId;
- (void)clinetMark:(NSString *)companyId;
@end

@class CompanyListModel;

@interface CompanyListCell : UITableViewCell

@property (nonatomic ,weak) id <CompanyListDelegate>delegate;
@property (nonatomic ,strong) CompanyListModel *model;

@end
