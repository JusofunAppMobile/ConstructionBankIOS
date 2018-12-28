//
//  FollowUpRecordController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/28.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowUpRecordController.h"
#import "FollowUpRecordCell.h"
#import "AddFollowUpLogController.h"
#import "FollowRecordModel.h"
#import <IQKeyboardManager.h>
#import "NoDataView.h"

static NSString *CellID = @"FollowUpRecordCell";

@interface FollowUpRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) NSMutableArray *datalist;
@property (nonatomic ,assign) int pageIndex;
@property (nonatomic ,assign) BOOL moreData;
@property (nonatomic ,strong) NoDataView *noDataView;

@end

@implementation FollowUpRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [KNotificationCenter addObserver:self selector:@selector(reloadAction) name:KAddFollowUpRecordNoti object:nil];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 40;

    [self setNavigationBarTitle:@"跟进记录"];
    [self setBackBtn:@"back"];
    
    [self initView];
    [self addRefreshView];
    
    _pageIndex = 1;
    [self loadData:YES];
    
}

#pragma mark - initView
- (void)initView{
    self.tableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style: UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 80, 0));
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 190.f;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view;
    });
    
    UIButton *addBtn = [UIButton new];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    addBtn.titleLabel.font = KFont(15);
    [addBtn setTitle:@"添加跟进日志" forState: UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:KImageName(@"按钮背景") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addLogAction) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return CGFLOAT_MIN;
}

//去除navi与table之间的空白
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 这是对应 尾视图
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowUpRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[FollowUpRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _datalist[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFollowUpLogController *vc = [AddFollowUpLogController new];
    vc.companyid = _companyId;
    vc.recordModel = _datalist[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loadData
- (void)loadData:(BOOL)loading{
    if (loading) {
        [MBProgressHUD showMessag:@"" toView:self.view];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:_companyId forKey:@"companyId"];
    [params setObject:@(_pageIndex) forKey:@"pageIndex"];
   
    [RequestManager postWithURLString:KGETFollowList parameters:params isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        
        if ([responseObject[@"result"] intValue] == 0) {
            if (_pageIndex == 1) {
                [_datalist removeAllObjects];
            }
            [self.datalist addObjectsFromArray: [FollowRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]]];
            [_tableview reloadData];
            _moreData = _datalist.count < [responseObject[@"data"][@"totalCount"] intValue];
            _pageIndex++;
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
        self.noDataView.hidden = _datalist.count;
        [self endRefresh];
    } failure:^(NSError *error) {
        self.noDataView.hidden = _datalist.count;
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
        [self endRefresh];
    }];
}

#pragma mark - 添加跟进日志
- (void)addLogAction{
    AddFollowUpLogController *vc = [AddFollowUpLogController new];
    vc.companyid = _companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 通知刷新
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

- (NoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[NoDataView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-KNavigationBarHeight-80)];
        [_tableview addSubview:_noDataView];
    }
    return _noDataView;
}


- (void)dealloc{
    [KNotificationCenter removeObserver:self];
}
@end
