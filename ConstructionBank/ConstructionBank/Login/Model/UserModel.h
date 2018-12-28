//
//  UserModel.h
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JKDBModel.h>

#define KUSER [UserModel sharedUser]

@interface UserModel : JKDBModel
SingletonH(User);

///用户userid
@property(nonatomic,copy)NSString *userID;

@property(nonatomic,copy)NSString *headIcon;

@property(nonatomic,copy)NSString *job;
@property(nonatomic,copy)NSString *organName;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *username;


@end
