//
//  CompanyMapModel.h
//  EnterpriseInquiry
//
//  Created by jusfoun on 15/11/20.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CompanyMapModel : NSObject



@property(nonatomic,strong)NSDictionary *data;
//公司名字
@property(nonatomic,strong)NSString *  cEntShortName;

//股东
@property(nonatomic,strong)NSArray *  shareholders;

//投资
@property(nonatomic,strong)NSArray *  investments;

@property(nonatomic,assign)int total ;


@end
