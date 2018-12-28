//
//  StatePointView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "StatePointView.h"

@implementation StatePointView

- (void)setModel:(CalendarDayModel *)model{
    _model = model;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
            obj = nil;
        }
    }];//防止重用
    CGFloat originX = (self.width - (9*model.pointNum-4.5*(model.pointNum -1)))/2;
    NSArray *images = [self getPointImages];
    for (int i = 0; i < images.count; i++) {
        UIImageView *point = [[UIImageView alloc]initWithFrame:KFrame(originX+i*4.5, 0, 9, 9)];
        point.image = KImageName(images[i]);
        [self addSubview:point];
    }
}

- (NSArray *)getPointImages{
    if (!_model.pointNum) {
        return nil;
    }
    NSMutableArray *images = [NSMutableArray array];
    if (_model.statusformal.boolValue) {
        [images addObject:@"正式合作"];
    }
    if (_model.statusCooperation.boolValue) {
        [images addObject:@"合作建立"];
    }
    if (_model.statusPhone.boolValue) {
        [images addObject:@"已电话沟通"];
    }
    if (_model.statusVisited.boolValue) {
        [images addObject:@"已拜访"];
    }
    if (_model.statusVisit.boolValue) {
        [images addObject:@"拜访中"];
    }
    return images;
}

@end
