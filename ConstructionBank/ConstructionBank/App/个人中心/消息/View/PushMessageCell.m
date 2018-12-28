//
//  PushMessageCell.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "PushMessageCell.h"
#import "MsgListModel.h"
#import "Tools.h"
#import "NSDate+ZJPickerView.h"

@implementation PushMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(PushMessageType)type{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _pushMessageType = type;
        self.timeLabel = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).offset(10);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KRGB(159, 159, 159);
            view.textAlignment = NSTextAlignmentCenter;
            view;
        });
        
        /*
         ----------------------------圆角阴影------------------
         */
        UIView *shadowView = [UIView new];
        shadowView.layer.shadowColor =  [UIColor lightGrayColor].CGColor;;
        shadowView.layer.shadowOffset = CGSizeMake(-0.1, -0.1);//0,-3
        shadowView.layer.shadowOpacity = 0.5;
        shadowView.layer.shadowRadius = 3;
        shadowView.layer.cornerRadius = 3;
        [self.contentView addSubview:shadowView];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(13);
            make.right.mas_equalTo(self.contentView).offset(-13);
            make.top.mas_equalTo(_timeLabel.mas_bottom).offset(15);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
        }];
        
        
        UIView *radiusView = [UIView new];
        radiusView.backgroundColor = [UIColor whiteColor];
        radiusView.layer.masksToBounds = YES;
        radiusView.layer.cornerRadius = 6;
        [shadowView addSubview:radiusView];
        [radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(shadowView);
        }];
        
        /*
         ---------------------------------topView-------------------
         */
        UIView *topView = [UIView new];
        topView.hidden = type == PushMessageAloneType;
        topView.backgroundColor = KHexRGB(0xfff5e9);
        [radiusView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(radiusView);
            make.height.mas_equalTo(type == PushMessagemoreType?35:0);
        }];
        
        
        self.companyLabel = ({
            UILabel *view = [UILabel new];
            [topView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(topView).offset(10);
                make.right.mas_equalTo(topView).offset(-10);
                make.centerY.mas_equalTo(topView);
            }];
            view.font = KFont(14);
            view.textColor = KRGB(197, 142, 109);
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        
        self.contentLabel = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(radiusView).offset(15);
                make.right.mas_equalTo(radiusView).offset(-15);
                make.top.mas_equalTo(topView.mas_bottom).offset(15);
                make.bottom.mas_equalTo(radiusView).offset(-15);
            }];
            view.numberOfLines = 0;
            view.font = KFont(14);
            view.textColor = KRGB(105, 105, 105);
            view;
        });
    }
    return self;
}

- (void)setModel:(MsgListModel *)model{
    _model = model;
    
    NSDate *date = [Tools timestampSwitchDate:model.pushDate];
    NSString *dateString = @"";
    NSString *noonString = date.zj_hour < 12 ?@"上午":@"下午";
    
    int value = [date zj_compare:[NSDate date] format:@"yyyy-MM-dd"];//0表示为今天
    if (value == 0) {//今天
        dateString = [NSString stringWithFormat:@"%@ %@",noonString,[Tools timestampSwitchTime:model.pushDate formatter:@"HH:mm"]];
    }else{
        dateString = [Tools timestampSwitchTime:model.pushDate formatter:@"yyyy-MM-dd HH:mm"];
    }
    self.timeLabel.text = dateString;
    self.companyLabel.text = model.company;
    self.contentLabel.text = model.message;
}



@end
