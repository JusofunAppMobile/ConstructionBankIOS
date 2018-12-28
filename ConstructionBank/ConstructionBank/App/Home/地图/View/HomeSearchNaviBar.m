//
//  HomeSearchNaviBar.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/26.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "HomeSearchNaviBar.h"
#import "MyTextField.h"
#import <UIButton+LXMImagePosition.h>
#import "YBPopupMenu.h"

@interface HomeSearchNaviBar ()<YBPopupMenuDelegate,UITextFieldDelegate>
@property (nonatomic ,strong) MyTextField *textFiled;
@property (nonatomic ,strong) UIView *naviBar;
@property (nonatomic ,strong) NSArray *titleArr;
@property (nonatomic ,strong) UIButton *switchBtn;
@end

@implementation HomeSearchNaviBar

- (CGSize)intrinsicContentSize{

    return UILayoutFittingExpandedSize;

}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleArr = @[@"搜企业",@"搜地址"];
        
        //搜索栏
        _naviBar = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, self.height)];
        _naviBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:_naviBar];
        
        
        UIButton *button = [UIButton new];
        [button.titleLabel setFont:KFont(14)];
        [button setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_naviBar);
            make.right.mas_equalTo(_naviBar).offset(-15);
            make.width.mas_equalTo(35);
        }];
        
        self.switchBtn = ({
            UIButton *switchBtn = [UIButton new];
            switchBtn.titleLabel.font = KFont(14);
            [switchBtn setTitle:@"搜企业" forState:UIControlStateNormal];
            [switchBtn setImage:KImageName(@"icon_shaixuan") forState:UIControlStateNormal];
            [switchBtn setImage:KImageName(@"icon_shaixuan2") forState:UIControlStateSelected];
            [switchBtn setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
            [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
            [_naviBar addSubview:switchBtn];
            [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_naviBar).offset(5);
                make.centerY.mas_equalTo(button);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(30);
            }];
            [_naviBar layoutIfNeeded];
            [switchBtn setImagePosition:LXMImagePositionRight spacing:5];
            switchBtn;
        });
        
        self.textFiled = ({
            UIImageView *icon = [[UIImageView alloc]initWithFrame:KFrame(0, 0, 15, 15)];
            icon.image = KImageName(@"放大镜");
            MyTextField *textField = [MyTextField new];
            textField.layer.borderColor = KHexRGB(0xc8c8c8).CGColor;
            textField.layer.borderWidth = .5;
            textField.layer.cornerRadius = 15;
            textField.placeholder = @"请输入企业名称";
            textField.leftView = icon;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.font = KFont(15);
            [_naviBar addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_switchBtn.mas_right).offset(10);
                make.centerY.mas_equalTo(_naviBar);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(button.mas_left).offset(-10);
            }];
            textField.delegate = self;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField;
        });
        
        [_textFiled addTarget:self  action:@selector(textFieldTextChanged:)  forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    _textFiled.text = text;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(searchBarDidBeginEditing)]) {
        [self.delegate searchBarDidBeginEditing];
    }
}

- (void)textFieldTextChanged:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidChanged:)]) {
        [self.delegate searchBarTextDidChanged:textField.text];
    }
}
#pragma mark - switch action
- (void)switchAction:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:_titleArr icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
    }];
}

- (void)searchAction{
    if (!_textFiled.text.length) {
        [MBProgressHUD showHint:@"请输入搜索企业名称" toView:nil];
        return;
    }
    if (_textFiled.text.length<2) {
        [MBProgressHUD showHint:@"企业名称长度不能少于2个字！" toView:nil];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(searchBarAction:)]) {
        [self.delegate searchBarAction:_textFiled.text];
    }
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    [_switchBtn setTitle:_titleArr[index] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(didChangeSearchType:)]) {
        [self.delegate didChangeSearchType:index];
    }
}

@end
