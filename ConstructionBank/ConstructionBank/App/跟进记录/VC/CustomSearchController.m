//
//  CustomSearchController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/1.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CustomSearchController.h"

@interface CustomSearchController ()

@end

@implementation CustomSearchController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.searchBar.barTintColor = KHexRGB(0xeeeeee);
    self.searchBar.placeholder = @"请输入关键字";
    self.searchBar.returnKeyType = UIReturnKeyDone;
    [self.searchBar setValue:@" 取消 " forKey:@"_cancelButtonText"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
