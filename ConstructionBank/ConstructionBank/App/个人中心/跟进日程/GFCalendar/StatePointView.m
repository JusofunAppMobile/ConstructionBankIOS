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
    NSLog(@"长度___%f",self.width);
    _model = model;
    CGFloat originX = (self.width - (18*model.pointNum-9*(model.pointNum -1)))/2;
    NSArray *images = [self getPointImages];
    for (int i = 0; i < model.pointNum; i++) {
        UIImageView *point = [[UIImageView alloc]initWithFrame:KFrame(originX+i*9, 0, 18, 18)];
        point.image = images[i];
        [self addSubview:point];
    }
}

- (NSArray *)getPointImages{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i< _model.pointNum; i++) {
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
    }
    return images;
}

@end
