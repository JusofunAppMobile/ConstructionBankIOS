//
//  AnnotationListView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/30.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnnotationListView.h"
#import "AnnoListCell.h"

#define MAX_H (KDeviceH/667.f)*370
#define ROW_H 170.f//150

static NSString *CellID = @"AnnotationListCell";

@interface AnnotationListView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,assign) BOOL isShow;

@end

@implementation AnnotationListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        self.tableview = ({
            UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];;
            [self addSubview:view];
            view.backgroundColor = [UIColor whiteColor];
            view.separatorStyle = UITableViewCellSeparatorStyleNone;
            view.dataSource = self;
            view.delegate = self;
            view.rowHeight = UITableViewAutomaticDimension;
            view.estimatedRowHeight = 210;
            view;
        });
        
        KWeakSelf
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.needHeader) {
                if ([weakSelf.delegate respondsToSelector:@selector(annotationListLoadMore)]) {
                    [weakSelf.delegate annotationListLoadMore];
                }
            }else{
                [_tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        [self addTapGesture];
        
    }
    return self;
}

- (void)endRefresh:(BOOL)more{
    if (more) {
        [_tableview.mj_footer endRefreshing];
    }else{
        [_tableview.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setDatalist:(NSArray *)datalist{
    _datalist = datalist;
    CGFloat height   = MIN(ROW_H*_datalist.count, MAX_H);
    if (height != _tableview.height) {
        _tableview.frame = KFrame(0, self.height, self.width, height);
    }
    [_tableview reloadData];
}

#pragma mark - UITableViewDelegate
//去除navi与table之间的空白
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 这是对应 尾视图
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnoListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[AnnoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellID];
        cell.type = self.type;
    }
    cell.model = _datalist[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectAnnotationList:)]) {
        [self.delegate didSelectAnnotationList:_datalist[indexPath.section]];
    }
}

#pragma mark - UITapGestureRecognizer
- (void)tapAction{
    [self dismiss];
}

- (void)showInView:(UIView *)superView header:(BOOL)need{
    if (_isShow) {
        return;
    }
    _needHeader = need;
    [superView addSubview:self];
    
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableview scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [UIView animateWithDuration:.3 animations:^{
        CGPoint point     = _tableview.center;
        point.y           -= _tableview.height;
        _tableview.center = point;
    } completion:^(BOOL finished) {
        _isShow = YES;
    }];
}

- (void)dismiss{

    if (!_isShow) {
        return;
    }
    [UIView animateWithDuration:.3 animations:^{
        CGPoint point    = _tableview.center;
        point.y          += _tableview.height;
        _tableview.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _isShow = NO;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableview]) {
        return NO;
    }
    return YES;
}

@end
