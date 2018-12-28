//
//  UITableView+NoData.h
//  NoDataTest
//
//  Created by JUSFOUN on 2018/3/14.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoData)

@property (nonatomic ,copy) NSString *placeholderText;

- (void)nd_reloadData;//调用此方法刷新tableview，无数据时添加占位图
@end
