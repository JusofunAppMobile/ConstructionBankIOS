//
//  DistanceFilterBar.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/7.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "DistanceFilterBar.h"
#import <UIButton+LXMImagePosition.h>

@interface DistanceFilterBar ()
@property (nonatomic ,strong) UIButton *filterBtn;
@end
@implementation DistanceFilterBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.filterBtn = ({
            UIButton *filterBtn = [UIButton new];
            [filterBtn setImage:KImageName(@"icon_shaixuan") forState:UIControlStateNormal];
            [filterBtn setImage:KImageName(@"icon_shaixuan2") forState:UIControlStateSelected];
            [filterBtn setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
            filterBtn.titleLabel.font = KFont(14);
            [filterBtn setTitle:@"2km" forState:UIControlStateNormal];
            [filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:filterBtn];
            [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(15);
            }];
            filterBtn;
        });
       
        
    }
    return self;
}

- (void)filterAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}

- (void)layoutSubviews{
    
}

@end
