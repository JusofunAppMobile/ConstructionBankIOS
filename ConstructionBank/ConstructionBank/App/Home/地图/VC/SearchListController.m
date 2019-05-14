//
//  SearchListController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/8.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SearchListController.h"
#import "CustomSegmentView.h"
#import "CompanyDetailController.h"
#import "PushMessageController.h"
#import "FollowUpRecordController.h"
#import "SearchListCell.h"
#import "AnnoListModel.h"
#import "UITableView+NoData.h"

static NSString * SearchListCellID = @"SearchListCell";


@interface SearchListController ()<UITableViewDelegate,UITableViewDataSource,CustomSegmentDelegate,SearchListDelegate>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) CustomSegmentView *segmentView;
@property (nonatomic ,assign) NSInteger companyType;//1：新增企业 2：推荐客户 3：正式客户
@property (nonatomic ,assign) int pageIndex;
@property (nonatomic ,assign) BOOL moreData;
@property (nonatomic ,strong) NSMutableArray *list1;
@property (nonatomic ,strong) NSMutableArray *list2;
@property (nonatomic ,strong) NSMutableArray *list3;
@property (nonatomic ,strong) NSArray *datalist;
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UIView *naviBar;

@end

@implementation SearchListController
- (void)viewDidLoad {
    [super viewDidLoad];
    [KNotificationCenter addObserver:self selector:@selector(reloadAction) name:KAddFollowUpRecordNoti object:nil];
    
    [self initView];
    [self addRefreshView];
}

#pragma mark - initView
- (void)initView{
    
    [self.view addSubview:self.naviBar];
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(_segmentView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)addRefreshView{
    KWeakSelf
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        weakSelf.pageIndex = 1;
        [weakSelf loadData:NO];
    }];
    //    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        [weakSelf loadData:NO];
    //    }];
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
    if (_textField.text.length<2) {
        [MBProgressHUD showHint:@"企业名称长度不能小于2!" toView:self.view];
        return;
    }
    
    _searchText = _textField.text;
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:_searchText forKey:@"companyname"];
    [params setObject:@(_userCoordinate.longitude) forKey:@"myLongitude"];
    [params setObject:@(_userCoordinate.latitude) forKey:@"myLatitude"];
    
    [RequestManager requestWithURLString:KMapSearch parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] intValue] == 0) {
            self.entlist = [AnnoListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [_tableview nd_reloadData];
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
    SearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchListCellID];
    if (!cell) {
        cell = [[SearchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchListCellID];
        cell.delegate = self;
    }
    cell.model = _datalist[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AnnoListModel *model = _datalist[indexPath.section];
    CompanyDetailController *vc = [CompanyDetailController new];
    vc.companyId = model.companyId;
    vc.companyName = model.companyName;
    vc.distance = model.distance;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 切换用户类型CustomSegmentDelegate
- (void)segmentDidSelectIndex:(NSInteger)index{
    _companyType = index + 1;
    
    if (_companyType == 1) {
        _datalist = _list1;
    }else if (_companyType == 2){
        _datalist = _list2;
    }else{
        _datalist = _list3;
    }
    [self.tableview nd_reloadData];
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

#pragma mark - 通知
- (void)reloadAction{
    [_tableview.mj_header executeRefreshingCallback];
}

#pragma mark - 搜索
- (void)searchAction{
    if (!_textField.text.length) {
        [MBProgressHUD showHint:@"请输入搜索的企业名称" toView:self.view];
        return;
    }
    [self.view endEditing:YES];
    [self loadData:YES];
}

//返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set
- (void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    _textField.text = searchText;
}

- (void)setEntlist:(NSArray *)entlist{
    _entlist = entlist;
    
    [_list1 removeAllObjects];
    [_list2 removeAllObjects];
    [_list3 removeAllObjects];
    [_entlist enumerateObjectsUsingBlock:^(AnnoListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.type intValue] == 3) {
            [self.list3 addObject:obj];
        }else if ([obj.type intValue] == 2){
            [self.list2 addObject:obj];
        }else {
            [self.list1 addObject:obj];
        }
    }];
    
    if (_companyType == 1) {
        _datalist = _list1;
    }else if (_companyType == 2){
        _datalist = _list2;
    }else{
        _datalist = _list3;
    }
    [self.tableview nd_reloadData];
}

#pragma mark - lazyload
- (UIView *)naviBar{
    if (!_naviBar) {
        _naviBar = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KNavigationBarHeight)];
        _naviBar.backgroundColor = [UIColor whiteColor];
        
        UIButton *backBtn = [UIButton new];
        [backBtn setImage:KImageName(@"back") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(_naviBar).offset(10);
            make.width.mas_equalTo(35);
        }];
        
        UIButton *button = [UIButton new];
        [button.titleLabel setFont:KFont(16)];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleColor:KHexRGB(0x2ec0ff) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_naviBar).offset(10);
            make.right.mas_equalTo(_naviBar).offset(-30);
            make.width.mas_equalTo(35);
        }];
        
        self.textField = ({
            UITextField *textField = [UITextField new];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.placeholder = @"请输入企业名称";
            textField.font = KFont(15);
            [_naviBar addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(backBtn.mas_right).offset(10);
                make.centerY.mas_equalTo(_naviBar).offset(10);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(button.mas_left).offset(-10);
            }];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.text = _searchText;
            textField;
        });
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = KHexRGB(0xefefef);
        [_naviBar addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(.5);
            make.left.right.mas_equalTo(_naviBar);
            make.bottom.mas_equalTo(_naviBar);
        }];
    }
    return _naviBar;
}

- (CustomSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[CustomSegmentView alloc]initWithFrame:KFrame(0, self.naviBar.maxY, KDeviceW, 50) items:@[@"新增企业",@"推荐客户",@"正式客户"] delegate:self];
    }
    return _segmentView;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 300;
    }
    return _tableview;
}

- (NSMutableArray *)list1{
    if (!_list1) {
        _list1 = [NSMutableArray array];
    }
    return _list1;
}

- (NSMutableArray *)list2{
    if (!_list2) {
        _list2 = [NSMutableArray array];
    }
    return _list2;
}

- (NSMutableArray *)list3{
    if (!_list3) {
        _list3 = [NSMutableArray array];
    }
    return _list3;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc{
    [KNotificationCenter removeObserver:self name:KAddFollowUpRecordNoti object:nil];
}

@end
