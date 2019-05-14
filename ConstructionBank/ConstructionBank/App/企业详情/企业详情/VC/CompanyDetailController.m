//
//  CompanyDetailController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/30.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CompanyDetailController.h"
#import "DetailView.h"
#import "UINavigationBar+Extention.h"
#import "CommonWebViewController.h"
#import "CompanyDetailModel.h"
#import "BackgroundController.h"
#import "ComMapViewController.h"
#import "FollowUpRecordController.h"
#import "PushMessageController.h"

@interface CompanyDetailController()<DetailViewDelegate>
{
    UITableView *backTableView;
    CompanyDetailModel * detailModel;
    NSMutableArray  *itemList;//菜单列表
    DetailView *detailView;
}
@property (nonatomic ,strong) NSArray *reportTypeList;
@end

@implementation CompanyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarTitle:@"企业信息"];
    [self setBackBtn:@"back"];
    
    [self drawView];
    [self loadCompanyInfo];
}


-(void)drawView{
    detailView = [[DetailView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-KNavigationBarHeight) type:detailModel.type.intValue];
    detailView.delegate = self;
    [self.view addSubview:detailView];
}


#pragma mark - 请求企业信息
-(void)loadCompanyInfo{
    if(!self.companyId)
    {
        self.companyId = @"";
    }
    if(!self.companyName)
    {
        self.companyName = @"";
    }
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSDictionary *locationDic = [KUserDefaults objectForKey:KUserLocationKey];

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:KUSER.userID forKey:@"userId"];
    [paraDic setObject:_companyId forKey:@"companyId"];
    [paraDic setObject:_companyName forKey:@"entName"];

    if (locationDic) {
        [paraDic setObject:locationDic[@"lon"] forKey:@"myLongitude"];
        [paraDic setObject:locationDic[@"lat"] forKey:@"myLatitude"];
    }
    
    [RequestManager encryptRequestWithURLString:GetCompanyDetail parameters:paraDic type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        //        [weakSelf hideLoadDataAnimation];
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"][@"list"]];
        NSArray *tmpArray = [responseObject[@"data"][@"list"] objectForKey:@"subclassMenu"];
        if (![tmpArray isKindOfClass:[NSArray class]]) {
            return ;
        }
        
        NSMutableArray *saveArray = [NSMutableArray arrayWithCapacity:1];
        
        for(NSDictionary *dic in tmpArray){
            int type = [[dic objectForKey:@"type"] intValue];
            for(NSString *detailType in KCompanyDetailGridType){
                if(type == [detailType intValue]){
                    [saveArray addObject:dic];
                    break;
                }
            }
        }
        [tmpDic setObject:saveArray forKey:@"subclassMenu"];
        
        detailModel = [CompanyDetailModel mj_objectWithKeyValues:tmpDic];
        detailModel.companyid = _companyId;
        detailModel.distance = detailModel.distance.floatValue?detailModel.distance:_distance;
        itemList = [NSMutableArray arrayWithArray:detailModel.subclassMenu];
        detailView.detailModel = detailModel;
        if (detailModel.type.intValue ==3) {
            [self setRightBarBtn];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

//标记用户
- (void)clinetMark{
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_companyId forKey:@"entid"];
    [params setObject:KUSER.userID forKey:@"userId"];
    [RequestManager requestWithURLString:KCustomerMark parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"标记成功" toView:self.view];
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

//创建navigaiton上的东西
-(void)setRightBarBtn{
    NSMutableArray *items = [NSMutableArray array];
    if (KIosVersion<11.0) {
        UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                          target:nil action:nil];
        negativeSpace.width = -13;
        [items addObject:negativeSpace];
    }
    UIButton *msgBtn = [[UIButton alloc]initWithFrame:KFrame(0, 0, 44, 44)];
    [msgBtn setImage:KImageName(@"消息") forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(jumpToMsgListVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc]initWithCustomView:msgBtn];
    [items addObject:msgItem];
    self.navigationItem.rightBarButtonItems = items;
    
}



//ios11下改变item间距
- (void)viewDidLayoutSubviews{
    if (@available(iOS 11.0,*)) {
        UINavigationItem * item=self.navigationItem;
        NSArray * array=item.rightBarButtonItems;
        if (array&&array.count!=0){
            UIBarButtonItem * buttonItem=array[0];
            UIView * view =[[[buttonItem.customView superview] superview] superview];
            NSArray * arrayConstraint=view.constraints;
            for (NSLayoutConstraint * constant in arrayConstraint) {
                if (constant.constant==-16) {//-16表示右侧
                    constant.constant = 0;
                }
            }
        }
    }
}

#pragma mark - 九宫格点击
-(void)gridButtonClick:(ItemModel *)model cellSection:(int)section
{
    BackgroundController *vc = [[BackgroundController alloc] init];
    vc.companyName = detailModel.companyName;
    vc.saveTitleStr = model.menuname;
    vc.itemModel = model;
    vc.companyId = detailModel.companyid;
    vc.itemArray = itemList;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 跟进记录
- (void)recordBtnClick{
    if (detailModel.type.intValue == 1) {//标记
        [self clinetMark];
    }else{
        FollowUpRecordController *vc = [FollowUpRecordController new];
        vc.companyId = _companyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 点击地理位置
-(void)companyAdress{
    ComMapViewController *view = [[ComMapViewController alloc]init];
    view.companyDetailModel = detailModel;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - 拨打电话
-(void)callCompany:(NSString *)phoneStr{
    NSLog(@"呼叫");
    NSString *string =[[self->detailModel.companyphonelist objectAtIndex:0] objectForKey:@"number"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",string];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - 网址
-(void)CompanyUrl:(NSString *)urlStr{
    CommonWebViewController *view = [[CommonWebViewController alloc]init];
    view.titleStr = @"";
    NSRange range = [urlStr rangeOfString:@"http"];
    if(range.location != NSNotFound){//存在
        view.urlStr = urlStr;
    }else{
        view.urlStr = [NSString stringWithFormat:@"http://%@",urlStr];//添加https
    }
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - 消息
- (void)jumpToMsgListVC{
    PushMessageController *vc = [PushMessageController new];
    vc.pushMessageType = PushMessageAloneType;
    vc.companyId = detailModel.companyid;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

