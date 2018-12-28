//
//  AddFollowUpLogCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/3.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AddFollowUpLogCell.h"
#import "UITextView+Placeholder.h"

@interface AddFollowUpLogCell ()<UITextFieldDelegate>

@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) NSArray *titleArr;
@property (nonatomic ,strong) NSArray *keyArr;
@property (nonatomic ,strong) UIImageView *nextIcon;
@property (nonatomic ,strong) NSMutableDictionary *contentDic;
@property (nonatomic ,assign) NSInteger row;

@end

@implementation AddFollowUpLogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleArr = @[@"跟进时间",@"跟进地点",@"详细地址",@"跟进状态"];
        self.keyArr = @[@"time",@"address",@"detailAddress",@"followStateText"];
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.contentView).offset(15);
            }];
            view.image = KImageName(@"跟进时间");
            view;
        });
        
        self.nextIcon = ({
            UIImageView *nextIcon = [UIImageView new];
            [nextIcon setImage:KImageName(@"灰色箭头")];
            [self.contentView addSubview:nextIcon];
            [nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.contentView).offset(-15);
                make.width.mas_equalTo(7);
                make.height.mas_equalTo(13);
            }];
            nextIcon;
        });
       
        self.titleLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.contentView).offset(42);
                make.width.mas_equalTo(60);
            }];
            view.text = @"跟进时间";
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view;
        });
        
        
        self.contenLab = ({
            UITextField *view = [UITextField new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_titleLab.mas_right).offset(20);
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(_nextIcon.mas_left).offset(-7);
                make.height.mas_equalTo(25);
            }];
            view.delegate = self;
            view.enabled = NO;
            view.placeholder = @"请选择";
            view.font = KFont(14);
            view.textColor = KHexRGB(0x666666);
            view.textAlignment = NSTextAlignmentRight;
            view;
        });
        
        [_contenLab addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)setContent:(NSMutableDictionary *)content atRow:(NSInteger)row{
    _contentDic = content;
    _row = row;
    if (row == 2) {
        _contenLab.placeholder = @"楼层／门牌号";
        _contenLab.enabled = YES;
        _nextIcon.hidden = YES;
    }else{
        _contenLab.placeholder = @"请选择";
        _contenLab.enabled = NO;
        _nextIcon.hidden = NO;
    }
    
    _titleLab.text = _titleArr[row];
    _iconView.image = KImageName(_titleArr[row]);
    _contenLab.text = _contentDic[_keyArr[row]];
}

- (void)valueChanged:(UITextField *)textField{
    if (textField.text&&_row == 2) {
        [_contentDic setObject:textField.text forKey:@"detailAddress"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
