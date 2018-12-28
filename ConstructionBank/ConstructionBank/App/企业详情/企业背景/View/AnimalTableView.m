//
//  AnimalTableView.m
//  EnterpriseInquiry
//
//  Created by clj on 15/11/27.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "AnimalTableView.h"
#import "BranchOrInvesmentCell.h"

@interface AnimalTableView ()

@end

@implementation AnimalTableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_numberOfRowsInSectionCompletion) {
        return _numberOfRowsInSectionCompletion(section);
    }
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellForRowAtIndexPathCompletion) {
        return _cellForRowAtIndexPathCompletion(tableView, indexPath);
    }
    else{
        static NSString *CellIdentifier = @"ContactListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canEditRowAtIndexPathCompletion) {
        return _canEditRowAtIndexPathCompletion(tableView, indexPath);
    }
    else{
        return NO;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (_viewForFootInSection(section)) {
//        return _viewForFootInSection(section);
//    }
//    
    UIView *view = [[UIView alloc] init];
    return view;
}


#pragma mark - Tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightForRowAtIndexPathCompletion) {
        return _heightForRowAtIndexPathCompletion(tableView, indexPath);
    }
    
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editingStyle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectRowAtIndexPathCompletion) {
        return _didSelectRowAtIndexPathCompletion(tableView, indexPath);
    }
}

//#pragma mark - 设置分割线从头开始

#pragma mark - 设置分割线从头开始
-(void)viewDidLayoutSubviews
{
    if (_viewDidLayoutSubviewsCompletion) {
//        return _viewDidLayoutSubviewsCompletion();
         //有些页面需要分割线从头开始的在block回调中写上代码就会执行，block代码并没有起作用
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (_willDisPlayCell) {
//////        return _viewDidLayoutSubviewsCompletion(tableView,cell,indexPath);
////        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
////            [cell setSeparatorInset:UIEdgeInsetsZero];
////        }
////        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
////            [cell setLayoutMargins:UIEdgeInsetsZero];
////        }
////
////    }
//}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_viewForHeaderInSection) {
        return _viewForHeaderInSection(section);
    }
    return [[UIView alloc] init];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_heightForHeaderInSection) {
        return  _heightForHeaderInSection(section);
    }
    return 0;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_scrollViewWillBeginDragging) {
         _scrollViewWillBeginDragging(scrollView);
    }
}


@end
