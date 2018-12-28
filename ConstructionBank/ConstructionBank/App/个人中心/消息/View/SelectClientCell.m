//
//  SelectClientCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SelectClientCell.h"
#import "SearchClientModel.h"

@interface SelectClientCell ()
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UIImageView *iconView;
@end

@implementation SelectClientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.contentView).offset(-23);
            }];
            view.image = KImageName(@"未选中");
            view;
        });
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.contentView).offset(15);
                make.right.mas_lessThanOrEqualTo(_iconView.mas_left).offset(-10);
            }];
            view.textColor = KHexRGB(0x333333);
            view.font = KFont(16);
            view.text = @"北京三宝兴业视觉技术有限公司";
            view;
        });
        
    }
    return self;
}

- (void)setModel:(SearchClientModel *)model{
    _iconView.image = KImageName(model.selected?@"选中":@"未选中");
    _nameLab.text = model.name;
}

@end
