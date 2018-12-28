//
//  PushMessageCell.h
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MsgListModel;

@interface PushMessageCell : UITableViewCell


@property(nonatomic,assign)PushMessageType pushMessageType;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIView *companyView;
@property(nonatomic,strong)UILabel *companyLabel;
@property(nonatomic,strong)UIView *kuangView;
@property (nonatomic ,strong) MsgListModel *model;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(PushMessageType)type;

@end
