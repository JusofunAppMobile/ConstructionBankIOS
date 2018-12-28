//
//  ComMapViewController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "ComMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <MapKit/MapKit.h>
#import "annotationPaoView.h"

#define ISIOS6 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>6)

@interface ComMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UIActionSheetDelegate>
{
    NSMutableArray *mapArray;
    BMKPointAnnotation *point;
}
@property (nonatomic,strong) BMKMapView *mapView;
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,strong)BMKUserLocation * userLoc;//自己的位置
@end

@implementation ComMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    _mapView.delegate = self;
    _locService.delegate = self;
    [self initMapViewData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"企业位置";
    [self setNavigationBarTitle:@"企业位置" ];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBtn:@"back"];
    // CLLocationCoordinate2D lc2d = CLLocationCoordinate2DMake(39.905206 ,116.390356);
    CLLocationCoordinate2D lc2d = CLLocationCoordinate2DMake([self.companyDetailModel.latitude doubleValue] ,[self.companyDetailModel.longitude doubleValue]);
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, KDeviceW, 1);
    lineView.backgroundColor = KHexRGB(0xd9d9d9) ;
    [self.view addSubview:lineView];
    [self.view addSubview:[self createMapViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) withcoordinate2D:lc2d]];
    _mapView.delegate = self;
    [_mapView addAnnotation:point];
    [_mapView selectAnnotation:point animated:YES];
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate =self;
    [_locService startUserLocationService];
}


-(void)initMapViewData
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status||
        kCLAuthorizationStatusRestricted == status) {
        UIAlertView *defaultAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                   message:@"请开启定位:设置 > 隐私 > 定位服务 > 企信宝"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
        [defaultAlertView show];
        return;
    }
}


-(BMKMapView *)createMapViewWithFrame:(CGRect)frame withcoordinate2D:(CLLocationCoordinate2D)coor2D
{
    _mapView = [[BMKMapView alloc] initWithFrame:frame];
    _mapView.zoomLevel = 15;
    
    [_mapView setCenterCoordinate:coor2D animated:NO];
    point = [[BMKPointAnnotation alloc] init];
    point.coordinate = coor2D;
    point.title = self.companyDetailModel.companyName;
    return _mapView;
}

//实施位置更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLoc = userLocation;
    [_locService stopUserLocationService];
}


-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *AnnotationViewId = @"AnnotationId";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewId];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewId];
        annotationView.draggable = NO;
        annotationView.animatesDrop = NO;
    }
    annotationView.image = [UIImage imageNamed:@"pinlargest"];
    annotationView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:[[annotationPaoView alloc]initWithTitle:point.title]];;
    
    return annotationView;
}


/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"导航");
    
    mapArray = [[NSMutableArray alloc] initWithObjects:@"苹果地图", nil];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [mapArray addObject:@"高德地图"];
        
    };
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [mapArray addObject:@"百度地图"];
    };
    
    UIActionSheet *sheet;
    if (mapArray.count == 3) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[mapArray objectAtIndex:0],[mapArray objectAtIndex:1],[mapArray objectAtIndex:2], nil];
    }else if(mapArray.count == 2){
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[mapArray objectAtIndex:0],[mapArray objectAtIndex:1], nil];
        
    }else if(mapArray.count == 1)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[mapArray objectAtIndex:0], nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
}


- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [_mapView selectAnnotation:point animated:YES];
    return;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex< mapArray.count) {
        if ([[mapArray objectAtIndex:buttonIndex] isEqualToString:@"苹果地图"]) {
            [self jumpToAppleMap];
        }else if ([[mapArray objectAtIndex:buttonIndex] isEqualToString:@"高德地图"]) {
            
            if(!KScreen35)
            {
                [self jumpToGaode];
            }else
            {
                [self jumpToAppleMap];
            }
            
        }else if ([[mapArray objectAtIndex:buttonIndex] isEqualToString:@"百度地图"]) {
            [self jumpToBaidu];
        }
        
    }
}


#pragma mark - 跳到苹果原生自带的地图
-(void)jumpToAppleMap
{
    if (ISIOS6) {//判断版本号iOS6以上
        //起点
        //        MKMapItem *currentLocation = //[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.userLoc.location.coordinate addressDictionary:nil]];
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        currentLocation.name = @"我的位置";
        
        //目的地的位置
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.companyDetailModel.latitude doubleValue],[self.companyDetailModel.longitude doubleValue]) addressDictionary:nil]];
        toLocation.name = self.companyDetailModel.companyName;
        
        NSArray *items;
        if([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >=10)//ios10 更新后地图的起点跟终点反了
        {
            items  = [NSArray arrayWithObjects: toLocation,currentLocation, nil];
        }else
        {
            items  = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
        }
        
        
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES }; //打开苹果自身地图应用，并呈现特定的item
        
        [MKMapItem openMapsWithItems:items launchOptions:options];
        //
    }else{//ios6以下 跳转apple map
        
        //这种跳法快
        NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%.8f,%.8f&saddr=%.8f,%.8f",self.userLoc.location.coordinate.latitude,self.userLoc.location.coordinate.longitude,[self.companyDetailModel.latitude doubleValue],[self.companyDetailModel.longitude doubleValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}



#pragma mark - 跳到高德
-(void)jumpToGaode
{
    NSString *str=[NSString stringWithFormat:@"iosamap://navi?sourceApplication=MyMap&backScheme=IOSMapDaohang&poiname=终点&lat=%.8f&lon=%.8f&dev=1&style=2",[self.companyDetailModel.latitude doubleValue],[self.companyDetailModel.longitude doubleValue]];
    str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *StringUrl = [[NSURL alloc] initWithString:str];
    
    BOOL isCanOpen = [[UIApplication sharedApplication] canOpenURL:StringUrl];
    if (isCanOpen) {
        [[UIApplication sharedApplication] openURL:StringUrl];
    }
}



#pragma mark - 跳到百度
-(void)jumpToBaidu
{
    NSString *str = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&mode=driving",self.userLoc.location.coordinate.latitude,self.userLoc.location.coordinate.longitude,[self.companyDetailModel.latitude doubleValue],[self.companyDetailModel.longitude doubleValue]];
    NSLog(@"%@",str);
    
    str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *StringUrl = [[NSURL alloc] initWithString:str];
    
    BOOL isCanOpen = [[UIApplication sharedApplication] canOpenURL:StringUrl];
    if (isCanOpen) {
        [[UIApplication sharedApplication] openURL:StringUrl];
    }
}




-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate =  nil;
    _locService.delegate = nil;
}

-(void)dealloc
{
    [_mapView removeFromSuperview];
    _mapView = nil;
    //[super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
