//
//  UITableView+NoData.m
//  NoDataTest
//
//  Created by JUSFOUN on 2018/3/14.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UITableView+NoData.h"
#import <objc/runtime.h>
#import "NoDataView.h"

static const char NoDataViewKey = '\0';
static const char PlaceholderKey = '\0';
//static const char HandleNoDataKey = '\0';


@interface UITableView()

@property (nonatomic ,strong)  NoDataView*noDataView;
@end

@implementation UITableView (NoData)

+(void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(layoutSubviews)),
                                   class_getInstanceMethod(self,@selector(nd_layoutSubviews)));
//    method_exchangeImplementations(class_getInstanceMethod(self,@selector(reloadData)),
//                                   class_getInstanceMethod(self,@selector(nsd_reloadData)));
//    method_exchangeImplementations(class_getInstanceMethod(self,@selector(insertSections:withRowAnimation:)),
//                                   class_getInstanceMethod(self,@selector(nd_insertSections:withRowAnimation:)));
//    method_exchangeImplementations(class_getInstanceMethod(self,@selector(insertRowsAtIndexPaths:withRowAnimation:)),
//                                   class_getInstanceMethod(self,@selector(nd_insertRowsAtIndexPaths:withRowAnimation:)));
//    method_exchangeImplementations(class_getInstanceMethod(self,@selector(deleteSections:withRowAnimation:)),
//                                   class_getInstanceMethod(self,@selector(nd_deleteSections:withRowAnimation:)));
//    method_exchangeImplementations(class_getInstanceMethod(self,@selector(deleteRowsAtIndexPaths:withRowAnimation:)),
//                                   class_getInstanceMethod(self,@selector(nd_deleteRowsAtIndexPaths:withRowAnimation:)));
}
//
//- (void)nd_reloadData{
//    [self nd_reloadData];
//    [self reloadNoDataView];
//}
//
//- (void)nd_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
//    [self nd_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
//    [self reloadNoDataView];
//}
//
//- (void)nd_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
//    [self nd_deleteSections:sections withRowAnimation:animation];
//    [self reloadNoDataView];
//}
//
//- (void)nd_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
//    [self nd_insertSections:sections withRowAnimation:animation];
//    [self reloadNoDataView];
//}
//
//- (void)nd_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
//    [self nd_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
//    [self reloadNoDataView];
//}

#pragma mark - reloadData
//更新view的 frame
- (void)nd_reloadData{
    [self reloadData];
    [self reloadNoDataView];
}

- (void)reloadNoDataView{
    if ([self isTableViewNoData]) {
        self.noDataView.text = self.placeholderText;
        [self addSubview:self.noDataView];
        [self bringSubviewToFront:self.noDataView];
    }else{
        [self.noDataView removeFromSuperview];
    }
}

- (void)nd_layoutSubviews{
    [self nd_layoutSubviews];
    self.noDataView.frame = self.bounds;
}

#pragma mark - noDataView
- (void)setNoDataView:(NoDataView *)noDataView{
    objc_setAssociatedObject(self, &NoDataViewKey, noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NoDataView *)noDataView{
    NoDataView *view = objc_getAssociatedObject(self, &NoDataViewKey);
    if (!view) {
        view = [[NoDataView alloc]init];
        objc_setAssociatedObject(self,&NoDataViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}

#pragma mark - placeholderText
- (void)setPlaceholderText:(NSString *)placeholderText{
    objc_setAssociatedObject(self, &PlaceholderKey, placeholderText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)placeholderText{
    NSString *text = objc_getAssociatedObject(self, &PlaceholderKey);
    if (!text.length) {
        text = @"暂无信息";
        objc_setAssociatedObject(self, &PlaceholderKey, text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return text;
}

//判断tableview的row是否为零
- (BOOL)isTableViewNoData{
    for (int i=0; i<[self numberOfSections]; i++) {
        if ([self numberOfRowsInSection:i]) {
            return NO;
        }
    }
    return YES;
}

@end
