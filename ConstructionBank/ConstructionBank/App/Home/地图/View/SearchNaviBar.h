//
//  SearchNaviBar.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/7.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchNaviDelegate <NSObject>

- (void)searchBarAction:(NSString *)text;
@optional
- (void)didClickBackButton;
- (void)didChangeSearchType:(NSInteger)searchType;
- (void)searchBarTextDidChanged:(NSString *)text;
- (void)searchBarDidBeginEditing;
@end

@interface SearchNaviBar : UIView
@property (nonatomic ,weak) id <SearchNaviDelegate>delegate;
@property (nonatomic ,copy) NSString *text;
- (instancetype)initWithFrame:(CGRect)frame showBack:(BOOL)showBack title:(NSString *)title;
- (void)hideSearchBar;
- (void)showSearchBar;
@end
