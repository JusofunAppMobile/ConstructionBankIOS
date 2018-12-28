//
//  UserHeaderView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()
@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *positionLab;
@end

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *kongView = [[UIView alloc]init];
        kongView.backgroundColor = KRGB(240, 240, 246);
        [self addSubview:kongView];
        [kongView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.height.mas_equalTo(10);
        }];
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(15);
                make.top.mas_equalTo(kongView.mas_bottom).offset(5);
                make.height.width.mas_equalTo(60);
            }];
            view.image = KImageName(@"AppIcon");
            view.layer.cornerRadius = 30;
            view.layer.masksToBounds = YES;
            view;
        });
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.iconView.mas_right).offset(10);
                make.height.mas_equalTo(15);
                make.right.mas_equalTo(self).offset(-15);
                make.top.mas_equalTo(kongView.mas_bottom).offset(15);
            }];
            view.textAlignment = NSTextAlignmentLeft;
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });

        self.positionLab = ({
            UILabel *view = [UILabel new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.right.left.mas_equalTo(self.nameLab);
                make.top.mas_equalTo(_nameLab.mas_bottom).offset(10);
            }];
            view.textAlignment = NSTextAlignmentLeft;
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;

        });
        
        UIView *kongView2 = [[UIView alloc]init];
        kongView2.backgroundColor = KRGB(240, 240, 246);
        [self addSubview:kongView2];
        [kongView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(15);
        }];
        
        
    }
    return self;
}


-(void)reloadInfo
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:KUSER.headIcon] placeholderImage:KImageName(@"AppIcon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
 
    self.nameLab.text = KUSER.realName;
    self.positionLab.text = KUSER.organName;
}









@end
