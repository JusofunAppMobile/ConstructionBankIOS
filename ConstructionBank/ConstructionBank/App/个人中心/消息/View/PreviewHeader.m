//
//  PreviewHeader.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "PreviewHeader.h"

@interface PreviewHeader ()
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UILabel *timeLab;
@end
@implementation PreviewHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KHexRGB(0xf3f3f3);
        
        self.titleLab = ({
            UILabel *leftLab = [UILabel new];
            [self addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(15);
            }];
            leftLab.font = KFont(12);
            leftLab.textColor = KHexRGB(0x999999);
            leftLab;
        });
        
        self.timeLab = ({
            UILabel *leftLab = [UILabel new];
            [self addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(-15);
            }];
            leftLab.hidden = YES;
            leftLab.font = KFont(12);
            leftLab.textColor = KHexRGB(0x999999);
            leftLab;
        });
    }
    return self;
}

- (void)setSection:(NSInteger)section{
    _section = section;
    if (_section == 0 ) {
        _timeLab.hidden = NO;
        _timeLab.text = [self getDateString];
        _titleLab.text = @"消息推送";
    }else{
        _timeLab.hidden = YES;
        _titleLab.text = @"接收客户";
    }
}

- (NSString *)getDateString{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.AMSymbol = @"上午";
    formatter.PMSymbol = @"下午";
    [formatter setDateFormat:@"aaa h:mm"];
    
    NSString *str = [formatter stringFromDate:date];
    return str;
}

@end
