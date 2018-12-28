//
//  SearchAddressContainer.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/21.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchAddressContainer : BasicViewController
@property (nonatomic ,copy) NSString *searchName;
@property (nonatomic ,assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic ,strong) NSArray *datalist;
@property (nonatomic ,strong) NSArray *searchlist;
@end

NS_ASSUME_NONNULL_END
