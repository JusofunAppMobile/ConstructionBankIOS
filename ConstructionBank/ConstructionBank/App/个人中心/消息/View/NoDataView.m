//
//  NoDataView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/10/8.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()
@property (nonatomic ,strong) UILabel *label;
@end

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.label = ({
            UILabel *view = [UILabel new];
            view.text = @"暂无数据";
            view.textColor = KHexRGB(0x909090);
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
            }];
            view;
        });
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    _label.text = text;
}

@end
