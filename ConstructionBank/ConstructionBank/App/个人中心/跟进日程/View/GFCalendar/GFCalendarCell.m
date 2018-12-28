//
//  GFCalendarCell.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFCalendarCell.h"
#import "StatePointView.h"
#define kCalendarBasicColor AppHTMLColor(@"4bccbc")

@interface GFCalendarCell ()
@property (nonatomic ,strong) StatePointView *pointView;
@end

@implementation GFCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.todayCircle];
        [self addSubview:self.todayLabel];
        [self addSubview:self.pointView];

        [self.todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(12.5);
        }];
        [self.todayCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_todayLabel);
            make.width.height.mas_equalTo(32.5);
        }];
    }
    return self;
}

- (void)setModel:(CalendarDayModel *)model{
    _model = model;
    self.pointView.model = _model;
}

- (StatePointView *)pointView{
    if (!_pointView) {
        _pointView = [[StatePointView alloc]initWithFrame:KFrame(0, self.height-9, self.width,9)];
        _pointView.model = _model;
    }
    return _pointView;
}

- (UIView *)todayCircle {
    if (_todayCircle == nil) {
        _todayCircle = [UIView new];
        _todayCircle.layer.cornerRadius = 0.5 * 32.5;
    }
    return _todayCircle;
}

- (UILabel *)todayLabel {
    if (_todayLabel == nil) {
        _todayLabel = [UILabel new];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        _todayLabel.font = KFont(16);
    }
    return _todayLabel;
}

- (void)setDayType:(DayType)dayType{
    _dayType = dayType;
    if (dayType == DayTypeToday) {
        self.todayLabel.textColor = KHexRGB(0xfc8933);
    }else if(dayType == DayTypeThisMonth ){
        self.todayLabel.textColor = [UIColor darkGrayColor];
    }else{
        self.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    }
}

- (void)setChoosed:(BOOL)choosed{
    if (choosed) {
        self.todayCircle.backgroundColor = KHexRGB(0xFB7B36);
        self.todayLabel.textColor = [UIColor whiteColor];
        self.pointView.hidden = YES;
    }else{
        self.todayCircle.backgroundColor = [UIColor clearColor];
        if (_dayType == DayTypeToday) {
            self.todayLabel.textColor = KHexRGB(0xfc8933);
        }else if(_dayType == DayTypeThisMonth ){
            self.todayLabel.textColor = [UIColor darkGrayColor];
        }else{
            self.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        }
        self.pointView.hidden = NO;
    }
}

@end
