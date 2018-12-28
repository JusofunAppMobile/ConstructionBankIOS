//
//  DetailBasicController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicWebViewController.h"
#import "ItemView.h"
#import "DetailWebBasicController.h"
#import <UIButton+LXMImagePosition.h>
@interface DetailBasicController : BasicViewController<ItemViewDelegate,UIWebViewDelegate>

@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;

@property(nonatomic,strong)ItemView *itemView;


/**
 下拉选项
 */
@property(nonatomic,strong)NSArray *itemArray;


/**
 navigationBar展开关闭按钮
 */
@property(nonatomic,strong)UIButton *titleButton;



/**
 navigationBar 箭头
 */
@property(nonatomic,strong)UIImageView* titleImageView;

/**
 navigationBar title
 */
@property(nonatomic,copy)NSString* saveTitleStr;

@property(nonatomic,assign)BOOL isWebViewPush;

@property (nonatomic ,strong) UIViewController *currentVc;



- (void)displayViewController:(UIViewController *)controller;

- (void)hideViewController:(UIViewController *)controller;

-(void)setTitleView;

-(void)showItemView;
-(void)back;

-(void)setDetailNavigationBarTitle:(NSString*)titleStr;


@end
