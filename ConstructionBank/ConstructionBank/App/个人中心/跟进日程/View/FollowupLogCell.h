//
//  FollowupLogCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowRecordModel.h"


@protocol FollowupLogCellDelegate <NSObject>

- (void)didClickClose:(NSIndexPath *)indexPath;

- (void)jumpToEditVc:(FollowRecordModel *)model;

@end

@interface FollowupLogCell : UITableViewCell

@property (nonatomic ,weak) id <FollowupLogCellDelegate>delegate;

- (void)setModel:(FollowRecordModel *)model atIndex:(NSIndexPath *)indexPath;
@end
