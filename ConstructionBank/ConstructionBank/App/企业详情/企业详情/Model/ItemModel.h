//
//  ItemModel.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabListModel.h"

@interface ItemModel : NSObject

@property(nonatomic,copy)NSString *menuname;
@property(nonatomic,copy)NSString *applinkurl;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *isshow;
@property(nonatomic,copy)NSString *menuid;
@property(nonatomic,copy)NSString *hasData;
@property(nonatomic,copy)NSString *HotImageUrl;
@property(nonatomic,copy)NSString *umeng;

//新版图片名字
@property(nonatomic,copy)NSString *Items;

//新版图片链接
@property(nonatomic,copy)NSString *ItemUrls;




/**
 带tablis
 */
@property(nonatomic,strong)NSArray*tablist;

@end
