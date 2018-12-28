//
//  DetailGridCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

//搜索的类型
typedef NS_ENUM(NSInteger, DetailInfoType) {
    DetailBackType = 3435,
    DetailRiskType,
    DetailManageType,
    DetailMoneyType
};


@interface GridButton : UIButton

@property(nonatomic,strong)UILabel *counLabel;

@property(nonatomic,strong)NSDictionary*buttonDic;

@end

@protocol DetailGridDelegate <NSObject>

-(void)gridButtonClick:(GridButton*)button cellSection:(int)section;

@end


@interface DetailGridCell : UITableViewCell

@property(nonatomic,assign)id<DetailGridDelegate>detailGridDelegate;


@property(nonatomic,assign)int section;

-(void)setCellData:(NSArray *)dataArray;


@property(nonatomic,assign)DetailInfoType detailInfoType;

@end
