//
//  BasicWebVIewController.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/18.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "BasicWebViewController.h"

@implementation BasicWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar fs_setBackgroundColor:KNavigationBarBackGroundColor];
    [self setBackBtn:@"back"];
    [self setNavigationBarTitle:self.titleName andTextColor:KRGB(51, 51, 51)];
    
    self.webView = [[DLPanableWebView alloc]init];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view from its nib.
   
    
}
-(void)requestUrl:(NSString *)url{
    NSString *md5str = Md5Encryption;
    if (url.length >= md5str.length) {
        NSString *demoStr = [url substringWithRange:NSMakeRange(0, md5str.length)];
        if ([demoStr isEqualToString:md5str]) {
            NSString *appendStr = [url substringFromIndex:md5str.length];
            if (appendStr.length > 8) {
                //自定义H5方法名
                if (appendStr.length > @"?fnName=".length) {
                    NSString *newChange = [appendStr substringFromIndex:@"?fnName=".length];
                    [self signInWithJs:newChange];
                }else{
                    [self signInWithJs:@"encryption"];
                }
            }else{
                //默认H5方法名
                [self signInWithJs:@"encryption"];
            }
        }
    }
}
#pragma mark - 加密
- (void)signInWithJs:(NSString *)type{
    NSDate *Date = [[NSDate alloc]init];
    Date = [Tools GetCurrentTime];
    NSString *timer = [NSString stringWithFormat:@"%d",(int)[Tools GetCurrentTimeStamp:Date]];
    NSString *whash;
#warning  =================
//    if([HOSTURL rangeOfString:@"api_qixinbao"].location !=NSNotFound)//存在就是线上预上线
//    {
       whash= [JAddField releaseAddField:Date] ;
//    }
//    else//不存在就是线下
//    {
//        whash= [JAddField debugAddField:Date];
//    }
    

    NSString* js = [NSString stringWithFormat:@"%@('%@','%@');",type,timer, whash];
    
    NSString* strTemp = [self.webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"strTemp :%@",strTemp);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Add customize http headers in UIWebView request
    if([request isKindOfClass:[NSMutableURLRequest class]]) {
        
        NSMutableURLRequest * mRequest = (NSMutableURLRequest *)request;
        [mRequest setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"Version"];
        [mRequest setValue:@"1" forHTTPHeaderField:@"AppType"];
        [mRequest setValue:@"AppStore" forHTTPHeaderField:@"Channel"];
        [mRequest setValue:[UIDevice currentDevice].identifierForVendor.UUIDString forHTTPHeaderField:@"Deviceid"];
    }
    NSString *urlStr = request.URL.absoluteString;
    [self requestUrl:urlStr];
    return YES;

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadDataAnimation];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadDataAnimation];
//    NSString *js = @"document.documentElement.innerHTML";
//    NSString *html = [webView stringByEvaluatingJavaScriptFromString:js];
//    NSLog(@"%@",html);
}

-(void)loadWithUrl:(NSString *)strUrl
{
    //    strUrl = [NSString stringWithFormat:@"%@%@",[Constant_Url hostUrl],strUrl];
    //    NSString  *urlString = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSURL*url=[NSURL URLWithString:urlString];
    //    NSURLRequest*request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    //    [(DLPanableWebView *)self.view loadRequest:request];
    
}

@end
