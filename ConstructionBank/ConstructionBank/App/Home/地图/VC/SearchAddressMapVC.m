//
//  SearchAddressMapVC.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/21.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SearchAddressMapVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "SearchNaviBar.h"
#import "NoteView.h"
#import "SearchAddressListVC.h"
#import "AnnoListModel.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "MeterAnnotationView.h"
#import "MapTool.h"
#import "MeterAnnotation.h"
#import "AnnotationListView.h"
#import "CompanyDetailController.h"
#import "FollowUpRecordController.h"
#import "PushMessageController.h"
static NSString * const cellID = @"cellID";


@interface SearchAddressMapVC ()<SearchNaviDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,AnnotationListViewDelegate,BMKPoiSearchDelegate>
@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) SearchNaviBar *naviBar;
@property (nonatomic ,strong) NSMutableArray *annolist;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) CustomAnnotation *selectedAnno;

@property (nonatomic ,strong) NSMutableArray *overlaylist;
@property (nonatomic ,strong) NSMutableArray *selectedList;

@property (nonatomic ,strong) AnnotationListView *annoListView;
@property (nonatomic ,strong) UITableView *searchResultView;
@property (nonatomic ,strong) BMKPoiSearch *searcher;
@property (nonatomic ,assign) int curPage;

@property (nonatomic ,copy) NSString *lastSearchText;

@end

@implementation SearchAddressMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self addActionObserver];
}

#pragma mark - unit
- (void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    _naviBar.text = searchText;
}

#pragma mark - initView
- (void)initViews{
    
    _naviBar = [[SearchNaviBar alloc]initWithFrame:KFrame(0, 0, KDeviceW, KNavigationBarHeight) showBack:YES title:@"搜索"];
    _naviBar.delegate = self;
    _naviBar.text = _searchText;
    [self.view addSubview:_naviBar];
    
    _mapView = [[BMKMapView alloc]initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-49-KNavigationBarHeight)];
    _mapView.zoomLevel = 15;//定位坐标的精度跟缩放等级有直接关系
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.delegate = self;
    _mapView.centerCoordinate = _userCoordinate;
    [self.view addSubview:_mapView];
    
    //去除蓝色精度圈
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
    param.isAccuracyCircleShow = false;//精度圈是否显示
    param.locationViewImgName = @"mapDot";
    [_mapView updateLocationViewWithParam:param];
    
    //添加标示view
    NoteView *noteView = [[NoteView alloc]initWithFrame:KFrame(10, 10, 95, 85)];
    noteView.backgroundColor = [UIColor whiteColor];
    [_mapView addSubview:noteView];
    
    
    [self.view bringSubviewToFront:_naviBar];
    [_naviBar showSearchBar];
    
    [self loadData];
}

#pragma mark - load Data
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

#pragma mark - 点击大头针 请求
- (void)loadDataForSelectedAnno:(CustomAnnotation *)anno loading:(BOOL)loading{
    
    if (loading) {
        [MBProgressHUD showMessag:@"" toView:self.view];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:@(_page)forKey:@"pageIndex"];
    [params setObject:@(_userCoordinate.latitude) forKey:@"myLatitude"];
    [params setObject:@(_userCoordinate.longitude)  forKey:@"myLongitude"];
    
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

#pragma mark - 添加大头针
- (void)addAnnotationViews{
    //重置
    [_mapView removeAnnotations:_annolist];
    [_annolist removeAllObjects];
    
    //添加搜索点大头针
    BMKPointAnnotation *entAnno = [BMKPointAnnotation new];
    entAnno.coordinate = _userCoordinate;
    entAnno.title = _searchText;
    [self.annolist addObject:entAnno];
    
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
            }
        }
    }];
    [_mapView addAnnotations:_annolist];
    [_mapView showAnnotations:_annolist animated:YES];
}

#pragma mark - 画圈
- (void)addCircleOverLays{
    //重置
    [_mapView removeOverlays:_overlaylist];
    [_overlaylist removeAllObjects];
    //添加用户圈
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

#pragma mark - 下拉加载更多
- (void)annotationListLoadMore{
    [self loadDataForSelectedAnno:_selectedAnno loading:NO];
}

- (void)didSelectAnnotationList:(AnnoListModel *)model{
    [_annoListView dismiss];
    
    CompanyDetailController *vc = [CompanyDetailController new];
    vc.companyId = model.companyId;
    vc.companyName = model.companyName;
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

- (void)reloadAnnolist{
    _page = 1;
    [self loadDataForSelectedAnno:_selectedAnno loading:NO];
}


#pragma mark - 搜索地址
- (void)searchBarAction:(NSString *)text{
    [_annoListView dismiss];
    
}

- (void)didClickBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarDidBeginEditing{
    if (!self.searchResultView.superview) {
        [self.view addSubview:self.searchResultView];
    }
}

- (void)searchBarTextDidChanged:(NSString *)text{
    _searchText = text;
    [self searchWithKeyword:text];
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

#pragma mark - 通知
- (void)addActionObserver{
    [KNotificationCenter addObserver:self selector:@selector(annoListCellAction:) name:KANNOLISTCELLACTIONNOTIForSearch object:nil];
}

- (void)annoListCellAction:(NSNotification *)noti{
    NSDictionary *info = noti.userInfo;
    SEL selector = NSSelectorFromString(info[@"method"]);
    if ([self respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:info[@"companyId"]];);
    }
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
    _userCoordinate = model.pt;
    self.searchText = model.name;
    
    [_mapView setCenterCoordinate:_userCoordinate animated:YES];
    [self loadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - lazy load
- (AnnotationListView *)annoListView{
    if (!_annoListView) {
        _annoListView = [[AnnotationListView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-49)];
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
        _searchResultView = [[UITableView alloc]initWithFrame:KFrame(0, _naviBar.maxY, KDeviceW, KDeviceH-_naviBar.maxY-49) style:UITableViewStylePlain];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
    }
    return _searchResultView;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (_isFromList&&(![_lastSearchText isEqualToString:_searchText])) {
        _isFromList = NO;
        [self loadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _lastSearchText = _searchText;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
