//
//  DetailWebController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/9/21.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DetailWebController.h"

@interface DetailWebController ()

@end

@implementation DetailWebController
@synthesize titleName = _titleName;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackBtn:@"back"];
    [self setNavigationBarTitle:self.titleName andTextColor:KRGB(51, 51, 51)];
   // self.webView.frame = self.view.frame;
    self.webView.frame = KFrame(0, 0, KDeviceW, KDeviceH-KNavigationBarHeight);
    [self loadWithUrl];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KNavigationBarBackGroundColor];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadDataAnimation];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadDataAnimation];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadDataAnimation];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString *URLStr =[self URLDecodedString: [[request URL] absoluteString]];
    if (URLStr.length >= Md5Encryption.length) {
        NSString *demoStr = [URLStr substringWithRange:NSMakeRange(0, Md5Encryption.length)];
        if ([demoStr isEqualToString:Md5Encryption]) {
            return NO;
        }
    }
    
    NSString *str = @"companyinfo://";
    NSString *idStr;
    NSString *nameStr;
    
    if([URLStr rangeOfString:str].location != NSNotFound)
    {
        NSString *appendStr = [URLStr substringFromIndex:str.length];
        NSArray *strArray = [appendStr componentsSeparatedByString:@"&"];
        if(strArray.count >0)
        {
            NSString *str1 = [strArray objectAtIndex:0];
            if(str1.length >0)
            {
                NSString *str2 = @"id=";
                idStr = [str1 substringFromIndex:str2.length];
            }
        }
        if(strArray.count >1)
        {
            NSString *str1 = [strArray objectAtIndex:1];
            if(str1.length >0)
            {
                NSString *str2 = @"name=";
                nameStr = [str1 substringFromIndex:str2.length];
            }
        }
        CompanyDetailController *comView = [[CompanyDetailController alloc] init];
        comView.companyId = idStr;
        comView.companyName = nameStr;
        [self.navigationController pushViewController:comView animated:YES];
        return  NO;
    }
    else if ([URLStr containsString:@"shareholder://info?"]){
        
        NSDictionary *dic = [Tools stringChangeToDictionary:URLStr separatStr:@"shareholder://info?"];
        
        if ([dic[@"shareholdertype"] intValue] == 2) {//1个人2企业
            CompanyDetailController *vc = [CompanyDetailController new];
            vc.companyId = dic[@"companyid"];
            vc.companyName = dic[@"name"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        else if ([dic[@"shareholdertype"] intValue] == 1)
//        {
//            
//            SearchResultController *SearchVc = [[SearchResultController alloc]init];
//            SearchVc.popType = PopNormal;
//            SearchVc.btnTitile = dic[@"name"];
//            SearchVc.searchType = ShareholderType;
//            [self.navigationController pushViewController:SearchVc animated:YES];
//        }
        
        return  NO;
    }
    else
    {
        if([URLStr rangeOfString:@"http://"].location != NSNotFound || [URLStr rangeOfString:@"https://"].location != NSNotFound || [URLStr rangeOfString:@"www"].location != NSNotFound)
        {
            return YES;
        }else
        {
            return  NO;
        }
    }
    
}

-(NSString *)URLDecodedString:(NSString*)stringURL
{
    return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)stringURL,CFSTR(""),kCFStringEncodingUTF8);
}






-(void)loadWithUrl
{
    NSString *urlStr = [self.url stringByReplacingOccurrencesOfString:@" " withString:@""];
    urlStr = [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL*url=[NSURL URLWithString:urlStr];
    NSURLRequest*request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.webView loadRequest:request];
    
}




//点击返回
-(void)back
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
}

//右滑返回
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if (![self.webView canGoBack]) {
            return YES;
        }else{
            return NO;
        }
    }else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]&& [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
        
        return YES;
    }else{
        return  NO;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
