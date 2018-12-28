//
//  HistoryMsgCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MsgListModel;
@protocol HistoryCellDelegate <NSObject>

- (void)didClickCopyButton:(NSString *)text;

@end

@interface HistoryMsgCell : UITableViewCell

@property (nonatomic ,weak) id <HistoryCellDelegate>delegate;
@property (nonatomic ,strong) UILabel *contentLab;
@property (nonatomic ,strong) MsgListModel *model;

@end
