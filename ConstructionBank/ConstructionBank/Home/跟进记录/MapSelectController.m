//
//  MapSelectController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/28.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MapSelectController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "AddressModel.h"

@interface MapSelectController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKLocationService *locService;
@property (nonatomic ,strong) BMKPinAnnotationView *aAnnotation;
@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic ,strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) NSArray *datalist;
@property (nonatomic ,strong)  BMKPointAnnotation *annotation ;
@property (nonatomic ,strong) UIImageView *pinView;
@end

@implementation MapSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
    [self initTableview];
}

- (void)setupMapView{
    _mapView = [[BMKMapView alloc]initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, (KDeviceH-KNavigationBarHeight)/2)];
    _mapView.zoomLevel = 19;
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态,xian sh
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];//去除蓝色精度圈
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 5.f;
    [_locService startUserLocationService];
}

- (void)initTableview{
    self.tableview = ({
        UITableView *view=[UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mapView.mas_bottom);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        view.delegate=self;
        view.dataSource=self;
        view;
    });
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datalist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    BMKPoiInfo* model = _datalist[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.address;
    return cell;
}
#pragma mark -
- (void)addAnnotation{
    if (_annotation) {
        [_mapView removeAnnotation:_annotation];
    }
    _annotation = [[BMKPointAnnotation alloc] init];
    _annotation.coordinate = _mapView.centerCoordinate;
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];
    //    _mapView.centerCoordinate = userLocation.location.coordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
    
    if (!_pinView.superview) {//添加地图中点大头针
        [_mapView addSubview:self.pinView];
    }
}

#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //需要逆地理编码的坐标位置
    self.reverseGeoCodeOption.reverseGeoPoint = _mapView.centerCoordinate;
    [self.geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    [self addAnnotation];
}

//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"centerAnno"];
//        annotationView.pinColor = BMKPinAnnotationColorPurple;
//        annotationView.animatesDrop = YES;// 设置该标注点动画显示
//        return annotationView;
//    }
//    return nil;
//}

#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        _datalist = result.poiList;
        [_tableview reloadData];
    }else{
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
}

#pragma mark - lazy load
- (BMKGeoCodeSearch *)geoCodeSearch{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}

- (BMKReverseGeoCodeOption *)reverseGeoCodeOption{
    if (!_reverseGeoCodeOption) {
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    return _reverseGeoCodeOption;
}
- (UIImageView *)pinView{
    if (!_pinView) {
        _pinView = [[UIImageView alloc]initWithImage:KImageName(@"pin")];
        _pinView.frame = KFrame(0, 0, 30, 30);
        _pinView.center = CGPointMake(_mapView.width/2, _mapView.height/2-30/2);
    }
    return _pinView;
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

@end
