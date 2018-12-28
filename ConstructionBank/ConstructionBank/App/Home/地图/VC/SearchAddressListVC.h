//
//  SearchAddressListVC.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/21.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchAddressListVC : BasicViewController
@property (nonatomic ,copy) NSString *searchText;
@property (nonatomic ,assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic ,strong) NSMutableArray<BMKPoiInfo *> *searchlist;
@property (nonatomic ,assign)BOOL isFistLoad;


@end

NS_ASSUME_NONNULL_END
