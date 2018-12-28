//
//  FollowupNoDataView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowupNoDataView.h"

@implementation FollowupNoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = KHexRGB(0xebebeb);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(.5);
            make.left.right.top.mas_equalTo(self);
        }];
        
        UIImageView *iconView = [UIImageView new];
        iconView.image = KImageName(@"未查询到");
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(lineView.mas_bottom).offset(38);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(73);
        }];
        
        UILabel *tipLab = [UILabel new];
        tipLab.text = @"您今日还没有跟进日程哦！";
        tipLab.textColor = KHexRGB(0x999999);
        tipLab.font = KFont(13);
        tipLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(iconView.mas_bottom).offset(10);
        }];
        
       
    }
    return self;
}

@end
