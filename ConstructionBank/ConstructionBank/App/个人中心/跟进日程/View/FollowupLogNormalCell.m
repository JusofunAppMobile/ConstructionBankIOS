//
//  FollowupLogNormalCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowupLogNormalCell.h"

@interface FollowupLogNormalCell ()
@property (nonatomic ,strong) UIView *titleBar;
@property (nonatomic ,strong) UIImageView *titleIcon;
@property (nonatomic ,strong) UILabel *titleCompLab;
@property (nonatomic ,strong) UILabel *titleDateLab;
@property (nonatomic ,strong) UIButton *titleExpBtn;
@property (nonatomic ,strong) NSDictionary *imageDic;
@end

@implementation FollowupLogNormalCell

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
        
        
         self.titleBar = ({
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
        
        self.titleIcon = ({
            UIImageView *view = [UIImageView new];
            view.image = KImageName(@"正式合作");
            [_titleBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_titleBar).offset(15);
                make.centerY.mas_equalTo(_titleBar);
                make.height.width.mas_equalTo(9);
            }];
            view;
        });
        
        self.titleCompLab = ({
            UILabel *view = [UILabel new];
            [_titleBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_titleIcon.mas_right).offset(10);
                make.centerY.mas_equalTo(_titleBar);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        self.titleExpBtn = ({
            UIButton *view = [UIButton new];
            [_titleBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_titleBar).offset(-10);
                make.centerY.mas_equalTo(_titleBar);
                make.width.mas_equalTo(12.5);
                make.height.mas_equalTo(7);
            }];
            [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [view setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [view setImage:KImageName(@"灰色三角下拉") forState:UIControlStateNormal];
            view;
        });
        
        self.titleDateLab = ({
            UILabel *view = [UILabel new];
            [_titleBar addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_titleBar);
                make.left.mas_equalTo(_titleCompLab.mas_right).offset(12);
                make.right.mas_lessThanOrEqualTo(_titleExpBtn.mas_left).offset(-5);
            }];
            [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x089cfe);
            view;
        });
        
    }
    return self;
}

- (void)setModel:(FollowRecordModel *)model{
    _model = model;
    _titleCompLab.text = model.companyname;
    _titleDateLab.text = model.time;
    
    int state = [model.followState intValue]-1;
    if (state>=0&&state<FOLLOWSTATES.count) {
        _titleIcon.image = KImageName(FOLLOWSTATES[state]);
    }
}

//- (void)openAction{
//    NSLog(@"打开");
//}

@end
