//
//  AddFollowFooter.m
//  ConstructionBank
//
//  Created by wzh on 2018/12/23.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AddFollowFooter.h"
#import <UIButton+LXMImagePosition.h>

@interface AddFollowFooter ()
@property (nonatomic ,strong)UIButton *leftBtn;
@property (nonatomic ,strong)UIButton *rightBtn;
@property (nonatomic ,strong)NSMutableDictionary *contentDic;
@property (nonatomic ,assign)NSInteger selectedIndex;
@end
@implementation AddFollowFooter

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *checkLab = [UILabel new];
        checkLab.text = @"以上情况是否已解决：";
        checkLab.font = KFont(13);
        checkLab.textColor = KHexRGB(0x999999);
        [self addSubview:checkLab];
        [checkLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
        }];
        
        self.leftBtn = ({
            UIButton *view = [UIButton new];
            view.tag = BASE_TAG;
            view.titleLabel.font = KFont(13);
            [view setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
            [view setTitle:@"未解决" forState:UIControlStateNormal];
            [view setImage:KImageName(@"未选中") forState:UIControlStateNormal];
            [view setImage:KImageName(@"选中") forState:UIControlStateSelected];
            [view addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(checkLab.mas_right).offset(10);
            }];
            view;
        });
        
        self.rightBtn = ({
            UIButton *view = [UIButton new];
            view.tag = BASE_TAG+1;
            view.titleLabel.font = KFont(13);
            [view setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
            [view setTitle:@"已解决" forState:UIControlStateNormal];
            [view setImage:KImageName(@"未选中") forState:UIControlStateNormal];
            [view setImage:KImageName(@"选中") forState:UIControlStateSelected];
            [view addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(_leftBtn.mas_right).offset(10);
            }];
            view;
        });
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = KHexRGB(0xf2f2f2);//test
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.right.bottom.mas_equalTo(self);
        }];
        
        [self layoutIfNeeded];
        [_leftBtn setImagePosition:LXMImagePositionRight spacing:5];
        [_rightBtn setImagePosition:LXMImagePositionRight spacing:5];
        
    }
    return self;;
}

- (void)setContent:(NSMutableDictionary *)content section:(NSInteger)section{
    _contentDic = content;
    _section = section;
    _selectedIndex = [content[@"isDemandSolved"] boolValue]?1:0;
    
    if (section == 2) {
        _leftBtn.selected = ![content[@"isDemandSolved"] boolValue];
        _rightBtn.selected = [content[@"isDemandSolved"] boolValue];
    }else{
        _leftBtn.selected = ![content[@"isSupportSolved"] boolValue];
        _rightBtn.selected = [content[@"isSupportSolved"] boolValue];
    }
}

- (void)checkAction:(UIButton *)sender{
    
    if (sender.tag == _selectedIndex) {
        return;
    }
    
    if ([sender isEqual:_leftBtn]) {
        _rightBtn.selected = NO;
        _leftBtn.selected = YES;
    }else{
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
    }
    if (_section == 2) {
        [_contentDic setObject:_rightBtn.selected?@"1":@"0" forKey:@"isDemandSolved"];
    }else{
        [_contentDic setObject:_rightBtn.selected?@"1":@"0" forKey:@"isSupportSolved"];
    }

}



@end
