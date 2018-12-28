//
//  AnnotationListView.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/30.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnoListModel.h"

@protocol AnnotationListViewDelegate <NSObject>
- (void)didSelectAnnotationList:(AnnoListModel *)model;

@optional
- (void)annotationListLoadMore;


@end



@interface AnnotationListView : UIView

@property (nonatomic ,strong) NSArray *datalist;
@property (nonatomic ,weak) id <AnnotationListViewDelegate>delegate;
@property (nonatomic ,assign) BOOL needHeader;
@property (nonatomic ,assign) AnnotationListType type;
- (void)showInView:(UIView *)superView header:(BOOL)need;
- (void)dismiss;
- (void)endRefresh:(BOOL)more;

@end
