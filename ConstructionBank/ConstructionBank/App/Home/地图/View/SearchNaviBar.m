//
//  SearchNaviBar.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/7.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SearchNaviBar.h"
#import <UIButton+LXMImagePosition.h>
#import "MyTextField.h"

#define SEARCH_H 48.f
@interface SearchNaviBar ()<UITextFieldDelegate>
@property (nonatomic ,strong) UITextField *textFiled;
@property (nonatomic ,strong) UIView *searchBar;
@property (nonatomic ,strong) UIView *naviBar;
@end
@implementation SearchNaviBar

- (instancetype)initWithFrame:(CGRect)frame showBack:(BOOL)showBack title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        //搜索栏
        _naviBar = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, self.height)];
        _naviBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:_naviBar];
        
        
        UILabel *titleLab = [UILabel new];
        titleLab.text = title;
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = KFont(17);
        [_naviBar addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_naviBar);
            make.centerY.mas_equalTo(_naviBar).offset(KStatusBarHeight/2);
        }];
        
        if (showBack) {
            UIButton *backBtn = [UIButton new];
            [backBtn setImage:KImageName(@"back") forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            [_naviBar addSubview:backBtn];
            [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(5);
                make.centerY.mas_equalTo(titleLab);
                make.width.mas_equalTo(35);
            }];
        }
        
        UIButton *searchBtn = [UIButton new];
        [searchBtn setImage:KImageName(@"search_icon") forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(showSearchBar) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar addSubview:searchBtn];
        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLab);
            make.right.mas_equalTo(_naviBar).offset(-30);
        }];
        
        
        
        _searchBar = [[UIView alloc]initWithFrame:KFrame(0, _naviBar.maxY-SEARCH_H, KDeviceW, SEARCH_H)];
        _searchBar.backgroundColor = KHexRGB(0xf9f9f9);
        _searchBar.alpha = 0;
        [self insertSubview:_searchBar atIndex:0];
        
        
        UIButton *button = [UIButton new];
        [button.titleLabel setFont:KFont(14)];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_searchBar addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_searchBar);
            make.right.mas_equalTo(_searchBar).offset(-15);
            make.width.mas_equalTo(35);
        }];
        
        
        self.textFiled = ({
            UIImageView *icon = [[UIImageView alloc]initWithFrame:KFrame(0, 0, 15, 15)];
            icon.image = KImageName(@"放大镜");
            MyTextField *textField = [MyTextField new];
            textField.layer.borderColor = KHexRGB(0xc8c8c8).CGColor;
            textField.layer.borderWidth = .5;
            textField.layer.cornerRadius = 17;
            textField.placeholder = @"请输入企业名称";
            textField.backgroundColor = [UIColor whiteColor];
            textField.leftView = icon;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.font = KFont(15);
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_searchBar addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_searchBar).offset(30);
                make.centerY.mas_equalTo(_searchBar);
                make.height.mas_equalTo(34);
                make.right.mas_equalTo(button.mas_left).offset(-10);
            }];
            textField.delegate = self;
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

- (void)showSearchBar{
    if (_searchBar.alpha == 0) {
        self.frame = KFrame(self.x, self.y, self.width, KNavigationBarHeight+SEARCH_H);
        [UIView animateWithDuration:.3 animations:^{
            _searchBar.alpha = 1;
            _searchBar.frame = KFrame(0, _naviBar.maxY, self.width, SEARCH_H);
        }];
    }else{
        self.frame = KFrame(self.x, self.y, self.width, KNavigationBarHeight);
        [UIView animateWithDuration:.3 animations:^{
            _searchBar.alpha = 0;
            _searchBar.frame = KFrame(0, _naviBar.maxY-SEARCH_H, self.width, SEARCH_H);
        }];
    }
}
- (void)hideSearchBar{
    _searchBar.alpha = 0;
    _searchBar.frame = KFrame(0, _naviBar.maxY - SEARCH_H, self.width, SEARCH_H);
    _textFiled.text = nil;
}

- (void)backAction{
    if ([self.delegate respondsToSelector:@selector(didClickBackButton)]) {
        [self.delegate didClickBackButton];
    }
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

#pragma mark - 搜索
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

@end
