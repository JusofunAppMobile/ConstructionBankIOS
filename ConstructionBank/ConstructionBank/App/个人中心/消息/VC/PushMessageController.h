//
//  PushMessageController.h
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"
#import "PushMessageCell.h"
@interface PushMessageController : BasicViewController

@property(nonatomic,assign)PushMessageType pushMessageType;

@property(nonatomic,copy)NSString*companyId;

@end
