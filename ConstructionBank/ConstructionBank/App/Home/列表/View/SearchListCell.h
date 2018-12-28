//
//  SearchListCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/8.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchListDelegate <NSObject>
- (void)jumpToFollowRecordVC:(NSString *)companyId;
- (void)jumpToMessagePushVC:(NSString *)companyId;
- (void)clinetMark:(NSString *)companyId;
@end

@class AnnoListModel;

@interface SearchListCell : UITableViewCell
@property (nonatomic ,weak) id <SearchListDelegate>delegate;
@property (nonatomic ,strong) AnnoListModel *model;
//- (void)setModel:(AnnoListModel *)model companyType:(NSInteger)type;

@end
