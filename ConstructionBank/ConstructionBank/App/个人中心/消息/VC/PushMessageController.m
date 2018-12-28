//
//  PushMessageController.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "PushMessageController.h"
#import "EditMessageController.h"
#import "MsgListModel.h"
#import "NoDataView.h"

@interface PushMessageController ()<UITableViewDelegate,UITableViewDataSource>
{
     UITableView *backTableView;
    int pageNum;
}
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,assign) BOOL moreData;
@property (nonatomic ,strong) NoDataView *noDataView;
@end

@implementation PushMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [KNotificationCenter addObserver:self selector:@selector(reloadAction) name:KPushMessageSuccessNoti object:nil];
    
    [self setNavigationBarTitle:@"产品营销"];
    [self setBackBtn:@""];
    
    [self setTableView];
}

#pragma mark - 请求信息
-(void)loadData:(BOOL)loading{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:[NSString stringWithFormat:@"%d",pageNum] forKey:@"pageIndex"];
    if (_companyId) {
        [params setObject:_companyId forKey:@"companyId"];
    }
    if (loading) {
        [MBProgressHUD showMessag:@"" toView:self.view];
    }
    [RequestManager postWithURLString:KGetMessageList parameters:params isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] integerValue] == 0) {
            if(pageNum == 1){
                [_dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[MsgListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"][@"list"]]];
            [backTableView reloadData];
            _moreData = [_dataArray count] >= [responseObject[@"data"][@"totalCount"] intValue];
            pageNum++;
            
            int hasNextPage = [responseObject[@"data"][@"list"][@"hasNextPage"] intValue];
            if(hasNextPage == 0)
            {
                [backTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }

        self.noDataView.hidden = _dataArray.count;
        [self endRefresh];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
        self.noDataView.hidden = _dataArray.count;
        [self endRefresh];
    }];
    
}


- (void)endRefresh{
    [backTableView.mj_header endRefreshing];
    if (_moreData) {
        [backTableView.mj_footer endRefreshing];
    }else{
        [backTableView.mj_footer endRefreshingWithNoMoreData];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier22";
    
    PushMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PushMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier type:_pushMessageType];
    }
    
    MsgListModel *model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:KFrame(0, 0, tableView.width ,10 )];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count ;
}

#pragma mark - 推送消息
-(void)push{
    EditMessageController *vc = [EditMessageController new];
    vc.historyArray = _dataArray;
    vc.pushMessageType = _pushMessageType;
    vc.companyId = _companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置分割线从头开始
-(void)viewDidLayoutSubviews
{
    if ([backTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [backTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([backTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [backTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



-(void)setTableView
{
    backTableView = [[UITableView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-KNavigationBarHeight-80)style:UITableViewStyleGrouped];
    backTableView.backgroundColor = [UIColor whiteColor];
    backTableView.dataSource = self;
    backTableView.delegate = self;
    backTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:backTableView];
    backTableView.estimatedRowHeight = 170;
    backTableView.rowHeight = UITableViewAutomaticDimension;
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = KFrame(KDeviceW/2-100, KDeviceH -KNavigationBarHeight - 40 - 20,200, 40);
    [pushBtn setTitle:@"新增推送消息" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pushBtn.titleLabel.font = KFont(16);
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    [pushBtn setBackgroundImage:[[UIImage imageNamed:@"提交按钮"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
    
    
    backTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [self loadData:NO];
    }];
    
    backTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData:NO];
    }];
    
    pageNum = 1;
    [self loadData:YES];

}

#pragma mark - 通知刷新
- (void)reloadAction{
    [backTableView.mj_header executeRefreshingCallback];
}

#pragma mark -lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[NoDataView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-KNavigationBarHeight-80)];
        [backTableView addSubview:_noDataView];
    }
    return _noDataView;
}

- (void)dealloc{
    [KNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
