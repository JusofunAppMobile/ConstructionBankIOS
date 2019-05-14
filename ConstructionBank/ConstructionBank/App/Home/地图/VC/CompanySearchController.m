//
//  CompanySearchController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CompanySearchController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "NoteView.h"
#import "MeterAnnotation.h"
#import "MeterAnnotationView.h"
#import "AnnotationListView.h"
#import "MapTool.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "SearchNaviBar.h"
#import "SearchListController.h"
#import "CompanyDetailController.h"
#import "FollowUpRecordController.h"
#import "PushMessageController.h"


@interface CompanySearchController ()<AnnotationListViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,SearchNaviDelegate>
@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKLocationService *locService;
@property (nonatomic ,strong) BMKCircle *circle;
@property (nonatomic ,strong) BMKPolyline *polyline;
@property (nonatomic ,strong) MeterAnnotation *meterAnno;
@property (nonatomic ,strong) AnnotationListView *annoListView;
@property (nonatomic ,strong) NSMutableArray *annolist;

@property (nonatomic ,assign) BOOL firstLocate;
@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) SearchNaviBar *naviBar;

@property (nonatomic ,strong) CustomAnnotation *selectedAnno;

@end

@implementation CompanySearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstLocate = YES;
    [self initMapView];
    [self startLocate];
    [self addActionObserver];
}

- (void)setEntlist:(NSArray *)entlist{
    _entlist = entlist;
    if (_entlist) {
        self.dataDic = [self getClusterDataDic];
        [self addAnnotations];
    }
}

- (void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    _naviBar.text = _searchText;
}

#pragma mark - 地图初始化
- (void)initMapView{
    
    _naviBar = [[SearchNaviBar alloc]initWithFrame:KFrame(0, 0, KDeviceW, KNavigationBarHeight) showBack:YES title:@"搜索"];
    _naviBar.delegate = self;
    _naviBar.text = _searchText;
    [self.view addSubview:_naviBar];
    
    
    _mapView = [[BMKMapView alloc]initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-49-KNavigationBarHeight)];
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
    
    
    //添加标示view
    NoteView *noteView = [[NoteView alloc]initWithFrame:KFrame(10, 10, 95, 85)];
    noteView.backgroundColor = [UIColor whiteColor];
    [_mapView addSubview:noteView];
    
    //定位按钮
    UIButton *locateBtn = [[UIButton alloc]initWithFrame:KFrame(8, noteView.maxY+10, 40, 40)];
    [locateBtn setImage:KImageName(@"locate") forState:UIControlStateNormal];
    [locateBtn addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locateBtn];
    
    [self.view bringSubviewToFront:_naviBar];
    [_naviBar showSearchBar];
    
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
        _firstLocate = NO;
        _userCoordinate = userLocation.location.coordinate;
        [_mapView updateLocationData:userLocation];
        [_mapView setCenterCoordinate:_userCoordinate animated:YES];
        [self addCircleOverLays];
        [self loadData];
    }
}

#pragma mart - loadData
- (void)loadData{
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
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

//坐标重叠企业归类
- (NSDictionary *)getClusterDataDic{
    NSMutableDictionary *models = [NSMutableDictionary dictionary];
    [_entlist enumerateObjectsUsingBlock:^(AnnoListModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isZeroPoint&&obj.coorString.length) {
            if ([models[obj.coorString]isKindOfClass:[NSArray class]]) {
                NSMutableArray *arr = models[obj.coorString];
                [arr addObject:obj];
            }else{
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:obj];
                [models setObject:arr forKey:obj.coorString];
            }
        }
    }];
    return models;
}

#pragma mark - 添加大头针
- (void)addAnnotations{
    [_mapView removeAnnotations:_annolist];
    [_annolist removeAllObjects];
    
    [_dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *arr, BOOL * _Nonnull stop) {
        AnnoListModel *model = arr[0];
        CustomAnnotation *anno = [CustomAnnotation new];
        anno.coordinate = model.coordinate;
        anno.title = @" ";
        anno.model = model;
        anno.clusterNum = arr.count;
        [self.annolist addObject:anno];
    }];
    [_mapView addAnnotations:_annolist];
    [_mapView showAnnotations:_annolist animated:YES];
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
        
        _page = 1;
        [mapView deselectAnnotation:view.annotation animated:NO];
        
        _selectedAnno = (CustomAnnotation *)view.annotation;//判断企业是否可以点击
        NSArray *arr = _dataDic[_selectedAnno.model.coorString];
        
        [self.annoListView setDatalist: arr];
        [self.annoListView showInView:self.view header:NO];
    }
}

#pragma mark - 画圈
- (void)addCircleOverLays{
    [self addCircle:_userCoordinate];
    [self addLine:_userCoordinate];
}

//圆
- (void)addCircle:(CLLocationCoordinate2D)coordinate{
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coordinate radius:2000];
    [_mapView addOverlay:circle];
}

//虚线
- (void)addLine:(CLLocationCoordinate2D)startCoor{
    CLLocationCoordinate2D endCoor =[MapTool getCoordinateWithCenter:startCoor distance:2000 angle:90];
    CLLocationCoordinate2D coor[2] = {0};
    coor[0] = startCoor;
    coor[1] = endCoor;
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coor count:2];
    [_mapView addOverlay:polyline];
    [self addMeterTips:endCoor];
}

//500米
- (void)addMeterTips:(CLLocationCoordinate2D)coordinate{
    MeterAnnotation *meterAnno = [MeterAnnotation new];
    meterAnno.coordinate = coordinate;
    meterAnno.title = @" ";
    [_mapView addAnnotation:meterAnno];
}

#pragma mark - 跳转企业详情
- (void)didSelectAnnotationList:(AnnoListModel *)model{
    CompanyDetailController *vc = [CompanyDetailController new];
    vc.companyId = model.companyId;
    vc.companyName = model.companyName;
    vc.distance = model.distance;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 定位按钮
- (void)locateAction{
    _firstLocate = YES;
    [_locService stopUserLocationService];
    [_locService startUserLocationService];
}

#pragma mark - 搜索
- (void)searchBarAction:(NSString *)text{
    [self.view endEditing:YES];
    _searchText = text;
    [self loadData];
}

- (void)didClickBackButton{
    [self.navigationController popViewControllerAnimated:YES];
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
            [self changeAnnoState:companyId];
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

- (void)changeAnnoState:(NSString *)companyId{
    NSArray *arr = _dataDic[_selectedAnno.model.coorString];
    [arr enumerateObjectsUsingBlock:^(AnnoListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.companyId isEqualToString:companyId]) {
            obj.type = @"2";
            [self.annoListView setDatalist: arr];
            *stop = YES;
        }
    }];
}

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


#pragma mark - lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_naviBar hideSearchBar];
    [_annoListView dismiss];
}

#pragma mark - lazy load
- (AnnotationListView *)annoListView{
    if (!_annoListView) {
        _annoListView = [[AnnotationListView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-49)];
        _annoListView.delegate = self;
        _annoListView.type = AnnotationListTypeSearch;
    }
    return _annoListView;
}

- (NSMutableArray *)annolist{
    if (!_annolist) {
        _annolist = [NSMutableArray array];
    }
    return _annolist;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _mapView.delegate = nil; //放在viewWillDisappear中会导致大头针变成系统默认样式 不用时，置nil
    [KNotificationCenter removeObserver:self name:KANNOLISTCELLACTIONNOTIForSearch object:nil];
}

@end

