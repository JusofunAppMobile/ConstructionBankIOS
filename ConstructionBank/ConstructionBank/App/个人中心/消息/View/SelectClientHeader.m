//
//  SelectClientHeader.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SelectClientHeader.h"

@implementation SelectClientHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KHexRGB(0xf3f3f3);
        
        UILabel *leftLab = [UILabel new];
        [self addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(15);
        }];
        leftLab.text = @"正式客户";
        leftLab.font = KFont(12);
        leftLab.textColor = KHexRGB(0x999999);
        
        UIButton *selectAllBtn = [UIButton new];
        selectAllBtn.titleLabel.font = KFont(14);
        selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [selectAllBtn setImage:KImageName(@"未选中") forState:UIControlStateNormal];
        [selectAllBtn setImage:KImageName(@"选中") forState:UIControlStateSelected];
        [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [selectAllBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [selectAllBtn addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectAllBtn];
        [selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (void)selectAllAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(didClickSelectAllButton:)]) {
        [self.delegate didClickSelectAllButton:sender.selected];
    }
}

@end
