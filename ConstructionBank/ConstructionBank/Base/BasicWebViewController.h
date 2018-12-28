//
//  BasicWebVIewController.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/18.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "DLPanableWebView.h"

@interface BasicWebViewController : BasicViewController<DLPanableWebViewHandler,UIWebViewDelegate>

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) DLPanableWebView *webView;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;


@end
