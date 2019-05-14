//
//  MyClientViewController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MyClientViewController.h"
#import "CustomSegmentView.h"
#import "MyClientCell.h"
#import "MyClientModel.h"
#import "PushMessageController.h"
#import "FollowUpRecordController.h"
#import "CompanyDetailController.h"

static NSString *CellID = @"MyClientCell";

@interface MyClientViewController ()<CustomSegmentDelegate,UITableViewDelegate,UITableViewDataSource,MyClientCellDelegate>

@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) CustomSegmentView *segmentView;
@property (nonatomic ,strong) NSMutableArray *datalist;
//@property (nonatomic ,assign) NSInteger companyType;//3：正式客户 2：推荐客户
@property (nonatomic ,assign) NSInteger segmentIndex;
@property (nonatomic ,assign) int pageIndex;
@property (nonatomic ,assign) BOOL moreData;
@end

@implementation MyClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"我的客户"];
    [self setBackBtn:@"back"];
    [self initView];
    [self addRefreshView];
    [KNotificationCenter addObserver:self selector:@selector(reloadAction) name:KAddFollowUpRecordNoti object:nil];
    // Do any additional setup after loading the view.
}

- (void)initView{
    self.segmentView = ({
        CustomSegmentView *view = [[CustomSegmentView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 50) items:@[@"跟进客户",@"正式客户"] delegate:self];
        [self.view addSubview:view];
        view;
    });
    
    self.tableview = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(_segmentView.mas_bottom);
        }];
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 210;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view;
    });
}

- (void)addRefreshView{
    KWeakSelf
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf loadData:NO];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
}

- (void)endRefresh{
    [_tableview.mj_header endRefreshing];
    if (_moreData) {
        [_tableview.mj_footer endRefreshing];
    }else{
        [_tableview.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - load data
- (void)loadData:(BOOL)loading{
    if (loading) {
        [MBProgressHUD showMessag:@"" toView:self.view];
    }
    NSString *entType = _segmentIndex == 0 ? @"11":@"3";
    NSDictionary *locationDic = [KUserDefaults objectForKey:KUserLocationKey];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:entType forKey:@"type"];
    [params setObject:@(_pageIndex) forKey:@"pageIndex"];
    if (locationDic) {
        [params setObject:locationDic[@"lon"] forKey:@"myLongitude"];
        [params setObject:locationDic[@"lat"] forKey:@"myLatitude"];
    }
   
    [RequestManager requestWithURLString:KGETMYCUSTOMER parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"]intValue] == 0) {
            if (_pageIndex == 1) {
                [_datalist removeAllObjects];
            }
            [self.datalist addObjectsFromArray:[MyClientModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]]];
            [_tableview reloadData];
            _pageIndex++;
            _moreData = _datalist.count < [responseObject[@"data"][@"totalCount"] intValue];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
        [self endRefresh];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
        [self endRefresh];
    }];
    
}

#pragma mark - UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 这是对应 尾视图
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[MyClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellID];
        cell.delegate = self;
    }
    cell.model = _datalist[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyClientModel *model = _datalist[indexPath.section];
    
    CompanyDetailController *vc = [CompanyDetailController new];
    vc.companyId = model.companyId;
    vc.companyName = model.companyName;
    vc.distance = model.distance;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CustomSegmentDelegate
- (void)segmentDidSelectIndex:(NSInteger)index{

     _segmentIndex = index;
    _pageIndex = 1;
    [self loadData:YES];
}

#pragma mark - MyClientCellDelegate
//推送消息
- (void)jumpToMessagePushVC:(NSString *)companyId{
    PushMessageController *vc = [PushMessageController new];
    vc.companyId = companyId;
    vc.pushMessageType = PushMessageAloneType;
    [self.navigationController pushViewController:vc animated:YES];
}

//跟着记录
- (void)jumpToFollowRecordVC:(NSString *)companyId{
    FollowUpRecordController *vc = [FollowUpRecordController new];
    vc.companyId = companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 通知
- (void)reloadAction{
    [_tableview.mj_header executeRefreshingCallback];
}

#pragma mark - lazy load
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

- (void)dealloc{
    [KNotificationCenter removeObserver:self name:KAddFollowUpRecordNoti object:nil];
}
@end
