//
//  EditMessageController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"

@interface EditMessageController : BasicViewController

@property(nonatomic,strong)NSArray *historyArray;

@property (nonatomic ,copy) NSString *companyId;

@property (nonatomic ,assign) PushMessageType pushMessageType ;

@end
