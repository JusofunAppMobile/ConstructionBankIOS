//
//  CompanyListCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CompanyListCell.h"
#import "ContentInsetsLabel.h"
#import "CompanyListModel.h"

@interface CompanyListCell ()

@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *industryLab;
@property (nonatomic ,strong) UILabel *cityLab;
@property (nonatomic ,strong) UILabel *moneyLab;
@property (nonatomic ,strong) UILabel *legalPersonLab;
@property (nonatomic ,strong) UILabel *dateLab;
@property (nonatomic ,strong) UILabel *distanceLab;
@property (nonatomic ,strong) UILabel *addressLab;
@property (nonatomic ,strong) UILabel *statusLab;
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;

@end

@implementation CompanyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(13);
                make.top.mas_equalTo(20);
                make.right.mas_equalTo(self.contentView).offset(-35);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        
        self.industryLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_nameLab.mas_bottom).offset(10);
                make.left.mas_equalTo(_nameLab);
                make.height.mas_equalTo(20);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x999999);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.textAlignment = NSTextAlignmentCenter;
            [view sizeToFit];
            view;
        });
        
        self.cityLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.mas_equalTo(_industryLab);
                make.left.mas_equalTo(_industryLab.mas_right).offset(10);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x999999);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.textAlignment = NSTextAlignmentCenter;
            [view sizeToFit];
            view;
        });
        
        self.moneyLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.mas_equalTo(_industryLab);
                make.left.mas_equalTo(_cityLab.mas_right).offset(10);
                make.right.mas_lessThanOrEqualTo(-15);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x999999);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.textAlignment = NSTextAlignmentCenter;
            [view sizeToFit];
            view;
        });
        
        
        self.dateLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-15);
                make.top.mas_equalTo(_industryLab.mas_bottom).offset(22);
            }];
            view.font = KFont(13);
            view.textAlignment = NSTextAlignmentRight;
            view;
        });
        
        self.legalPersonLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_industryLab);
                make.right.mas_equalTo(_dateLab.mas_left).offset(-5);
                make.top.mas_equalTo(_dateLab);
            }];
            view.font = KFont(13);
            view;
        });
        
        self.distanceLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_legalPersonLab.mas_bottom).offset(10);
                make.left.mas_equalTo(_industryLab);
            }];
            view.font = KFont(13);
            view;
        });
        
        self.addressLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_distanceLab.mas_right).offset(20);
                make.right.mas_equalTo(self.contentView).offset(-15);
                make.top.mas_equalTo(_distanceLab);
            }];
            view.numberOfLines = 0;
            view.font = KFont(13);
            view;
        });
        
       
        UIView *bottomView = ({
            UIView *view = [UIView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_addressLab.mas_bottom).offset(10);
                make.left.right.bottom.mas_equalTo(self.contentView);
                make.height.mas_equalTo(60);
            }];
            view;
        });

        UIView *line = [UIView new];
        [bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(bottomView);
            make.height.mas_equalTo(.5);
        }];
        line.backgroundColor = KHexRGB(0xcccccc);

        self.rightBtn = ({
            UIButton *view = [UIButton new];
            [bottomView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(bottomView).offset(-15);
                make.centerY.mas_equalTo(bottomView);
            }];
            view.backgroundColor = [UIColor grayColor];
            view.titleLabel.font = KFont(14);
            [view setTitle:@"跟进记录" forState:UIControlStateNormal];
            [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            view;
        });

        self.leftBtn = ({
            UIButton *view = [UIButton new];
            [bottomView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_rightBtn.mas_left).offset(-30);
                make.centerY.mas_equalTo(bottomView);
            }];
            view.backgroundColor = [UIColor grayColor];
            view.titleLabel.font = KFont(14);
            [view setTitle:@"信息推送" forState:UIControlStateNormal];
            [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            view;
        });
        
        
        
        
    }
    return self;
}


- (void)setModel:(CompanyListModel *)model{
    
    _nameLab.text = model.companyName;
    _industryLab.text = model.industry;
    _cityLab.text = model.city;
    _moneyLab.text = model.money;
    _legalPersonLab.text = model.legalPerson;
    _dateLab.text = model.date;
    _distanceLab.text = model.distance;
    _addressLab.text = model.address;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
