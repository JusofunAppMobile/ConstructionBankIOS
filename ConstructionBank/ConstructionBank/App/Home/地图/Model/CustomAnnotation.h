//
//  CustomAnnotation.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/29.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>
#import "AnnoListModel.h"

@interface CustomAnnotation : NSObject<BMKAnnotation>
@property (nonatomic ,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic ,copy)   NSString *title;
@property (nonatomic ,strong) AnnoListModel *model;
@property (nonatomic ,assign) NSInteger clusterNum;
@end

