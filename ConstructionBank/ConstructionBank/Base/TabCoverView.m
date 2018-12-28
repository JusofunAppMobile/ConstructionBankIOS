//
//  TabCoverView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "TabCoverView.h"
#import "UIView+GradientColor.h"

@interface TabCoverView ()
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;
@property (nonatomic ,strong) UIButton *midBtn;
@property (nonatomic ,assign) NSInteger index;

@end

@implementation TabCoverView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setGradientColor:@[(__bridge id)KHexRGB(0xFC8E32).CGColor,(__bridge id)KHexRGB(0xFFB22C).CGColor] locations:@[@.5,@1]];

        self.leftBtn = ({
            UIButton *btn1 = [UIButton new];
            [self addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(self);
                make.width.mas_equalTo((self.width-2)/3);
                make.height.mas_equalTo(49);
            }];
            [btn1 setTitleColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateNormal];
            [btn1 setTitleColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateSelected];
            [btn1 setTitle:@"地图显示" forState:UIControlStateNormal];
            btn1.titleLabel.font = KFont(15);
            btn1;
        });
        
        UIView *lineView1 = [UIView new];
        lineView1.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        [self addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftBtn.mas_right);
            make.top.mas_equalTo(self).offset(6);
            make.height.mas_equalTo(49-6*2);
            make.width.mas_equalTo(1);
        }];
        
        self.midBtn = ({
            UIButton *btn1 = [UIButton new];
            [self addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lineView1.mas_right);
                make.top.mas_equalTo(self);
                make.width.mas_equalTo((self.width-2)/3);
                make.height.mas_equalTo(49);
            }];
            [btn1 setTitleColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateNormal];
            [btn1 setTitleColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateSelected];
            [btn1 setTitle:@"列表显示" forState:UIControlStateNormal];
            btn1.titleLabel.font = KFont(14);
            btn1;
        });
        
        UIView *lineView2 = [UIView new];
        lineView2.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        [self addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_midBtn.mas_right);
            make.top.mas_equalTo(self).offset(6);
            make.height.mas_equalTo(49-6*2);
            make.width.mas_equalTo(1);
        }];
        
        self.rightBtn = ({
            UIButton *btn1 = [UIButton new];
            [self addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lineView2.mas_right);
                make.top.mas_equalTo(self);
                make.width.mas_equalTo((self.width-2)/3);
                make.height.mas_equalTo(49);
            }];
            [btn1 setTitleColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateNormal];
            [btn1 setTitleColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateSelected];
            [btn1 setTitle:@"个人中心" forState:UIControlStateNormal];
            btn1.titleLabel.font = KFont(14);
            btn1;
        });
        
        
      
        
        [self setIndex:0 title:nil];
    }
    return self;
}

- (void)setIndex:(NSInteger)index title:(NSString *)title{
    _index = index;
    if (index == 0) {
        _leftBtn.selected = YES;
        _leftBtn.titleLabel.font = KFont(15);
        
        _midBtn.selected = NO;
        _midBtn.titleLabel.font = KFont(14);
        
        _rightBtn.selected = NO;
        _rightBtn.titleLabel.font = KFont(14);
    }else if (index == 1){
        _leftBtn.selected = NO;
        _leftBtn.titleLabel.font = KFont(14);
        
        _midBtn.selected = YES;
        _midBtn.titleLabel.font = KFont(15);
        
        _rightBtn.selected = NO;
        _rightBtn.titleLabel.font = KFont(14);
        
    }else{
        _leftBtn.selected = NO;
        _leftBtn.titleLabel.font = KFont(14);
        
        _midBtn.selected = NO;
        _midBtn.titleLabel.font = KFont(14);
        
        _rightBtn.selected = YES;
        _rightBtn.titleLabel.font = KFont(15);
    }
    
    if (title) {
        [_leftBtn setTitle:title forState: UIControlStateNormal];
    }
}



@end
