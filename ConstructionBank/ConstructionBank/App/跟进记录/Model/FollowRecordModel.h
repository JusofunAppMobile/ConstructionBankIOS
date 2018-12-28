//
//  FollowRecordModel.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/7.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowRecordModel : NSObject
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *followId;
@property (nonatomic ,copy) NSString *followState;//跟进状态
@property (nonatomic ,copy) NSString *job;
@property (nonatomic ,copy) NSString *longitude;
@property (nonatomic ,copy) NSString *latitude;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *remark;//备注
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,copy) NSString *detailAddress;
@property (nonatomic ,copy) NSString *linePhone;//是否企业联系电话

@property (nonatomic ,copy) NSString *companyname;
@property (nonatomic ,copy) NSString *companyid;
@property (nonatomic ,copy) NSString *linkPhone;
@property (nonatomic ,copy) NSString *type;

@property (nonatomic ,copy) NSString *demand;
@property (nonatomic ,copy) NSString *suggest;
@property (nonatomic ,copy) NSString *isDemandSolved;
@property (nonatomic ,copy) NSString *support;
@property (nonatomic ,copy) NSString *isSupportSolved;


@end
