//
//  EditMessageHeader.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "EditMessageHeader.h"

@interface EditMessageHeader ()
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UIView *bgView;

@end

@implementation EditMessageHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgView = ({
            UIView *bgView = [UIView new];
            [self addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(0);
            }];
            bgView;
        });
        
        UIImageView *iconView = ({
            UIImageView *view = [UIImageView new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_bgView);
                make.left.mas_equalTo(15);
            }];
            view.image = KImageName(@"标题标签");
            view;
        });
        
        self.titleLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_bgView);
                make.left.mas_equalTo(iconView.mas_right).offset(8);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });

        UIView *topLine = [UIView new];
        topLine.backgroundColor = KHexRGB(0xf2f2f2);
        [_bgView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(_bgView);
            make.height.mas_equalTo(1);
        }];
        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = KHexRGB(0xf2f2f2);
        [_bgView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_bgView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setSection:(NSInteger)section{
    _section = section;
    if (_section == 0) {
        _titleLab.text = @"编辑消息";
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
        }];
    }else{
        _titleLab.text = @"历史消息";
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-10);
        }];
    }
}


@end
