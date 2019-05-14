//
//  CompanyListController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CompanyListController.h"
#import "CompanyListCell.h"
#import "CompanyListModel.h"
#import "CustomSegmentView.h"
#import "CompanyDetailController.h"
#import "FollowUpRecordController.h"
#import "PushMessageController.h"
#import "UITableView+NoData.h"
#import <UIButton+LXMImagePosition.h>
#import "YBPopupMenu.h"

static NSString * CompanyListCellID = @"CompanyListCell";

@interface CompanyListController ()<UITableViewDelegate,UITableViewDataSource,CustomSegmentDelegate,CompanyListDelegate,YBPopupMenuDelegate>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) CustomSegmentView *segmentView;
@property (nonatomic ,strong) NSMutableArray *datalist;
@property (nonatomic ,assign) NSInteger segmentIndex;
@property (nonatomic ,assign) int pageIndex;
@property (nonatomic ,assign) BOOL moreData;
@property (nonatomic ,strong) NSArray *distanceArr;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIButton *filterBtn;
@property (nonatomic ,strong) NSString *firstFilterType;
@property (nonatomic ,strong) NSString *secFilterType;

@end

@implementation CompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [KNotificationCenter addObserver:self selector:@selector(reloadAction) name:KAddFollowUpRecordNoti object:nil];

    self.distanceArr = @[@"2km",@"5km",@"10km",@"20km",@"全北京"];
    self.firstFilterType = @"2";
    self.secFilterType = @"2";
    [self setNavigationBarTitle:@"企业列表"];
    [self initView];
    [self addRefreshView];
}

#pragma mark - initView
- (void)initView{
    
    self.segmentView = ({
        CustomSegmentView *view = [[CustomSegmentView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 50) items:@[@"新增企业",@"推荐客户",@"正式客户"] delegate:self];
        [self.view addSubview:view];
        view;
    });
    
    self.bgView = ({
        UIView *bgView = [UIView new];
        bgView.backgroundColor = KHexRGB(0xf3f3f3);
        [self.view addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_segmentView.mas_bottom);
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(30);
        }];
        bgView;
    });
    
    
    UILabel *tipLab = [UILabel new];
    tipLab.text = @"范围选择：";
    tipLab.font = KFont(12);
    tipLab.textColor = KHexRGB(0x999999);
    [_bgView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(_bgView);
    }];
    
    self.filterBtn = ({
        UIButton *filterBtn = [UIButton new];
        [filterBtn setImage:KImageName(@"icon_shaixuan") forState:UIControlStateNormal];
        [filterBtn setImage:KImageName(@"icon_shaixuan2") forState:UIControlStateSelected];
        [filterBtn setTitleColor:KHexRGB(0xfc7b2b) forState:UIControlStateNormal];
        [filterBtn setTitle:@"2km" forState:UIControlStateNormal];
        [filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
        filterBtn.titleLabel.font = KFont(14);
        [_bgView addSubview:filterBtn];
        [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgView);
            make.left.mas_equalTo(tipLab.mas_right).offset(5);
        }];
        filterBtn;
    });
    
    [_bgView layoutIfNeeded];
    [_filterBtn setImagePosition:LXMImagePositionRight spacing:10];
    
    self.tableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(_bgView.mas_bottom);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 300;
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


#pragma mark - loadData
- (void)loadData:(BOOL)loading{
    NSDictionary *locationDic = [KUserDefaults objectForKey:KUserLocationKey];
    if (loading) {
        [MBProgressHUD showMessag:@"" toView:nil];
    }
    NSInteger type = _segmentIndex == 1?10:_segmentIndex+1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(_pageIndex) forKey:@"pageIndex"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    NSString *distanceType = @"2";
    if (_segmentIndex == 0) {
        distanceType = _firstFilterType;
    }else if (_segmentIndex == 1){
        distanceType = _secFilterType;
    }else{
        distanceType = @"-2";
    }
    
    [params setObject:distanceType forKey:@"filterDistance"];

    if (locationDic) {
        [params setObject:locationDic[@"lon"] forKey:@"myLongitude"];
        [params setObject:locationDic[@"lat"] forKey:@"myLatitude"];
    }

    [RequestManager requestWithURLString:KGETCOMPANYLIST parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:nil animated:YES];
        if ([responseObject[@"result"]intValue] == 0) {
            if (_pageIndex == 1) {
                [_datalist removeAllObjects];
            }
            [self.datalist addObjectsFromArray:[CompanyListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]]];
            [_tableview nd_reloadData];
            if (_segmentIndex == 2) {
                _pageIndex++;
                _moreData = _datalist.count< [responseObject[@"data"][@"totalCount"] intValue];
            }else{
                _pageIndex = [(responseObject[@"data"][@"havePageIndex"]) intValue];
                _moreData = _pageIndex;
            }
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
        [self endRefresh];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
        [self endRefresh];
    }];
}

//标记用户
- (void)clinetMark:(NSString *)companyId{
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:companyId forKey:@"entid"];
    [params setObject:KUSER.userID forKey:@"userId"];
    [RequestManager requestWithURLString:KCustomerMark parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"标记成功" toView:self.view];
            [_tableview.mj_header executeRefreshingCallback];//刷新
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}


#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
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
    CompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:CompanyListCellID];
    if (!cell) {
        cell = [[CompanyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CompanyListCellID];
        cell.delegate = self;
    }
    [cell setModel:_datalist[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CompanyListModel *model = _datalist[indexPath.section];
    
    CompanyDetailController *vc = [CompanyDetailController new];
    vc.companyId = model.companyId;
    vc.companyName = model.name;
    vc.distance = model.distance;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 切换用户类型CustomSegmentDelegate
- (void)segmentDidSelectIndex:(NSInteger)index{
    _segmentIndex = index;
    _bgView.hidden = index == 2;
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(index ==2?0:30);
    }];
    NSString *type = @"2";
    NSDictionary *titleDic = @{@"2":@"2km",@"5":@"5km",@"10":@"10km",@"20":@"20km",@"-2":@"全北京"};
    if (index == 0) {
        type = _firstFilterType;
    }else{
        type = _secFilterType;
    }
    
    [_filterBtn setTitle:titleDic[type] forState:UIControlStateNormal];
    [_filterBtn setImagePosition:LXMImagePositionRight spacing:10];
    
    _pageIndex = 1;
    [self loadData:YES];
    if (_datalist.count) {
       [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];//滚到顶部
    }
}

#pragma mark - cell 按钮点击
//跳转跟进记录
- (void)jumpToFollowRecordVC:(NSString *)companyId{
    FollowUpRecordController *vc = [FollowUpRecordController new];
    vc.companyId = companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转消息推送
- (void)jumpToMessagePushVC:(NSString *)companyId{
    PushMessageController *vc = [PushMessageController new];
    vc.companyId = companyId;
    vc.pushMessageType = PushMessageAloneType;
    [self.navigationController pushViewController:vc animated:YES];
}

//筛选
- (void)filterAction:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:_distanceArr icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
    }];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    NSString *type = @"2";
    if (index == 4) {
        type = @"-2";
    }else if (index == 3){
        type = @"20";
    }else if (index == 2){
        type = @"10";
    }else if (index == 1){
        type = @"5";
    }else{
        type = @"2";
    }
    if (_segmentIndex == 0) {
        _firstFilterType = type;
    }else{
        _secFilterType = type;
    }
    [_filterBtn setTitle:_distanceArr[index] forState:UIControlStateNormal];
    [_filterBtn setImagePosition:LXMImagePositionRight spacing:10];
    
    _pageIndex = 1;
    [self loadData:YES];
}

#pragma mark - 通知
- (void)reloadAction{
    [_tableview.mj_header executeRefreshingCallback];
}

#pragma mark - lazyLoad
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
