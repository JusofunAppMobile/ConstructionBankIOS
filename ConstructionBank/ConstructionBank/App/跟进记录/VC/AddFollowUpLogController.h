//
//  AddFollowUpLogController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import "FollowRecordModel.h"

@interface AddFollowUpLogController : BasicViewController

@property (nonatomic ,copy) NSString *companyid;
@property (nonatomic ,strong) FollowRecordModel *recordModel;
@end
