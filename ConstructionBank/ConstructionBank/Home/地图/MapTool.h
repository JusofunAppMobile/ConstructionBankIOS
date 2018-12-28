//
//  MapTool.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/28.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MapTool : NSObject
+(CLLocationCoordinate2D)getCoordinateWithCenter:(CLLocationCoordinate2D)center distance:(double)distance angle:(double)brng;
@end
