//
//  CommonWebView.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//


#import "BasicViewController.h"
#import "DLPanableWebView.h"
#import "BasicWebViewController.h"

typedef NS_ENUM(NSInteger, WebType) {
    ADType = 1,//启动广告
    imageType = 2 ,//轮播图
    newsType = 3,//热门资讯
    otherType,//其他类型
};//网页类型


@interface CommonWebViewController : BasicWebViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,DLPanableWebViewHandler>

@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *urlStr;

@property (nonatomic,strong) NSString *descStr;//分享的描述

@property (nonatomic,assign) BOOL isNeedShare;//是否有分享功能

@property (nonatomic,assign)WebType webType;//网页类型

@property(nonatomic,strong)NSDictionary *dataDic;

@end
