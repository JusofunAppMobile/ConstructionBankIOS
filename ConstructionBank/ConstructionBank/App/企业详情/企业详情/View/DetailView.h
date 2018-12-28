//
//  DetailView.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/30.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailGridCell.h"
#import "CompanyDetailModel.h"
#import "ItemModel.h"


@protocol DetailViewDelegate <NSObject>

-(void)gridButtonClick:(ItemModel*)model cellSection:(int)section;
-(void)CompanyUrl:(NSString*)urlStr;
-(void)companyAdress;
-(void)recordBtnClick;

@end


@interface DetailView : UIView<UITableViewDelegate,UITableViewDataSource,DetailGridDelegate>

@property(nonatomic,assign)id<DetailViewDelegate>delegate;

@property(nonatomic,strong)UITableView *backTableView;

@property(nonatomic,strong)CompanyDetailModel *detailModel;

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end
