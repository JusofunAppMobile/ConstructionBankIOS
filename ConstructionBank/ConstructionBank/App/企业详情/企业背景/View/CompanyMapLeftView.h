//
//  CompanyMapLeftView.h
//  jusfounData
//
//  Created by clj on 15/10/22.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyMapLeftViewDelegate <NSObject>

-(void)buttonClick:(NSString *)text withCompanyDic:(NSDictionary *)compDic;

-(void)close;
@end

@interface CompanyMapLeftView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) id<CompanyMapLeftViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame withIschild:(BOOL)isChrild andIsFold:(BOOL)isFold andIsShareHold:(BOOL)isShareHold andDicInfo:(NSDictionary *)dicInfo;



@end
