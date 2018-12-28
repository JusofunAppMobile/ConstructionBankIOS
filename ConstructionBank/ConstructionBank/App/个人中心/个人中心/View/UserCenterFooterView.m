//
//  UserCenterFooterView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UserCenterFooterView.h"

@implementation UserCenterFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {        
        UIButton *view = [UIButton new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(self.width-45*2);
        }];
        [view setBackgroundImage:KImageName(@"按钮背景") forState:UIControlStateNormal];
        [view setTitle:@"退出登录" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = KFont(15);
    }
    return self;
}


-(void)loginOut
{
    KUSER.userID = @"";
    [UserModel clearTable];
    [KNotificationCenter postNotificationName:KLoginOut object:nil];
}


@end
