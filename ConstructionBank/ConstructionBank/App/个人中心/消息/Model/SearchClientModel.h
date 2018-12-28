//
//  SearchClientModel.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/7.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchClientModel : NSObject

@property (nonatomic ,copy) NSString *entid;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,assign) BOOL selected;
@end
