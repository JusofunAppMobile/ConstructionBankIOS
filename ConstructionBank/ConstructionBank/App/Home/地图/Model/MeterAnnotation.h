//
//  MeterAnnotation.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/6.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>

@interface MeterAnnotation : NSObject<BMKAnnotation>
@property (nonatomic ,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic ,copy) NSString *title;
@end
