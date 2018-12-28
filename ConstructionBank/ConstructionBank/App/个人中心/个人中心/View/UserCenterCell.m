//
//  UserCenterCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UserCenterCell.h"

@interface UserCenterCell ()



@end

@implementation UserCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(15);
                make.width.height.mas_equalTo(25);
            
            }];
            view;
        });

        self.titleLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(_iconView.mas_right).offset(10);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x666666);
            view;
        });
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = KRGB(235, 232, 230);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(self).offset(0);
            make.width.mas_equalTo(KDeviceW);
        }];
        
    }
    return self;
}

- (void)setRow:(NSInteger)row{
    if (row == 0) {
        _titleLab.text = @"我的客户";
        _iconView.image = KImageName(@"我的客户");
    }else if (row == 1){
        _titleLab.text = @"消息推送";
        _iconView.image = KImageName(@"消息推送");
    }
    else
    {
        _titleLab.text = @"统计分析";
        _iconView.image = KImageName(@"消息推送");
    }
}

@end
