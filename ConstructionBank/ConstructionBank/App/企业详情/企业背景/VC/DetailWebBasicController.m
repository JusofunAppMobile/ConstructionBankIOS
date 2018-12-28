//
//  DetailWebBasicController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DetailWebBasicController.h"
#import "CompanyDetailController.h"
#import "DetailWebController.h"

@interface DetailWebBasicController ()

@end

@implementation DetailWebBasicController
@synthesize itemModel = _itemModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWebView];
   // [self webViewLoadUrlStr:self.itemModel.applinkurl];
}

#pragma mark - webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
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
    if ([URLStr rangeOfString:@"nbxx_detail"].location != NSNotFound)
    {
        [self pushToDetailWithUrl:URLStr titleName:@"年报详情"];
        return NO;
        
    }else if([URLStr rangeOfString:@"qyzx_detail"].location != NSNotFound)
    {
        [self pushToDetailWithUrl:URLStr titleName:@"资讯详情"];
        return NO;
        
    }else if([URLStr rangeOfString:@"QueryResult"].location != NSNotFound)
    {

        [self pushToDetailWithUrl:URLStr titleName:@"失信详情"];
        return NO;
    }
    else if ([URLStr rangeOfString:@"details://company?"].location != NSNotFound)
    {
        NSDictionary *dic = [Tools stringChangeToDictionary:URLStr separatStr:@"details://company?"];
        [self pushToDetailWithUrl:[dic objectForKey:@"url"] titleName:[dic objectForKey:@"title"]];
        
        return NO;
    }else if ([URLStr containsString:@"shareholder://info?"]){
        
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
    
    else if ([URLStr rangeOfString:HOSTURL].location == NSNotFound)
    {
        
    }
    else{
        
//        if(self.detailWebBasicDelegate && [self.detailWebBasicDelegate respondsToSelector:@selector(detailWebPop)])
//        {
//            [self.detailWebBasicDelegate detailWebPop];
//        }
        
       
      
    }
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


-(void)pushToDetailWithUrl:(NSString*)url titleName:(NSString*)nameStr
{
    DetailWebController *vc = [[DetailWebController alloc]init];
    vc.url = url;
    vc.titleName = nameStr;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)setItemModel:(ItemModel *)itemModel
{
    _itemModel = itemModel;
}


-(void)webViewLoadUrlStr:(NSString*)urlstr
{
    NSString  *urlString = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL*url=[NSURL URLWithString:urlString];
    NSURLRequest*request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.webView loadRequest:request];
}


-(void)setWebView
{
    if ([_itemModel.type intValue] ==1) {
        self.webView.frame = KFrame(0, 0, KDeviceW, KDeviceH-KNavigationBarHeight);
        [self webViewLoadUrlStr:_itemModel.applinkurl];
    }else if([_itemModel.type intValue] ==5 &&[_itemModel.tablist count]){

        self.webView.frame  = KFrame(0, 40, KDeviceW, KDeviceH - KNavigationBarHeight -40);
        [self.view addSubview:self.segment];
        //[self didSelectBarAtIndex:0];//默认展示第一个，可能有bug
    }
    
    self.webView.enablePanGesture = YES;
}

#pragma mark 切换tab
- (void)didSelectBarAtIndex:(NSInteger)index{
    TabListModel *model = _itemModel.tablist[index];
    [self webViewLoadUrlStr:model.url];
}

#pragma mark lazy load
- (RiskSegmentView *)segment{
    if (!_segment) {
        _segment = [[RiskSegmentView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 40)];
        _segment.delegate = self;
        _segment.tabList = [_itemModel.tablist copy];
    }
    return _segment;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
