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
#import "MapSearchController.h"
#import "CustomSearchController.h"

@interface MapSelectController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>

@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKLocationService *locService;
@property (nonatomic ,strong) BMKPinAnnotationView *aAnnotation;
@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic ,strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) NSArray *datalist;
@property (nonatomic ,strong)  BMKPointAnnotation *annotation ;
@property (nonatomic ,strong) UIImageView *pinView;
@property (nonatomic ,strong) CLLocation *userLocation;
@property (nonatomic ,strong) UISearchBar *searchBar;
@property (nonatomic ,strong) CustomSearchController *searchController;
@property (nonatomic ,copy) NSString *cityName;
@property (nonatomic ,assign) BOOL needPop;
@end

@implementation MapSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"选择地点"];
    [self setBackBtn:@"back"];
    [self setupMapView];
    [self initTableview];
    [self addAddressObserver];
}

#pragma mark - 通知
- (void)addAddressObserver{
    [KNotificationCenter addObserver:self selector:@selector(didSelectAddress:) name:KSelectAddressNoti object:nil];
}
- (void)didSelectAddress:(NSNotification *)noti{
    _needPop = YES;
}

#pragma UISearchControllerDelegate
- (void)willDismissSearchController:(UISearchController *)searchController{
    if (_needPop) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupMapView{
    
    _mapView = [[BMKMapView alloc]initWithFrame:KFrame(0, 43, KDeviceW, (KDeviceH-KNavigationBarHeight-44)/2)];
    _mapView.zoomLevel = 17;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态,xian sh
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];//去除蓝色精度圈
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 10.f;
    [_locService startUserLocationService];
    
    MapSearchController *resultsController = [[MapSearchController alloc] init];
    self.searchController = [[CustomSearchController alloc] initWithSearchResultsController:resultsController];
    self.searchController.searchResultsUpdater = resultsController;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    [self.view addSubview:self.searchController.searchBar];
    
    self.definesPresentationContext = YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_resultBlock) {
        BMKPoiInfo* model = _datalist[indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.address?:@"" forKey:@"address"];
        [dic setObject:@(model.pt.latitude)?:@"" forKey:@"latitude"];
        [dic setObject:@(model.pt.longitude)?:@"" forKey:@"longitude"];
        _resultBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //设置地图中心为用户经纬度
    if (!userLocation) {
        return;
    }
    _userLocation = userLocation.location;
    [_mapView updateLocationData:userLocation];
    if (!_pinView.superview) {//添加地图中点大头针
        [_mapView addSubview:self.pinView];
    }
    [self reverseGeo:_userLocation.coordinate];
}


#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //需要逆地理编码的坐标位置
    [self reverseGeo:_mapView.centerCoordinate];
}
//逆地理编码
- (void)reverseGeo:(CLLocationCoordinate2D)coordinate{
    self.reverseGeoCodeOption.reverseGeoPoint = coordinate;
    [self.geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
}
#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        _datalist = result.poiList;
        [_tableview reloadData];
        if (!_cityName.length) {
            BMKPoiInfo* model = _datalist[0];
            _cityName = model.city;
        }
    }else{
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    MapSearchController *vc = [MapSearchController new];
    vc.cityName = _cityName;
    [self.navigationController pushViewController:vc animated:YES];
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
    _locService.delegate = nil;
    _needPop = NO;
}

@end
