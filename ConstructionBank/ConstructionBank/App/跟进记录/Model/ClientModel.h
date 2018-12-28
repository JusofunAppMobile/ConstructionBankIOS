//
//  ClientModel.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientModel : NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *job;
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,copy) NSString *linkPhone;//设置为企业联系方式
@end
