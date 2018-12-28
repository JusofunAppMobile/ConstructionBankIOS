//
//  SearchView.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

- (void)didClickSearchButton:(NSString *)searchTetx;

@end

@interface SearchView : UIView
@property (nonatomic ,weak) id <SearchViewDelegate>delegate;
@end
