//
//  AddFollowUPLogHeader.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/3.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AddFollowUPLogHeader.h"

@interface AddFollowUPLogHeader ()

@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UIButton *addBtn;
@end

@implementation AddFollowUPLogHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconView = ({
            UIImageView *view = [UIImageView new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(15);
            }];
            view.image = KImageName(@"标题标签");
            view;
        });
     
        self.titleLab = ({
            UILabel *view = [UILabel new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(iconView.mas_right).offset(8);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view.text = @"客户信息";
            view;
        });
        
    }
    return self;
}

- (void)setSection:(NSInteger)section{
    _section = section;
    if (_section == 1) {
        _titleLab.text = @"客户信息";
    }else if (_section == 2){
        _titleLab.text = @"业务进度";
    }else if (_section == 3){
        _titleLab.text = @"业务支持";
    }else{
        _titleLab.text = @"备注";
    }
}





@end
