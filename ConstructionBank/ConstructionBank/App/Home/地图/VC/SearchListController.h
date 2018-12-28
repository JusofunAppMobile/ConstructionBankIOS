//
//  SearchListController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/8.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface SearchListController : BasicViewController
@property (nonatomic ,strong) NSArray *entlist;
@property (nonatomic ,assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic ,copy) NSString *searchText;
@end
