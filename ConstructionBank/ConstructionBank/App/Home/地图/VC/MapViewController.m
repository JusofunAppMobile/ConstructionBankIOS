//
//  MapViewController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <math.h>
#import "MapTool.h"
#import "NoteView.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "AnnotationListView.h"
#import "MeterAnnotation.h"
#import "MeterAnnotationView.h"
#import "FollowUpRecordController.h"
#import "PushMessageController.h"
#import "AnnoListModel.h"
#import "CompanyDetailController.h"
#import "CompanySearchController.h"
#import "SearchContainerController.h"
#import "HomeSearchNaviBar.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import "SearchAddressContainer.h"

static NSString * const cellID = @"cellID";

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,AnnotationListViewDelegate,HomeNaviDelegate,UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate>
@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKLocationService *locService;
@property (nonatomic ,strong) BMKCircle *circle;
@property (nonatomic ,strong) BMKPolyline *polyline;
@property (nonatomic ,strong) MeterAnnotation *meterAnno;
@property (nonatomic ,strong) NSArray *userlist;//用户位置周边列表
@property (nonatomic ,strong) NSMutableArray *selectedList;
@property (nonatomic ,assign) BOOL firstLocate;
@property (nonatomic ,strong) AnnotationListView *annoListView;
@property (nonatomic ,assign) CLLocationCoordinate2D endCoor;
@property (nonatomic ,strong) NSMutableArray *annolist;
@property (nonatomic ,strong) CustomAnnotation *selectedAnno;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) HomeSearchNaviBar *naviBar;

@property (nonatomic ,strong) NSMutableArray *overlaylist;
@property (nonatomic ,assign) SearchType searchType;
@property (nonatomic ,strong) UITableView *searchResultView;
@property (nonatomic ,strong) NSMutableArray<BMKPoiInfo *> *searchlist;
@property (nonatomic ,strong) BMKPoiSearch *searcher;
@property (nonatomic ,assign) int curPage;

@property (nonatomic ,assign) CLLocationCoordinate2D userCoordinate;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstLocate = YES;
    _page = 1;
    
    [self initMapView];
    [self startLocate];
    [self addActionObserver];
}

#pragma mark - 地图初始化
- (void)initMapView{
    
    _naviBar = [[HomeSearchNaviBar alloc]initWithFrame:KFrame(0, 0, KDeviceW, 44)];
    _naviBar.delegate = self;
    self.navigationItem.titleView = _naviBar;
    
    _mapView = [[BMKMapView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH - KTabBarHeight- KNavigationBarHeight)];
    _mapView.zoomLevel = 15;//定位坐标的精度跟缩放等级有直接关系
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.view addSubview:_mapView];
    
    //去除蓝色精度圈
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
    param.isAccuracyCircleShow = false;//精度圈是否显示
    param.locationViewImgName = @"mapDot";
    [_mapView updateLocationViewWithParam:param];
    
    //定位按钮
    UIButton *locateBtn = [[UIButton alloc]initWithFrame:KFrame(8,  10, 40, 40)];
    [locateBtn setImage:KImageName(@"locate") forState:UIControlStateNormal];
    [locateBtn addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locateBtn];
}

#pragma mark - 请求数据
- (void)loadData{
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:@"6" forKey:@"precision"];
    [params setObject:@(_userCoordinate.longitude) forKey:@"myLongitude"];
    [params setObject:@(_userCoordinate.latitude) forKey:@"myLatitude"];
    [params setObject:@"1" forKey:@"merge"];
    [RequestManager requestWithURLString:KGETMAPDATAS parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] intValue] == 0) {
            self.userlist =  [AnnoListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list2"]];
            [self addAnnotationViews];
            [self addCircleOverLays];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

#pragma mark - 定位
- (void)startLocate{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}
//BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (!userLocation) {
        return;
    }
    if (_firstLocate) {
        _userCoordinate = userLocation.location.coordinate;
        _firstLocate = NO;
        [_mapView updateLocationData:userLocation];
        [_mapView setCenterCoordinate:_userCoordinate animated:YES];
        [self loadData];
        [self saveLocationInfo];//保存定位
    }
}

- (void)saveLocationInfo{
    NSString *lon = [NSString stringWithFormat:@"%.6f",_userCoordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%.6f",_userCoordinate.latitude];
    NSDictionary *location = @{@"lon":lon,@"lat":lat};
    [KUserDefaults setObject:location forKey:KUserLocationKey];
}

#pragma mark - 添加大头针
- (void)addAnnotationViews{
    //重置
    [_mapView removeAnnotations:_annolist];
    [_annolist removeAllObjects];
    
    //遍历
    [_userlist enumerateObjectsUsingBlock:^(AnnoListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!model.isZeroPoint && model.coorString.length){
            CustomAnnotation *anno = [CustomAnnotation new];
            anno.coordinate = model.arcCoordinate;
            anno.title = @" ";
            anno.model = model;
            [self.annolist addObject:anno];
            
            if (idx == _userlist.count - 1 ) {//默认弹出
                _page = 1;
                _selectedAnno = anno;
                [self showAnnoList];
            }
        }
    }];
    [_mapView addAnnotations:_annolist];
}


#pragma mark - BMKMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]) {
        BMKCircleView *circleView = [[BMKCircleView alloc]initWithCircle:(BMKCircle *)overlay];
        circleView.strokeColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:53/255.0 alpha:0.1900000125169754/1.0];
        circleView.fillColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:53/255.0 alpha:0.1900000125169754/1.0];
        circleView.lineWidth = 1;
        return circleView;
    }
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = KHexRGB(0xffac00);
        polylineView.lineWidth = 1.0;
        polylineView.lineDash = YES;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *aID = @"BMKAnnotationView";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:aID];
        if (annotationView == nil) {
            annotationView = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:aID];
        }
        annotationView.image = KImageName(@"mapDot");
        return annotationView;
    }
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        static NSString *bId = @"CustomAnnotationView";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:bId];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:bId];
        }
        return annotationView;
    }
    if ([annotation isKindOfClass:[MeterAnnotation class]]) {
        static NSString *cId = @"MeterAnnotationView";
        MeterAnnotationView *annotationView = (MeterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:cId];;
        if (annotationView == nil) {
            annotationView = [[MeterAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:cId];
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        [mapView deselectAnnotation:view.annotation animated:NO];
        _page = 1;
        _selectedAnno = (CustomAnnotation *)view.annotation;//判断企业是否可以点击;
        [self.view endEditing:YES];
        [self showAnnoList];
    }
}

//大头针选中显示
- (void)showAnnoList{
    if ([_selectedAnno.model.type intValue] == 4) {//多企业
        [self loadDataForSelectedAnno:_selectedAnno loading:YES];
    }else{
        [self.selectedList removeAllObjects];
        [self.selectedList addObject:_selectedAnno.model];
        [self.annoListView setDatalist: _selectedList];
        [self.annoListView showInView:self.view header:NO];
    }
}

#pragma mark - 画圈
- (void)addCircleOverLays{
    //重置
    [_mapView removeOverlays:_overlaylist];
    [_overlaylist removeAllObjects];

    //添加当前位置圈
    [self addCircle:_userCoordinate];
    [self addLine:_userCoordinate];
    
    [_mapView addOverlays:self.overlaylist];
}

- (void)addCircle:(CLLocationCoordinate2D)coordinate{
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coordinate radius:2000];
    [self.overlaylist addObject:circle];
}

- (void)addLine:(CLLocationCoordinate2D)startCoor{
    CLLocationCoordinate2D endCoor =[MapTool getCoordinateWithCenter:startCoor distance:2000 angle:90];
    CLLocationCoordinate2D coor[2] = {0};
    coor[0] = startCoor;
    coor[1] = endCoor;
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coor count:2];
    [self.overlaylist addObject:polyline];
    [self addMeterLab:endCoor];
}

- (void)addMeterLab:(CLLocationCoordinate2D)coordinate{
    MeterAnnotation *meterAnno = [MeterAnnotation new];
    meterAnno.coordinate = coordinate;
    meterAnno.title = @" ";
    [_mapView addAnnotation:meterAnno];
    [_annolist addObject:meterAnno];
}

#pragma mark - 点击大头针 请求
- (void)loadDataForSelectedAnno:(CustomAnnotation *)anno loading:(BOOL)loading{
    
    NSDictionary *locationDic = [KUserDefaults objectForKey:KUserLocationKey];
    if (loading) {
        [MBProgressHUD showMessag:@"" toView:self.view];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:@(_page)forKey:@"pageIndex"];
    [params setObject:locationDic[@"lat"] forKey:@"myLatitude"];
    [params setObject:locationDic[@"lon"]  forKey:@"myLongitude"];
    
    NSDictionary *topLeft = anno.model.topLeft;
    NSDictionary *bottomRight = anno.model.bottomRight;
    
    NSString * topLeftLatStr = [NSString stringWithFormat:@"%@",[topLeft objectForKey:@"lat"]];
    NSString * topLeftLonStr = [NSString stringWithFormat:@"%@",[topLeft objectForKey:@"lon"]];
    NSString * bottomRightLatStr = [NSString stringWithFormat:@"%@",[bottomRight objectForKey:@"lat"]];
    NSString * bottomRightLonStr = [NSString stringWithFormat:@"%@",[bottomRight objectForKey:@"lon"]];
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler
                                                decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                scale:6
                                                raiseOnExactness:NO
                                                raiseOnOverflow:NO
                                                raiseOnUnderflow:NO
                                                raiseOnDivideByZero:NO];
    
    NSDecimalNumber *dividend = [NSDecimalNumber decimalNumberWithString:@"0.000001"];
    
    if([topLeftLatStr doubleValue] == [bottomRightLatStr doubleValue])
    {
        
        NSDecimalNumber *tempNumber = [NSDecimalNumber decimalNumberWithString:topLeftLatStr] ;
        
        NSDecimalNumber *result = [tempNumber decimalNumberByAdding:dividend withBehavior:roundingBehavior];
        NSLog(@"%@", result);
        
        NSDecimalNumber *resultDN = [[NSDecimalNumber decimalNumberWithString:bottomRightLatStr] decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        bottomRightLatStr = [resultDN stringValue];
        topLeftLatStr = [result stringValue];
        
    }
    
    if([topLeftLonStr doubleValue] == [bottomRightLonStr doubleValue])
    {
        NSDecimalNumber *tempNumber = [NSDecimalNumber decimalNumberWithString:bottomRightLonStr] ;
        
        NSDecimalNumber *result = [tempNumber decimalNumberByAdding:dividend withBehavior:roundingBehavior];
        NSLog(@"%@", result);
        
        NSDecimalNumber *resultDN = [[NSDecimalNumber decimalNumberWithString:topLeftLonStr] decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        topLeftLonStr = [resultDN stringValue];
        bottomRightLonStr = [result stringValue];
    }
    
    [params setObject:[NSString stringWithFormat:@"%@,%@",topLeftLatStr,topLeftLonStr] forKey:@"topLeft"];
    [params setObject:[NSString stringWithFormat:@"%@,%@",bottomRightLatStr,bottomRightLonStr] forKey:@"bottomRight"];
    
    [RequestManager requestWithURLString:KGETMAPSELECTEDDATAS parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] intValue] == 0) {
            if (_page == 1) {
                [_selectedList removeAllObjects];
            }
            [self.selectedList addObjectsFromArray: [AnnoListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]]];
            [self.annoListView setDatalist: _selectedList];
            [self.annoListView showInView:self.view header:YES];
            self.page++;
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
        [self.annoListView endRefresh: _selectedList.count< [anno.model.docCount intValue]];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
        [self.annoListView endRefresh:NO];
    }];
}

#pragma mark - 下拉加载更多
- (void)annotationListLoadMore{
    [self loadDataForSelectedAnno:_selectedAnno loading:NO];
}

- (void)didSelectAnnotationList:(AnnoListModel *)model{
    [_annoListView dismiss];
    
    CompanyDetailController *vc = [CompanyDetailController new];
    vc.companyId = model.companyId;
    vc.companyName = model.companyName;
    vc.distance = model.distance;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 列表点击事件
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
            [self reloadAnnolist];//刷新列表
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

- (void)reloadAnnolist{
    _page = 1;
    [self loadDataForSelectedAnno:_selectedAnno loading:NO];
}

//跳转跟进记录
- (void)jumpToFollowRecordVC:(NSString *)companyId{
    [_annoListView dismiss];
    
    FollowUpRecordController *vc = [FollowUpRecordController new];
    vc.companyId = companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转消息推送
- (void)jumpToMessagePushVC:(NSString *)companyId{
    [_annoListView dismiss];
    
    PushMessageController *vc = [PushMessageController new];
    vc.companyId = companyId;
    vc.pushMessageType = PushMessageAloneType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 按钮重定位
-  (void)locateAction{//定位
    _firstLocate = YES;
    [_locService stopUserLocationService];
    [_locService startUserLocationService];
}

#pragma mark - 搜索地址
- (void)searchBarAction:(NSString *)text{
    [_annoListView dismiss];
    [self.view endEditing:YES];
    if (_searchType == SearchTypeName) {
        SearchContainerController *vc = [SearchContainerController new];
        vc.searchText = text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BMKPoiInfo *model = _searchlist[0];
        if (model) {
            SearchAddressContainer *vc = [SearchAddressContainer new];
            vc.searchName = model.name;
            vc.userCoordinate = model.pt;
            vc.searchlist = _searchlist;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//更改搜索类型
- (void)didChangeSearchType:(NSInteger)searchType{
    _searchType = searchType;
    _naviBar.text = nil;
    if (searchType == SearchTypeName) {
        [_searchlist removeAllObjects];
        [self.searchResultView removeFromSuperview];
    }
}

//弹出键盘，隐藏列表
- (void)searchBarDidBeginEditing{
    [_annoListView dismiss];
}

//显示搜索列表
- (void)searchBarTextDidChanged:(NSString *)text{
    if (_searchType == SearchTypeAddress) {
        if (text.length) {
            if (!self.searchResultView.superview) {
                [self.view addSubview:self.searchResultView];
            }
            [self searchWithKeyword:text];
        }else{
            [_searchlist removeAllObjects];
            [self.searchResultView reloadData];
        }
    }
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

- (void)endRefresh{
    [self.searchResultView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.searchlist[indexPath.row].name;
    cell.detailTextLabel.text = self.searchlist[indexPath.row].address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchResultView removeFromSuperview];
    BMKPoiInfo *model = _searchlist[indexPath.row];
    SearchAddressContainer *vc = [SearchAddressContainer new];
    vc.searchName = model.name;
    vc.userCoordinate = model.pt;
    vc.searchlist = _searchlist;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_naviBar endEditing:YES];
}

#pragma mark - 通知
- (void)addActionObserver{
    [KNotificationCenter addObserver:self selector:@selector(annoListCellAction:) name:KANNOLISTCELLACTIONNOTI object:nil];
}

- (void)annoListCellAction:(NSNotification *)noti{
    NSDictionary *info = noti.userInfo;
    SEL selector = NSSelectorFromString(info[@"method"]);
    if ([self respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:info[@"companyId"]];);
    }
}

#pragma mark - lazy load
- (AnnotationListView *)annoListView{
    if (!_annoListView) {
        _annoListView = [[AnnotationListView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-KTabBarHeight-KNavigationBarHeight)];
        _annoListView.delegate = self;
        _annoListView.type = AnnotationListTypeMap;
    }
    return _annoListView;
}

- (NSMutableArray *)annolist{
    if (!_annolist) {
        _annolist = [NSMutableArray array];
    }
    return _annolist;
}

- (NSMutableArray *)overlaylist{
    if (!_overlaylist) {
        _overlaylist = [NSMutableArray array];
    }
    return _overlaylist;
}

- (NSMutableArray *)selectedList{
    if (!_selectedList) {
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
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
        _searchResultView = [[UITableView alloc]initWithFrame:KFrame(0, _mapView.y, KDeviceW, _mapView.height) style:UITableViewStylePlain];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
    }
    return _searchResultView;
}
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _naviBar.text = nil;
    [_searchlist removeAllObjects];
}

- (void)viewSafeAreaInsetsDidChange{
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [super viewSafeAreaInsetsDidChange];
}
- (void)dealloc{
    [KNotificationCenter removeObserver:self name:KANNOLISTCELLACTIONNOTI object:nil];
}


@end
