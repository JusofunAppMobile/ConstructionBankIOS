//
//  SearchView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()<UISearchBarDelegate>

@property (nonatomic ,strong) UISearchBar *searchBar;

@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _searchBar = [[UISearchBar alloc]initWithFrame:KFrame(15, 15, KDeviceW-15-58, 30)];
        _searchBar.searchBarStyle         = UISearchBarStyleProminent;
        _searchBar.placeholder            = @"请输入关键字";
        _searchBar.backgroundImage = nil;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.layer.cornerRadius = 14.f;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.borderColor = KHexRGB(0xc8c8c8).CGColor;
        _searchBar.layer.borderWidth = .5f;
        _searchBar.delegate = self;
        [self addSubview:_searchBar];
        [[_searchBar.subviews[0] subviews][0] removeFromSuperview];
        UITextField *searchTextField = [_searchBar valueForKey:@"_searchField"];
        searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIButton *searchBtn = [UIButton new];
        [searchBtn setTitle:@"搜索" forState: UIControlStateNormal];
        [searchBtn setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
        [searchBtn.titleLabel setFont:KFont(14)];
        [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchBtn];
        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(_searchBar.mas_right).offset(4);
            make.width.mas_equalTo(50);
        }];
    }
    return self;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self searchAction];
}

- (void)searchAction{
    if (!_searchBar.text.length) {
        [MBProgressHUD showError:@"请输入搜索内容!" toView:nil];
        return;
    }
    [_searchBar resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(didClickSearchButton:)]) {
        [self.delegate didClickSearchButton:_searchBar.text];
    }
}

@end
