//
//  FollowUpRecordCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowUpRecordCell.h"
#import "FollowRecordModel.h"

@interface FollowUpRecordCell ()
@property (nonatomic ,strong) UIView *dotview;
@property (nonatomic ,strong) UILabel *dateLab;
@property (nonatomic ,strong) UILabel *stateLab;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *phoneLab;
@property (nonatomic ,strong) UILabel *positionLab;
@property (nonatomic ,strong) UILabel *remarkLab;
@property (nonatomic ,strong) UILabel *addressLab;
@end

@implementation FollowUpRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *shadowView = [UIView new];
        shadowView.layer.shadowColor =  [UIColor lightGrayColor].CGColor;;
        shadowView.layer.shadowOffset = CGSizeMake(0.1, -0.1);//0,-3
        shadowView.layer.shadowOpacity = 0.8;
        shadowView.layer.shadowRadius = 3;
        shadowView.layer.cornerRadius = 3;
        [self.contentView addSubview:shadowView];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(13);
            make.right.mas_equalTo(self.contentView).offset(-13);
            make.top.mas_equalTo(self.contentView).offset(5);
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
        

        self.dotview = ({
            UIView *view = [UIView new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(radiusView).offset(15);
                make.top.mas_equalTo(radiusView).offset(25);
                make.height.width.mas_equalTo(8.5);
            }];
            view.layer.cornerRadius = 4.25;
            view.backgroundColor = [UIColor orangeColor];
            view;
        });
        
        self.dateLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_dotview.mas_right).offset(8);
                make.top.mas_equalTo(radiusView).offset(21);
                make.width.mas_equalTo(150);
                make.height.mas_equalTo(16);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        self.stateLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(radiusView).offset(-15);
                make.top.mas_equalTo(_dateLab);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x1e9efb);
            view;
        });
        
        UILabel *statusTitle = [UILabel new];
        [radiusView addSubview:statusTitle];
        [statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_stateLab.mas_left);
            make.top.mas_equalTo(_stateLab);
            make.height.mas_equalTo(14);
            make.left.mas_greaterThanOrEqualTo(_dateLab.mas_right);
        }];
        statusTitle.text = @"状态：";
        statusTitle.textColor = KHexRGB(0x999999);
        statusTitle.font = KFont(14);
        statusTitle.textAlignment = NSTextAlignmentRight;
        
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(radiusView).offset(15);
                make.top.mas_equalTo(_dotview.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view;
        });
        
        self.phoneLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(radiusView).offset(15);
                make.top.mas_equalTo(_nameLab.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view;
        });
        
        self.positionLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(radiusView).offset(15);
                make.top.mas_equalTo(_phoneLab.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view;
        });
        
        UILabel *remarkTitle = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(radiusView).offset(15);
                make.top.mas_equalTo(_positionLab.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
                make.width.mas_equalTo(43);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"备注：";
            view;
        });
        
        self.remarkLab = ({
            UILabel *view = [UILabel new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(remarkTitle.mas_right);
                make.right.mas_equalTo(radiusView).offset(-15);
                make.top.mas_equalTo(remarkTitle);
                make.height.mas_greaterThanOrEqualTo(remarkTitle);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view.numberOfLines = 2;
            view;
        });

        UIView *bottomView = ({
            UIView *view = [UIView new];
            [radiusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_remarkLab.mas_bottom).offset(15);
                make.left.right.mas_equalTo(radiusView);
                make.bottom.mas_equalTo(radiusView);
                make.height.mas_equalTo(30);
            }];
            view.backgroundColor = KHexRGB(0xfff5e9);
            view;
        });
    
        UIImageView *locateIcon = ({
            UIImageView *view = [UIImageView new];
            [bottomView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(bottomView);
                make.left.mas_equalTo(bottomView).offset(15);
            }];
            view.image = KImageName(@"跟进位置");
            view;
        });
        
        self.addressLab = ({
            UILabel *view = [UILabel new];
            [bottomView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(locateIcon.mas_right).offset(6);
                make.centerY.mas_equalTo(bottomView);
                make.right.mas_lessThanOrEqualTo(bottomView).offset(-15);
            }];
            view.font = KFont(10);
            view.textColor = KHexRGB(0xc48964);
            view;
        });
    }
    return self;
}

- (void)setModel:(FollowRecordModel *)model{
    _model = model;
    _dateLab.text = model.time;
    _nameLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"客户：%@",model.name]];
    _phoneLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"电话：%@",model.phone]];
    _positionLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"职位：%@",model.job]];
    _remarkLab.text = model.remark;
    _addressLab.text = [NSString stringWithFormat:@"%@%@",model.address,model.detailAddress?:@""];
    
    int state = [model.followState intValue]-1;
    if (state>=0&&state<FOLLOWSTATES.count) {
        _stateLab.text = FOLLOWSTATES[state];
    }
}

- (NSAttributedString *)getAttribureString:(NSString *)str{
    NSMutableAttributedString *mats = [[NSMutableAttributedString alloc]initWithString:str];
    [mats addAttributes:@{NSForegroundColorAttributeName:KHexRGB(0x333333)} range:NSMakeRange(3, str.length-3)];
    return mats;
}

@end
