//
//  AnnoListModel.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/12.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface AnnoListModel : NSObject
@property (nonatomic ,copy) NSString *companyName;
@property (nonatomic ,copy) NSString *companyId;
@property (nonatomic ,copy) NSString *distance;
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *longitude;
@property (nonatomic ,copy) NSString *latitude;
@property (nonatomic ,copy) NSString *nature;//企业性质
@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *registMoney;
@property (nonatomic ,copy) NSString *legal;
@property (nonatomic ,copy) NSString *registDate;
@property (nonatomic ,copy) NSString *followState;
@property (nonatomic ,copy) NSString *type;//1：新增企业2：推荐客户 3：正式客户
@property (nonatomic ,copy) NSString *isEnable;///1:圈内可以点击   0：圈外不可点击
@property (nonatomic ,copy) NSString *docCount;//企业数量
@property (nonatomic ,strong) NSDictionary *topLeft;
@property (nonatomic ,strong) NSDictionary *bottomRight;

@property (nonatomic ,copy) NSString *topLeftString;
@property (nonatomic ,copy) NSString *bottomRightString;
@property (nonatomic ,assign) CLLocationCoordinate2D arcCoordinate;
@property (nonatomic ,copy) NSString *classify;
@property (nonatomic ,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *coorString;
@property (nonatomic ,assign) BOOL isZeroPoint;
@end

