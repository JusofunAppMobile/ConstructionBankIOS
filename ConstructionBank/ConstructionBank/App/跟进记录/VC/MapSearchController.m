//
//  MapSearchController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/10/30.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MapSearchController.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
static NSString * const cellID = @"cellID";
@interface MapSearchController ()<UITextFieldDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, weak) UITextField *search;
//
//@property (nonatomic, weak) UIView *searchView;

@property (strong, nonatomic) UITableView *searchTableView;

@property(nonatomic,strong) BMKPoiSearch *searcher;

@property(nonatomic,strong) NSMutableArray<BMKPoiInfo *> *dataList;

@property(nonatomic,assign) int curPage;

@property (nonatomic ,strong) NSString *keyword;

@property (nonatomic ,strong) UISearchController *searchVC;

@end

@implementation MapSearchController


#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
//    [self.search becomeFirstResponder];
    _curPage = 0;
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
}

- (void)setTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.searchTableView = tableView;
    
    KWeakSelf
    tableView.mj_footer  = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.curPage ++;
        [weakSelf searchWithKeyword];
    }];
}

- (void)endRefresh{
    [self.searchTableView.mj_footer endRefreshing];
}

#pragma mark - textFieldDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    _curPage = 0;
    _searchVC = searchController;
    _keyword = searchController.searchBar.text;
    [self searchWithKeyword];
}

#pragma mark - 搜索poi
- (void)searchWithKeyword{
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = 15;
    citySearchOption.city= _cityName;
    citySearchOption.keyword = _keyword;
    //发起城市内POI检索
    
    BOOL flag = [self.searcher poiSearchInCity:citySearchOption];
}

#pragma mark - PoiSearchDeleage
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {//在此处理正常结果
        if (_curPage == 0) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:poiResultList.poiInfoList];
        [self.searchTableView reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){//起始点有歧义
        if (_curPage == 0) {
            [self.dataList removeAllObjects];
            [self.searchTableView reloadData];
        }
    }else {//抱歉，未找到结果
        if (_curPage == 0) {
            [self.dataList removeAllObjects];
            [self.searchTableView reloadData];
        }
    }
    [self endRefresh];
}

#pragma mark - UITableViewDelegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataList[indexPath.row].name;
    cell.detailTextLabel.text = self.dataList[indexPath.row].address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    BMKPoiInfo *model = _dataList[indexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.address?:@"" forKey:@"address"];
    [dic setObject:@(model.pt.latitude)?:@"" forKey:@"latitude"];
    [dic setObject:@(model.pt.longitude)?:@"" forKey:@"longitude"];
    [KNotificationCenter postNotificationName:KSelectAddressNoti object:nil userInfo:dic];
    _searchVC.active = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchVC.searchBar resignFirstResponder];
}

#pragma mark - lazyLoad
- (BMKPoiSearch *)searcher{
    if (!_searcher) {
        _searcher =[[BMKPoiSearch alloc]init];
    }
    _searcher.delegate = self;//此处需要每次都设置，因为当vc，点击取消之后，delegate就为空了，莫名问题
    return _searcher;
}

- (NSArray<BMKPoiInfo *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray<BMKPoiInfo *> new];
    }
    return _dataList;
}


@end

