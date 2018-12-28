//
//  MapSearchController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/10/30.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapSearchController : BasicViewController<UISearchResultsUpdating>
@property(nonatomic,copy) NSString *cityName;
@end
