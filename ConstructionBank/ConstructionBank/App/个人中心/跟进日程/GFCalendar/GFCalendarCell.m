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
        [self.todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(25);
        }];
        [self addSubview:self.pointView];
    }
    return self;
}

- (void)setModel:(CalendarDayModel *)model{
    _model = model;
}

- (StatePointView *)pointView{
    if (!_pointView) {
        _pointView = [[StatePointView alloc]initWithFrame:KFrame(0, self.height-18, self.width,18)];
        _pointView.backgroundColor = [UIColor grayColor];
        _pointView.model = _model;
    }
    return _pointView;
}

- (UIView *)todayCircle {
    if (_todayCircle == nil) {
        _todayCircle = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.8 * self.bounds.size.height, 0.8 * self.bounds.size.height)];
        _todayCircle.center = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
        _todayCircle.layer.cornerRadius = 0.5 * _todayCircle.frame.size.width;
    }
    return _todayCircle;
}

- (UILabel *)todayLabel {
    if (_todayLabel == nil) {
//        _todayLabel = [[UILabel alloc] initWithFrame:KFrame(0, 25, self.width, <#h#>)];
        _todayLabel = [UILabel new];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        _todayLabel.font = KFont(24);
        _todayLabel.backgroundColor = [UIColor clearColor];
    }
    return _todayLabel;
}

- (void)setDayType:(DayType)dayType{
    _dayType = dayType;
    if (dayType == DayTypeToday) {
        self.todayLabel.textColor = [UIColor greenColor];
    }else if(dayType == DayTypeThisMonth ){
        self.todayLabel.textColor = [UIColor darkGrayColor];
    }else{
        self.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    }
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.todayCircle.backgroundColor = kCalendarBasicColor;
        self.todayLabel.textColor = [UIColor whiteColor];
    }else{
        self.todayCircle.backgroundColor = [UIColor clearColor];
        if (_dayType == DayTypeToday) {
            self.todayLabel.textColor = [UIColor greenColor];
        }else if(_dayType == DayTypeThisMonth ){
            self.todayLabel.textColor = [UIColor darkGrayColor];
        }else{
            self.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        }
    }
}

@end
