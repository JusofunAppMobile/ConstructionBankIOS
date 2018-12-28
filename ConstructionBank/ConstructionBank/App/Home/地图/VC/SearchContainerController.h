//
//  SearchContainerController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/8.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface SearchContainerController : BasicViewController
@property (nonatomic ,strong) NSString *searchText;
@property (nonatomic ,assign) CLLocationCoordinate2D userCoordinate;

@end
