//
//  MyClientCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/12.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyClientModel;

@protocol MyClientCellDelegate <NSObject>
- (void)jumpToFollowRecordVC:(NSString *)companyId;
- (void)jumpToMessagePushVC:(NSString *)companyId;
@end


@interface MyClientCell : UITableViewCell

@property (nonatomic ,weak) id <MyClientCellDelegate>delegate;
@property (nonatomic ,strong) MyClientModel *model;

//- (void)setModel:(MyClientModel *)model companyType:(NSInteger)type;

@end
