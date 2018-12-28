//
//  MapSelectController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/28.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"

typedef void(^ResultBlock)(id);


@interface MapSelectController : BasicViewController
@property (nonatomic ,copy)ResultBlock resultBlock;
@end
