//
//  CompanyDetailInfoCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CompanyDetailInfoCell.h"
#import "CompanyDetailModel.h"

@interface CompanyDetailInfoCell ()

@property (nonatomic ,strong) UIImageView *bgView;
@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *distanceLab;
@property (nonatomic ,strong) UILabel *addressLab;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UIView *stateView;
@property (nonatomic ,strong) CompanyDetailModel *model;
@property (nonatomic ,assign) NSInteger companyType;

@end

@implementation CompanyDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bgView = ({//阴影上4，下6
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(10);
                make.right.mas_equalTo(self.contentView).offset(-10);
                make.bottom.mas_equalTo(self.contentView);
                make.top.mas_equalTo(self.contentView).offset(10);
            }];
            view.userInteractionEnabled = YES;
            view;
        });
        
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_bgView).offset(20+4);
                make.left.mas_equalTo(15+5);
                make.width.mas_equalTo(11);
                make.height.mas_equalTo(15);
            }];
            view;
        });
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_iconView.mas_right).offset(7);
                make.top.mas_equalTo(_iconView);
                make.right.mas_equalTo(_bgView).offset(-15);
                make.height.mas_equalTo(16).priorityHigh();
            }];
            view.font = KFont(16);
            view.textColor = [UIColor whiteColor];
            view;
        });
        
        self.addressLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_iconView.mas_bottom).offset(15);
                make.left.mas_equalTo(_iconView);
                make.height.mas_equalTo(14).priorityHigh();
            }];
            view.textColor = [UIColor whiteColor];
//            view.numberOfLines = 0;
            view.font = KFont(13);
            view;
        });
        
        self.distanceLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_addressLab.mas_right).offset(10);
                make.right.mas_lessThanOrEqualTo(_bgView).offset(-15);
                make.top.mas_equalTo(_addressLab);
            }];
            view.textColor = [UIColor whiteColor];
            view.font = KFont(13);
            view;
        });
        
        
        self.stateView = ({
            UIView *view = [UIView new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgView);
                make.right.mas_equalTo(_bgView);
                make.top.mas_equalTo(_addressLab.mas_bottom);
                make.height.mas_equalTo(0).priorityHigh();
            }];
            view.hidden = YES;
            view;
        });
        
        
        UILabel *stateLab = [UILabel new];
        stateLab.textColor = [UIColor whiteColor];
        stateLab.font = KFont(14);
        stateLab.text = @"跟进状态：";
        [_stateView addSubview:stateLab];
        [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stateView).offset(15);
            make.left.mas_equalTo(_iconView);
        }];
        
        self.stateLab = ({
            UILabel *view = [UILabel new];
            [_stateView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(stateLab.mas_right);
                make.top.height.mas_equalTo(stateLab);
                make.right.mas_equalTo(_stateView).offset(-15);
            }];
            view.font = KFont(14);
            view.textColor = [UIColor whiteColor];
            view;
        });
        
        UIView *bottomView = ({
            UIView *view = [UIView new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_stateView.mas_bottom).offset(15);
                make.left.mas_equalTo(_bgView).offset(5);
                make.right.mas_equalTo(_bgView).offset(-5);//左右阴影
                make.height.mas_equalTo(47).priorityHigh();
                make.bottom.mas_equalTo(_bgView).offset(-6);//6阴影
            }];
            view;
        });
        
        UIView *line = [UIView new];
        [bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(bottomView);
            make.height.mas_equalTo(.5);
        }];
        line.backgroundColor = [UIColor whiteColor];
        
        self.recordBtn = ({
            UIButton *view = [UIButton new];
            [bottomView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(bottomView).offset(-15);
                make.centerY.mas_equalTo(bottomView);
                make.height.mas_equalTo(27);
                make.width.mas_equalTo(80);
            }];
            view.layer.cornerRadius = 13;
            view.layer.masksToBounds = YES;
            view.layer.borderColor = [UIColor whiteColor].CGColor;
            view.layer.borderWidth = .5f;
            view.titleLabel.font = KFont(15);
            [view setTitle:@"跟进记录" forState:UIControlStateNormal];
            [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            view;
        });
    }
    return self;
}

- (void)setModel:(CompanyDetailModel *)model type:(NSInteger)companyType{
    
    _companyType = companyType;
    _model = model;
    _nameLab.text = model.companyName;
    _addressLab.text = model.address;
    _distanceLab.text = [NSString stringWithFormat:@"距您%@米",model.distance?:@""];
    
    int state = [model.followState intValue]-1;
    if (state>=0&&state<FOLLOWSTATES.count) {
        _stateLab.text = FOLLOWSTATES[state];
    }else{
        _stateLab.text = @"未跟进";
    }
    
    if (_companyType == 3) {
        _iconView.image = KImageName(@"详情蓝");
        _bgView.image = KImageName(@"企业信息蓝");
        [_recordBtn setTitle:@"跟进记录" forState: UIControlStateNormal];
        [_recordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
        
        _stateView.hidden = NO;
        [_stateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(29).priorityHigh();
        }];
        
    }else if (_companyType == 2){
        _iconView.image = KImageName(@"详情绿");
        _bgView.image = KImageName(@"企业信息绿");
        [_recordBtn setTitle:@"跟进记录" forState: UIControlStateNormal];
        [_recordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
        
        _stateView.hidden = NO;
        [_stateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(29).priorityHigh();
        }];
    }else {
        _iconView.image = KImageName(@"详情橙");
        _bgView.image = KImageName(@"企业信息黄");
        [_recordBtn setTitle:@"标记为目标客户" forState: UIControlStateNormal];
        [_recordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(115);
        }];
        _stateView.hidden = YES;
        [_stateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).priorityHigh();
        }];
    }
}

@end
