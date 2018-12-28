//
//  ComMapViewController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "CompanyDetailModel.h"
@interface ComMapViewController : BasicViewController

@property (nonatomic,strong) CompanyDetailModel *companyDetailModel;

-(BMKMapView *)createMapViewWithFrame:(CGRect)frame withcoordinate2D:(CLLocationCoordinate2D)coor2D;

@end
