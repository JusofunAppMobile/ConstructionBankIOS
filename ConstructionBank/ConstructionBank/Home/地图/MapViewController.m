//
//  MapViewController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <math.h>
#import "MapTool.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKLocationService *locService;
@property (nonatomic ,strong) BMKCircleView *circleView;
@property (nonatomic ,strong) BMKCircle *circle;
@property (nonatomic ,strong) BMKPolyline *polyline;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    _mapView.zoomLevel = 19;
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 5.f;
    [_locService startUserLocationService];

    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态,xian sh
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];//去除蓝色精度圈
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
}

#pragma mark - BMKMapViewDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //设置地图中心为用户经纬度
    if (!userLocation) {
        return;
    }
    [_mapView updateLocationData:userLocation];
    
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 500*0.00003;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 500*0.00003;//纬度范围
    [_mapView setRegion:region animated:YES];
    [self addCircle];
    [self addLine];
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]) {
        _circleView = [[BMKCircleView alloc]initWithCircle:(BMKCircle *)overlay];
        _circleView.strokeColor = [UIColor greenColor];
        _circleView.lineWidth = 1;
        return _circleView;
    }
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        
//        NSLog(@"代理____%f___%f",(BMKPolyline))
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 1.0;
        polylineView.lineDash = YES;
        return polylineView;
    }
    return nil;
}
#pragma mark - 画圈
- (void)addCircle{
    if (_circle) {
        [_mapView removeOverlay:_circle];
    }
    _circle = [BMKCircle circleWithCenterCoordinate:_locService.userLocation.location.coordinate radius:500];
    [_mapView addOverlay:_circle];
    
}

- (void)addLine{
    if (_polyline) {
        [_mapView removeOverlay:_polyline];
    }
    CLLocationCoordinate2D coor[2] = {0};
    coor[0] = _circle.coordinate;
    coor[1] = [MapTool getCoordinateWithCenter:_circle.coordinate distance:500 angle:30];
    _polyline = [BMKPolyline polylineWithCoordinates:coor count:2];
    [_mapView addOverlay:_polyline];
}



-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


#pragma mark - lazy load

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
