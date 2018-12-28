//
//  AddFollowUpLogInfoCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/3.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AddFollowUpLogInfoCell.h"

@interface AddFollowUpLogInfoCell ()<UITextFieldDelegate>

//@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UITextField *namelField;
@property (nonatomic ,strong) UITextField *postionField;
@property (nonatomic ,strong) UITextField *phoneField;
@property (nonatomic ,strong) ClientModel *model;
@property (nonatomic ,strong) UIButton *checkBtn;

@end

@implementation AddFollowUpLogInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        self.titleLab  = ({
//            UILabel *view = [UILabel new];
//            [self.contentView addSubview:view];
//            [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.left.mas_equalTo(15);
//                make.height.mas_equalTo(14);
//            }];
//            view.font = KFont(14);
//            view.textColor = KHexRGB(0x333333);
//            view.text = @"客户";
//            view;
//        });
        
        UILabel *nameLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.mas_equalTo(15);
                make.width.mas_equalTo(43);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"姓名：";
            view;
        });
        
        UILabel *positionLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(nameLab.mas_bottom).offset(15);
                make.left.width.height.mas_equalTo(nameLab);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"职位：";
            view;
        });
        
        UILabel *phoneLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(positionLab.mas_bottom).offset(15);
                make.left.width.height.mas_equalTo(nameLab);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view.text = @"电话：";
            view;
        });
        
        UILabel *checkLab = [UILabel new];
        checkLab.text = @"设置为企业联系电话";
        checkLab.font = KFont(13);
        checkLab.textColor = KHexRGB(0x999999);
        [self.contentView addSubview:checkLab];
        [checkLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(phoneLab.mas_bottom).offset(15);
            make.left.mas_equalTo(phoneLab);
        }];
        
        self.checkBtn = ({
            UIButton *view = [UIButton new];
            view.selected = YES;
            [view setImage:KImageName(@"未选中") forState:UIControlStateNormal];
            [view setImage:KImageName(@"选中") forState:UIControlStateSelected];
            [view addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(checkLab);
                make.left.mas_equalTo(checkLab.mas_right).offset(10);
            }];
            view;
        });
      
        
        self.namelField = ({
            UITextField *view = [UITextField new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameLab.mas_right);
                make.top.mas_equalTo(nameLab);
                make.right.mas_equalTo(self.contentView).offset(-15);
            }];
            view.placeholder = @"请输入姓名";
            view.delegate = self;
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        self.postionField = ({
            UITextField *view = [UITextField new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_namelField);
                make.top.mas_equalTo(positionLab);
            }];
            view.placeholder = @"请输入职位";
            view.delegate = self;
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        self.phoneField = ({
            UITextField *view = [UITextField new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_namelField);
                make.top.mas_equalTo(phoneLab);
            }];
            view.keyboardType = UIKeyboardTypeNumberPad;
            view.placeholder = @"请输入电话";
            view.delegate = self;
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        [_namelField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventEditingChanged];
        [_postionField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventEditingChanged];
        [_phoneField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}



- (void)setModel:(ClientModel *)model{//键盘遮挡问题
    _model = model;
    _model.linkPhone = _checkBtn.selected? @"true":@"false";//默认YES

    _namelField.text = _model.name ?:@"";
    _postionField.text = _model.job ?:@"";
    _phoneField.text = _model.phone ?:@"";

}

- (void)valueChanged:(UITextField *)textField{
    
    if ([textField isEqual:_namelField]) {
        _model.name = textField.text;
    }
    
    if ([textField isEqual:_postionField]) {
        _model.job = textField.text;
    }
    
    if ([textField isEqual:_phoneField]) {
        _model.phone = textField.text;
    }
}

- (void)checkAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    _model.linkPhone = sender.selected ? @"true":@"false";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
