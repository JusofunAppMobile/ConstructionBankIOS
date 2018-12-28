//
//  AnimalTableView.h
//  EnterpriseInquiry
//
//  Created by clj on 15/11/27.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "TTUITableViewZoomController.h"

@interface AnimalTableView : TTUITableViewZoomController

@property(nonatomic,strong) NSMutableArray *dataArray;



@property(nonatomic) UITableViewCellEditingStyle editingStyle;

@property (copy) UITableViewCell *(^cellForRowAtIndexPathCompletion)(UITableView *tableView,NSIndexPath *indexpath);

@property (copy) BOOL (^canEditRowAtIndexPathCompletion)(UITableView *tableView,NSIndexPath *indexPath);

@property (copy) CGFloat (^heightForRowAtIndexPathCompletion) (UITableView *tableView,NSIndexPath *indexPath);

@property (copy) void (^didSelectRowAtIndexPathCompletion)(UITableView *tableView,NSIndexPath *indexPath);

@property(copy) NSInteger(^numberOfRowsInSectionCompletion)(NSInteger section);

@property(copy) void (^viewDidLayoutSubviewsCompletion)();

@property(copy) void (^willDisPlayCell)(UITableView *tableView,NSIndexPath *indexPath,UITableViewCell *cell);

@property(copy) UIView * (^viewForHeaderInSection)(NSInteger section);

@property(copy) CGFloat (^heightForHeaderInSection)(NSInteger section);

@property(copy) UIView * (^viewForFootInSection)(NSInteger section);


@property(copy) void (^scrollViewWillBeginDragging)(UIScrollView *scrollView);

@end
