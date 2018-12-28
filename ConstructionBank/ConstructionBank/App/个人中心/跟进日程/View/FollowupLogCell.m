//
//  FollowupLogCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowupLogCell.h"
#import "ContentInsetsLabel.h"

@interface FollowupLogCell ()


@property (nonatomic ,strong) UIView *detailBar;
@property (nonatomic ,strong) UIImageView *detailIcon;
@property (nonatomic ,strong) UILabel *detailCompLab;
@property (nonatomic ,strong) UILabel *detailDateLab;
@property (nonatomic ,strong) ContentInsetsLabel *detailStatusLab;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *phoneLab;
@property (nonatomic ,strong) UILabel *remarkLab;
@property (nonatomic ,strong) UILabel *addressLab;
@property (nonatomic ,strong) UIButton *detailExpBtn;
@property (nonatomic ,strong) UIButton *editBtn;
@property (nonatomic ,strong) FollowRecordModel *model;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@end

@implementation FollowupLogCell

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
        
        
        self.detailBar = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 6;
            [shadowView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(shadowView);
            }];
            view;
        });
        
        self.detailIcon = ({
            UIImageView *view = [UIImageView new];
            view.image = KImageName(@"正式合作");
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_detailBar).offset(15);
                make.top.mas_equalTo(_detailBar).offset(25);
                make.height.width.mas_equalTo(9);
            }];
            view;
        });
        
        self.detailCompLab = ({
            UILabel *view = [UILabel new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_detailIcon);
                make.left.mas_equalTo(_detailIcon.mas_right).offset(10);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        self.editBtn = ({
            UIButton *view = [UIButton new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_detailBar).offset(14);
                make.right.mas_equalTo(_detailBar).offset(-12);
                make.width.mas_equalTo(14);
                make.height.mas_equalTo(16);
            }];
            [view addTarget:self action:@selector(jumpToEdit) forControlEvents:UIControlEventTouchUpInside];
            [view setImage:KImageName(@"edit") forState:UIControlStateNormal];
            view;
        });
        
        self.detailStatusLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_detailIcon);
                make.top.mas_equalTo(_detailCompLab.mas_bottom).offset(10);
                make.height.mas_equalTo(20);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x1E9EFB);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view.layer.borderColor = KHexRGB(0x1E9EFB).CGColor;
            view.layer.borderWidth = .5;
            view.textAlignment = NSTextAlignmentCenter;
            view;
        });
        
        self.detailDateLab = ({
            UILabel *view = [UILabel new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_detailStatusLab);
                make.left.mas_equalTo(_detailStatusLab.mas_right).offset(15);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x089cfe);
            view;
        });
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_detailIcon);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"客户：";
            view;
        });

        self.phoneLab = ({
            UILabel *view = [UILabel new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_detailIcon);
                make.top.mas_equalTo(_nameLab.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"电话：";
            view;
        });

        self.remarkLab = ({
            UILabel *view = [UILabel new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_detailIcon);
                make.top.mas_equalTo(_phoneLab.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"备注：";
            view;
        });
        
        self.detailExpBtn = ({
            UIButton *view = [UIButton new];
            [view addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_remarkLab.mas_bottom).offset(15);
                make.right.mas_equalTo(_detailBar).offset(-5);
                make.width.mas_equalTo(30);
                make.height.mas_equalTo(20);
            }];
            [view setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            view;
            
        });
        
        UIImageView *icon = [UIImageView new];
        [icon setImage:KImageName(@"向上")];
        [_detailExpBtn addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(12.5);
            make.height.mas_equalTo(7);
            make.centerX.centerY.mas_equalTo(_detailExpBtn);
        }];
        
        
        self.addressLab = ({
            UILabel *view = [UILabel new];
            [_detailBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_detailIcon);
                make.right.mas_lessThanOrEqualTo(_detailExpBtn.mas_left);
                make.top.mas_equalTo(_remarkLab.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
                make.bottom.mas_equalTo(_detailBar).offset(-22);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"地点：";
            view;
        });
    }
    return self;
}

- (void)closeAction{
    NSLog(@"关闭");
    [self.delegate didClickClose:_indexPath];
}

- (void)jumpToEdit{
    NSLog(@"编辑");
    [self.delegate jumpToEditVc:_model];
}

- (void)setModel:(FollowRecordModel *)model atIndex:(NSIndexPath *)indexPath{
    _model = model;
    _indexPath = indexPath;
    _detailCompLab.text = model.companyname;
    _detailDateLab.text = model.time;
    _nameLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"客户：%@",model.name]];
    _phoneLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"电话：%@",model.phone]];
    _remarkLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"备注：%@",model.remark]];
    _addressLab.attributedText = [self getAttribureString:[NSString stringWithFormat:@"地址：%@", [NSString stringWithFormat:@"%@%@",model.address,model.detailAddress?:@""]]];
    int state = [model.followState intValue]-1;
    if (state>=0&&state<FOLLOWSTATES.count) {
        _detailStatusLab.text = FOLLOWSTATES[state];
        _detailIcon.image = KImageName(FOLLOWSTATES[state]);
    }else{
        _detailStatusLab.text = @"未跟进";
    }
    
    if (state == 4) {
        _detailStatusLab.textColor = KHexRGB(0x61d8fa);
        _detailStatusLab.layer.borderColor = KHexRGB(0x61d8fa).CGColor;
    }else if (state == 3){
        _detailStatusLab.textColor = KHexRGB(0xE47CB9);
        _detailStatusLab.layer.borderColor = KHexRGB(0xE47CB9).CGColor;
        
    }else if (state == 2){
        _detailStatusLab.textColor = KHexRGB(0xFF901F);
        _detailStatusLab.layer.borderColor = KHexRGB(0xFF901F).CGColor;
        
    }else if (state == 1){
        _detailStatusLab.textColor = KHexRGB(0x27D720);
        _detailStatusLab.layer.borderColor = KHexRGB(0x27D720).CGColor;
        
    }else{
        _detailStatusLab.textColor = KHexRGB(0xFA6161);
        _detailStatusLab.layer.borderColor = KHexRGB(0xFA6161).CGColor;
    }
    
}

- (NSAttributedString *)getAttribureString:(NSString *)str{
    NSMutableAttributedString *mats = [[NSMutableAttributedString alloc]initWithString:str];
    [mats addAttributes:@{NSForegroundColorAttributeName:KHexRGB(0x333333)} range:NSMakeRange(3, str.length-3)];
    return mats;
}


@end
