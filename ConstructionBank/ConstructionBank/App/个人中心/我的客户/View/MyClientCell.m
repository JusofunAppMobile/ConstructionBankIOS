//
//  MyClientCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/12.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MyClientCell.h"
#import "MyClientModel.h"

@interface MyClientCell ()

@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *distanceLab;
@property (nonatomic ,strong) UILabel *addressLab;
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UIView *stateView;

@end

@implementation MyClientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *radiusView = [UIView new];
        radiusView.backgroundColor = [UIColor whiteColor];
        radiusView.layer.shadowColor =  [UIColor lightGrayColor].CGColor;;
        radiusView.layer.shadowOffset = CGSizeMake(0.1, .1);//0,-3
        radiusView.layer.shadowRadius = 2;//0,-3
        radiusView.layer.shadowOpacity = 0.8;
        radiusView.layer.cornerRadius = 5;
        [self.contentView addSubview:radiusView];
        [radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(self.contentView).offset(5);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
        }];
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(radiusView).offset(20);
                make.left.mas_equalTo(15);
                make.width.mas_equalTo(11);
                make.height.mas_equalTo(15);
            }];
            view.image = KImageName(@"图例蓝");
            view;
        });
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_iconView.mas_right).offset(7);
                make.top.mas_equalTo(_iconView);
                make.right.mas_equalTo(radiusView).offset(-15);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        self.addressLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_iconView.mas_bottom).offset(15);
                make.left.mas_equalTo(_iconView);
                make.height.mas_equalTo(14);
            }];
            view.textColor = KHexRGB(0x666666);
            view.font = KFont(13);
            view;
        });
        
        self.distanceLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_addressLab.mas_right).offset(10);
                make.right.mas_lessThanOrEqualTo(radiusView).offset(-15);
                make.top.mas_equalTo(_addressLab);
            }];
            [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            view.textColor = KHexRGB(0x666666);
            view.font = KFont(13);
            view;
        });
        
        self.stateView = ({
            UIView *view = [UIView new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(radiusView);
                make.right.mas_equalTo(radiusView);
                make.top.mas_equalTo(_addressLab.mas_bottom);
                make.height.mas_equalTo(25).priorityHigh();
            }];
            view;
        });
       

        UILabel *stateLab = [UILabel new];
        stateLab.textColor = KHexRGB(0x999999);
        stateLab.font = KFont(14);
        stateLab.text = @"跟进状态：";
        [_stateView addSubview:stateLab];
        [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stateView).offset(10);
            make.left.mas_equalTo(_stateView).offset(15);
            make.width.mas_equalTo(85);
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
            view.textColor = KHexRGB(0xfb7c36);
            view;
        });
        
        UIView *bottomView = ({
            UIView *view = [UIView new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_stateView.mas_bottom).offset(15);
                make.left.right.bottom.mas_equalTo(radiusView);
                make.height.mas_equalTo(47).priorityHigh(1000);
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
                make.height.mas_equalTo(27);
                make.width.mas_equalTo(80);
            }];
            view.layer.cornerRadius = 13;
            view.layer.masksToBounds = YES;
            view.layer.borderColor = KHexRGB(0X999999).CGColor;
            view.layer.borderWidth = .5f;
            view.titleLabel.font = KFont(15);
            [view setTitleColor:KHexRGB(0x1E9EFB) forState:UIControlStateNormal];
            [view addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
        
        self.leftBtn = ({
            UIButton *view = [UIButton new];
            [bottomView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_rightBtn.mas_left).offset(-15);
                make.centerY.mas_equalTo(bottomView);
                make.height.mas_equalTo(27);
                make.width.mas_equalTo(80);
            }];
            view.layer.cornerRadius = 13;
            view.layer.masksToBounds = YES;
            view.layer.borderColor = KHexRGB(0X999999).CGColor;
            view.layer.borderWidth = .5f;
            view.titleLabel.font = KFont(15);
            [view setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
            [view addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
    }
    return self;
}

- (void)setModel:(MyClientModel *)model{
    _model = model;
    _nameLab.text = model.companyName;
    _distanceLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"距您%d米",[model.distance intValue]]];
    _addressLab.text = model.address;
    
    int state = [model.followState intValue]-1;
    if (state>=0&&state<FOLLOWSTATES.count) {
        _stateLab.text = FOLLOWSTATES[state];
    }else{
        _stateLab.text = @"未跟进";
    }
    
    if (model.type.intValue == 2){
        _iconView.image = KImageName(@"图例绿");
        _leftBtn.hidden = YES;
        [_rightBtn setTitle:@"跟进日志" forState: UIControlStateNormal];
        [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
    }else{
        _iconView.image = KImageName(@"图例蓝");
        _leftBtn.hidden = NO;
        [_rightBtn setTitle:@"跟进日志" forState: UIControlStateNormal];
        [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
        
        [_leftBtn setTitle:@"产品营销" forState: UIControlStateNormal];
        [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
    }

}


- (NSAttributedString *)getAttribureString:(NSString *)str{
    NSMutableAttributedString *mats = [[NSMutableAttributedString alloc]initWithString:str];
    [mats addAttributes:@{NSForegroundColorAttributeName:KHexRGB(0xfb7c36)} range:NSMakeRange(2, str.length-3)];
    return mats;
}


- (void)rightAction{
    if ([self.delegate respondsToSelector:@selector(jumpToFollowRecordVC:)]) {
        [self.delegate jumpToFollowRecordVC:_model.companyId];
    }
}

- (void)leftAction{
    if ([self.delegate respondsToSelector:@selector(jumpToMessagePushVC:)]) {
        [self.delegate jumpToMessagePushVC:_model.companyId];
    }
}

@end

