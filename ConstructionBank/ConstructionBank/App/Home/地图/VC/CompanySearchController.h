//
//  CompanySearchController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CompanySearchController : BasicViewController
@property (nonatomic ,strong) NSString *searchText;
@property (nonatomic ,strong) NSArray *entlist;
@property (nonatomic ,assign) CLLocationCoordinate2D userCoordinate;
@end
