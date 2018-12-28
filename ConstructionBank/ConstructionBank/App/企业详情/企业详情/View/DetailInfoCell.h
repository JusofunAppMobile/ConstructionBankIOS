//
//  DetailInfoCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackButton.h"
#import "CompanyDetailModel.h"




@interface DetailInfoCell : UITableViewCell

@property(nonatomic,strong)CompanyDetailModel *detailModel;
/**
 公司名字
 */
@property(nonatomic,strong)UILabel *nameLabel;


/**
 公司性质
 */
@property(nonatomic,strong)UILabel*natureLabel;

/**
 公司税号
 */
@property(nonatomic,strong)UILabel*dutyLabel;



/**
 法定代表人
 */
@property(nonatomic,strong)UILabel*pepleLabel;



/**
 注册资金
 */
@property(nonatomic,strong)UILabel*moneyLabel;



/**
 成立日期
 */
@property(nonatomic,strong)UILabel*dateLabel;


/**
 登记状态
 */
@property(nonatomic,strong)UILabel*stateLabel;


/**
 刷新按钮
 */
@property(nonatomic,strong)UIButton*refreshBtn;


/**
 关注
 */
@property(nonatomic,strong)UIButton*attentionBtn;
//
///**
// 浏览数量
// */
//@property(nonatomic,strong)StackButton*attentionBtn;
//
///**
// 刷新btn
// */
//@property(nonatomic,strong)StackButton*refreshBtn;






@end
