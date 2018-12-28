//
//  AnnoListCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnnoListModel;

@interface AnnoListCell : UITableViewCell
@property (nonatomic ,strong) AnnoListModel *model;
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;
@property (nonatomic ,assign) AnnotationListType type;

@end
