//
//  SearchAddressListVC.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/21.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SearchAddressListVC.h"
#import "CustomSegmentView.h"
#import "CompanyDetailController.h"
#import "PushMessageController.h"
#import "FollowUpRecordController.h"
#import "SearchListCell.h"
#import "AnnoListModel.h"
#import "UITableView+NoData.h"

static NSString * const cellID = @"cellID";
static NSString * SearchListCellID = @"SearchListCell";

@interface SearchAddressListVC ()<UITableViewDelegate,UITableViewDataSource,CustomSegmentDelegate,SearchListDelegate,BMKPoiSearchDelegate,UITextFieldDelegate>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) CustomSegmentView *segmentView;
@property (nonatomic ,assign) NSInteger companyType;//1：新增企业 2：推荐客户 3：正式客户
@property (nonatomic ,assign) int pageIndex;
@property (nonatomic ,assign) BOOL moreData;
@property (nonatomic ,strong) NSMutableArray *datalist;
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UIView *naviBar;


@property (nonatomic ,strong) UITableView *searchResultView;
@property (nonatomic ,strong) BMKPoiSearch *searcher;
@property (nonatomic ,assign) int curPage;

@property (nonatomic ,copy) NSString *lastSearchText;
@end

@implementation SearchAddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [KNotificationCenter addObserver:self selector:@selector(reloadAction) name:KAddFollowUpRecordNoti object:nil];
    
    _companyType = 1;
    _pageIndex = 1;
    [self initView];
    [self addRefreshView];
}

#pragma mark - set
- (void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    _textField.text = searchText;
    if (_isFistLoad) {//防止多次load（segment代理和此处在首次load的时候都会调用）
        _isFistLoad = NO;
    }else{
        if (![_lastSearchText isEqualToString:searchText]) {
            _pageIndex = 1;
            [self loadData:YES];
        }
    }
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

- (void)loadData:(BOOL)loading{
    _lastSearchText = _searchText;
    if (loading) {
        [MBProgressHUD showMessag:@"" toView:nil];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:_searchText forKey:@"address"];
    [params setObject:@(_userCoordinate.longitude) forKey:@"longitude"];
    [params setObject:@(_userCoordinate.latitude) forKey:@"latitude"];
    [params setObject:@(_pageIndex) forKey:@"PageIndex"];
    [params setObject:@(_companyType) forKey:@"type"];//test
    NSDictionary *locationDic = [KUserDefaults objectForKey:KUserLocationKey];
    if (locationDic) {
        [params setObject:locationDic[@"lon"] forKey:@"myLongitude"];
        [params setObject:locationDic[@"lat"] forKey:@"myLatitude"];
    }
    [RequestManager requestWithURLString:KSearchhCompanyByAddress parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:nil animated:NO];
        if ([responseObject[@"result"] intValue] == 0) {
            if (_pageIndex == 1) {
                [_datalist removeAllObjects];
            }
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self.datalist addObjectsFromArray: [AnnoListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]]];
                if (_companyType == 3) {
                    _moreData = _datalist.count < [responseObject[@"data"][@"totalCount"] intValue];
                    _pageIndex++;
                }else{
                    _pageIndex = [(responseObject[@"data"][@"havePageIndex"]) intValue];
                    _moreData = _pageIndex;
                }
            }
            [_tableview nd_reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:nil];
        }
        [self endRefresh];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:nil];
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
    if ([tableView isEqual:_tableview]) {
        if (section == 0) {
            return 10;
        }
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
    if ([tableView isEqual:_tableview]) {
        return _datalist.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_tableview]) {
        return 1;
    }else{
        return self.searchlist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tableview]) {
        SearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchListCellID];
        if (!cell) {
            cell = [[SearchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchListCellID];
            cell.delegate = self;
        }
        cell.model = _datalist[indexPath.section];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.searchlist[indexPath.row].name;
        cell.detailTextLabel.text = self.searchlist[indexPath.row].address;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_tableview]) {
        AnnoListModel *model = _datalist[indexPath.section];
        CompanyDetailController *vc = [CompanyDetailController new];
        vc.companyId = model.companyId;
        vc.companyName = model.companyName;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.searchResultView removeFromSuperview];
        BMKPoiInfo *model = _searchlist[indexPath.row];
        _userCoordinate = model.pt;
        self.searchText = model.name;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 切换用户类型CustomSegmentDelegate
- (void)segmentDidSelectIndex:(NSInteger)index{//此方法在setIsFromMap之前调用
    _companyType = index + 1;
    _pageIndex = 1;
    [self loadData:YES];
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
    self.searchText = _textField.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.searchResultView.superview) {
        [self.view addSubview:self.searchResultView];
    }
}

- (void)textFieldTextChanged{
    _searchText = _textField.text;
    [self searchWithKeyword:_searchText];
}

#pragma mark - 搜索poi
- (void)searchWithKeyword:(NSString *)keyword{
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = 15;
    citySearchOption.city= @"北京";//test
    citySearchOption.keyword = keyword;
    [self.searcher poiSearchInCity:citySearchOption];
}

#pragma mark - PoiSearchDeleage
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {//在此处理正常结果
        if (_curPage == 0) {
            [self.searchlist removeAllObjects];
        }
        [self.searchlist addObjectsFromArray:poiResultList.poiInfoList];
        [self.searchResultView reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){//起始点有歧义
        if (_curPage == 0) {
            [self.searchlist removeAllObjects];
            [self.searchResultView reloadData];
        }
    }else {//抱歉，未找到结果
        if (_curPage == 0) {
            [self.searchlist removeAllObjects];
            [self.searchResultView reloadData];
        }
    }
    [self endRefresh];
}

//返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
            textField.delegate = self;
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
        
        [_textField addTarget:self  action:@selector(textFieldTextChanged)  forControlEvents:UIControlEventEditingChanged];
        
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

- (NSMutableArray<BMKPoiInfo *> *)searchlist{
    if (!_searchlist) {
        _searchlist = [NSMutableArray<BMKPoiInfo *> new];
    }
    return _searchlist;
}

- (BMKPoiSearch *)searcher{
    if (!_searcher) {
        _searcher = [[BMKPoiSearch alloc]init];
    }
    _searcher.delegate = self;
    return _searcher;
}

- (UITableView *)searchResultView{
    if (!_searchResultView) {
        _searchResultView = [[UITableView alloc]initWithFrame:KFrame(0, _naviBar.maxY, KDeviceW, KDeviceH-_naviBar.maxY-49) style:UITableViewStylePlain];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
    }
    return _searchResultView;
}

- (NSMutableArray *)datalist{
    if (!_datalist ) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
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
