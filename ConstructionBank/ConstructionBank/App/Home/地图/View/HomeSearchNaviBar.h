//
//  HomeSearchNaviBar.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/26.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeNaviDelegate <NSObject>
- (void)searchBarAction:(NSString *)text;
- (void)didChangeSearchType:(NSInteger)searchType;
- (void)searchBarTextDidChanged:(NSString *)text;
- (void)searchBarDidBeginEditing;
@end

@interface HomeSearchNaviBar : UIView
@property (nonatomic ,weak) id <HomeNaviDelegate>delegate;
@property (nonatomic ,copy) NSString *text;

@end
