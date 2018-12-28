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


@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKLocationService *locService;
@property (nonatomic ,strong) BMKCircle *circle;
@property (nonatomic ,strong) BMKPolyline *polyline;
@property (nonatomic ,strong) NSMutableArray *datalist;
@property (nonatomic ,assign) BOOL firstLocate;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstLocate = YES;
    
    [self initMapView];
    [self startLocate];
}

//初始化地图
- (void)initMapView{
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    _mapView.zoomLevel = 19;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态,xian sh
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.view addSubview:_mapView];
    
    //去除蓝色精度圈
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
    param.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:param];
    
    //添加标示view
    NoteView *noteView = [[NoteView alloc]initWithFrame:KFrame(8, 40, 100, 90)];
    noteView.backgroundColor = [UIColor whiteColor];
    [_mapView addSubview:noteView];
    
    //定位按钮
    UIButton *locateBtn = [[UIButton alloc]initWithFrame:KFrame(8, noteView.maxY+10, 40, 40)];
    locateBtn.backgroundColor = [UIColor grayColor];
    [locateBtn addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locateBtn];
}

//开启定位
- (void)startLocate{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 5.f;
    [_locService startUserLocationService];
}

- (void)loadData{
    if (!_firstLocate) {
        return;
    }
    
    _datalist = [NSMutableArray array];
    
    for (int i = 0; i<5; i++) {
        
        double lat =  (arc4random() % 100) * 0.00005f;
        double lon =  (arc4random() % 100) * 0.00005f;
        
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_mapView.centerCoordinate.latitude+lat, _mapView.centerCoordinate.longitude+lon);
        
        CustomAnnotation *anno = [CustomAnnotation new];
        anno.coordinate = coor;
        [_datalist addObject:anno];
    }
    [_mapView addAnnotations:_datalist];
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
    [self loadData];

    _firstLocate = NO;

}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]) {
        BMKCircleView *circleView = [[BMKCircleView alloc]initWithCircle:(BMKCircle *)overlay];
        circleView.strokeColor = [UIColor greenColor];
        circleView.lineWidth = 1;
        return circleView;
    }
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 1.0;
        polylineView.lineDash = YES;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        static NSString *aid = @"aid";
        CustomAnnotationView *annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:aid];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:aid];
        }
        annotationView.numLab.text = @"2";
//        annotationView.iconView.image = KImageName(@"anno.jpeg");
//        CustomAnnotation *anno = (CustomAnnotation *)annotation;
        annotationView.image = KImageName(@"pin");
        return annotationView;
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

#pragma mark - button action
- (void)locateAction{//定位
 
}

#pragma mark - life cycle
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
