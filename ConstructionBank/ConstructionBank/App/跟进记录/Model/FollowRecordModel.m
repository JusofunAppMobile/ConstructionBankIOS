//
//  FollowRecordModel.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/7.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowRecordModel.h"

@implementation FollowRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"followId":@"id",@"remark":@"desc"};
}

- (NSString *)linePhone{
    if (_linePhone) {
        return _linePhone;
    }
    return _linkPhone;
}

- (NSString *)linkPhone{
    if (_linkPhone) {
        return  _linkPhone;
    }
    return _linePhone;
}

@end
