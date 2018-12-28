//
//  AnalysisController.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/7.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnalysisController.h"
#import "SendReportAlert.h"

@interface AnalysisController ()<UITableViewDelegate,UITableViewDataSource,SendReportDelegate>
{
    UITableView*backTableView;
    AnalysisHeadView *headView;
    UIButton *rightBtn;
    ShowDateView *showDateView;
   
    NSString *firstDayStr;
    NSString *secondDayStr;
    NSDictionary *dataDic;
   
}
@property (nonatomic ,strong) SendReportAlert *sendAlert;
@end

@implementation AnalysisController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self setNavigationBarTitle:@"工作汇报"];
    [self setBackBtn:@"back"];
    [self setNavigationBarRightBtn];
    

    
    NSDate *date =[NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    secondDayStr = [formatter stringFromDate:date];
    
    NSString *string = [NSString stringWithFormat:@"%@",[secondDayStr substringWithRange:NSMakeRange(0,8)]] ;
    
    firstDayStr = [NSString stringWithFormat:@"%@01",string] ;;


    [self drawView];
    [self loadData];
}
#pragma mark - 加载数据
-(void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:firstDayStr forKey:@"startDate"];
    [params setObject:secondDayStr forKey:@"endDate"];
    
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:StatisticalAnalysis parameters:params isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] integerValue] == 0 ) {
            dataDic = [responseObject objectForKey:@"data"];
            
            headView.dataDic = dataDic;
            [backTableView reloadData];
           
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
    
    
    
    
}



#pragma mark - 发送报告
- (void)sendReportAction:(NSDictionary *)params{
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager requestWithURLString:KSendReport parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}


- (void)sendReport{
    
   [self.sendAlert showInView:self.navigationController.view];
}
#pragma mark - SendReportDelegate 报告弹窗
- (void)textFieldDidSelectAtIndex:(NSInteger)index{
    KWeakSelf
    [DatePickerView showDatePickerWithTitle:@"请选择日期" minDate:nil maxDate:nil resultBlock:^(NSString * _Nonnull selectValue) {
        if (index == 0) {
            weakSelf.sendAlert.startField.text = selectValue;
        }else{
            weakSelf.sendAlert.endField.text = selectValue;
        }
    } cancelBlock:^{
    }];
}


-(void)checkMore
{
    MoreCompanyController *vc = [[MoreCompanyController alloc]init];
    vc.dataArray = [dataDic objectForKey:@"browseList"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showCalendar
{
    [UIView animateWithDuration:0.3 animations:^{
//        CGRect frame = showDateView.frame;
//        frame.origin.y = frame.origin.y>=0?-50:0;
//        showDateView.frame = frame;
        showDateView.alpha = !showDateView.alpha;
    }];
}

-(void)chooseDateStartDayStr:(NSString *)startDayStr endDayStr:(NSString *)endDayStr
{
    firstDayStr = startDayStr;
    secondDayStr = endDayStr;
    [self loadData];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section==0)
    {
        NSString *cellString = @"AnalysisPieCell";
        AnalysisPieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (!cell) {
            cell = [[AnalysisPieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataDic = dataDic;
        return cell;
    }
    else if(indexPath.section==1)
    {
        NSString *cellString = @"AnalysisBarCell";
        AnalysisBarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (!cell) {
            cell = [[AnalysisBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataDic = dataDic;
        return cell;
    }
    else if(indexPath.section == 2)
    {
        NSString *cellString = @"AnalysisHorizontalBarCell";
        AnalysisHorizontalBarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (!cell) {
            cell = [[AnalysisHorizontalBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataDic = dataDic;
        return cell;
    }
    else
    {
        static NSString *cellString = @"BrowseCell";
        BrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (!cell) {
            cell = [[BrowseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *array = [dataDic objectForKey:@"browseList"];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        cell.dataDic = dic;
        return cell;
    }
   
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3)
    {
        NSArray *array = [dataDic objectForKey:@"browseList"];
        return array.count>5?5:array.count;
    }
    else
    {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 210;
    }
    else if(indexPath.section == 1)
    {
        return 400;
    }
    else if(indexPath.section == 2)
    {
        return 190;
    }
    else
    {
        return 30;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray *titleArray = @[@"客户构成",@"客户增长走势",@"客户跟进情况",@"浏览记录"];
    UIView*view = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 60)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:KFrame(15, 23, 3, 15)];
    imageView.image = KImageName(@"标题标签");
    [view addSubview:imageView];
    
    UILabel*nameLabel = [[UILabel alloc]initWithFrame:KFrame(imageView.maxX + 5, imageView.y, KDeviceW - 40, 15)];
    [view addSubview:nameLabel];
    nameLabel.font = KFont(16);
    nameLabel.textColor = KHexRGB(0x333333);
    nameLabel.text = [titleArray objectAtIndex:section];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 0.5)];
    lineView1.backgroundColor = KHexRGB(0xd9d9d9);
    [view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:KFrame(0, view.height -0.5, KDeviceW, 0.5)];
    lineView2.backgroundColor = KHexRGB(0xd9d9d9);
    [view addSubview:lineView2];
    
    NSArray *array = [dataDic objectForKey:@"browseList"];
    
    if(section == 3&& array.count >0)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = KFrame(view.width - 15-70, 0, 70, view.height);
        [button setTitle:@"更多 >>" forState:UIControlStateNormal];
        [button setTitleColor:KHexRGB(0xB6B6B6) forState:UIControlStateNormal];
        button.titleLabel.font = KFont(12);
        [button addTarget:self action:@selector(checkMore) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = KFrame(0, 0, view.width, view.height);
        [button2 addTarget:self action:@selector(checkMore) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button2];
    }
    
    
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if(section == 3)
    {
        return 40;
    }
    else
    {
        return CGFLOAT_MIN;
    }
    
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 3)
    {
        return [UIView new];
    }
    else
    {
        return nil;
    }
    
}

-(void)setNavigationBarRightBtn
{
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M月"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    rightBtn = [[UIButton alloc]initWithFrame:KFrame(0, 0, 70, 44)];
    [rightBtn setImage:KImageName(@"跟进时间") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showCalendar) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:dateStr forState:UIControlStateNormal];
    [rightBtn setTitleColor:KHexRGB(0x3333333) forState:UIControlStateNormal];
    [rightBtn setImagePosition:LXMImagePositionRight spacing:3];
    rightBtn.titleLabel.font = KFont(14);
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = msgItem;
}


#pragma mark - 绘制页面
-(void)drawView
{
    backTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KDeviceW, KDeviceH -KNavigationBarHeight- 40-20) style:UITableViewStyleGrouped];
    backTableView.delegate = self;
    backTableView.dataSource = self;
    backTableView.tableFooterView = [[UIView alloc]init];
    backTableView.rowHeight = 60;
    backTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    backTableView.backgroundColor = [UIColor whiteColor];
    headView = [[AnalysisHeadView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 95)];
    backTableView.tableHeaderView = headView;
    [self.view addSubview:backTableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = KFrame(75, KDeviceH - KNavigationBarHeight-40-10, KDeviceW-75*2, 40);
    [button setTitle:@"发送报告" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = KFont(15);
    [button setBackgroundImage:KImageName(@"按钮背景") forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(sendReport) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:KFrame(0, KDeviceH -KNavigationBarHeight-40-20, KDeviceW, 0.5)];
    lineView1.backgroundColor = KHexRGB(0xd9d9d9);
    [self.view addSubview:lineView1];
    
    showDateView = [[ShowDateView alloc]initWithFrame:KFrame(0,0, KDeviceW, KDeviceH)];
    showDateView.delegate = self;
    showDateView.alpha = 0;
    [self.view addSubview:showDateView];
    
}

#pragma mark - lazy load
- (SendReportAlert *)sendAlert{
    if (!_sendAlert) {
        _sendAlert = [[SendReportAlert alloc]initWithFrame:KeyWindow.bounds];
        _sendAlert.delegate = self;
    }
    return _sendAlert;
}


@end
