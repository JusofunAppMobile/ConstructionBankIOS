//
//  HistoryMsgCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "HistoryMsgCell.h"
#import "MsgListModel.h"
@interface HistoryMsgCell ()

@end

@implementation HistoryMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /*
         ----------------------------圆角阴影------------------
         */
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
        
        /*
        ---------------------------------topView-------------------
        */
        UIView *topView = [UIView new];
        topView.backgroundColor = KHexRGB(0xfff5e9);
        [radiusView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(radiusView);
            make.height.mas_equalTo(35);
        }];
        
        
        UIImageView *iconView = [UIImageView new];
        iconView.image = KImageName(@"编辑icon");
        [topView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(topView).offset(15);
            make.centerY.mas_equalTo(topView);
        }];
        
        UIButton *copyBtn = [UIButton new];
        [copyBtn setTitle:@"复制消息内容" forState:UIControlStateNormal];
        [copyBtn setTitleColor:KHexRGB(0xc48964) forState:UIControlStateNormal];
        [copyBtn addTarget:self action:@selector(copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [copyBtn.titleLabel setFont:KFont(14)];
        [topView addSubview:copyBtn];
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(topView).offset(-15);
            make.centerY.mas_equalTo(topView);
        }];
        
        /*
         ---------------------------------content-------------------
         */
        self.contentLab = ({
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
            view.textColor = KHexRGB(0x666666);
            view;
        });
    }
    return self;
}

- (void)setModel:(MsgListModel *)model{
    _model = model;
    _contentLab.text = model.message;
    
}

#pragma mark - 复制消息
- (void)copyBtnAction{
    if ([self.delegate respondsToSelector:@selector(didClickCopyButton:)]) {
        [self.delegate didClickCopyButton:_contentLab.text];
    }
}

@end
