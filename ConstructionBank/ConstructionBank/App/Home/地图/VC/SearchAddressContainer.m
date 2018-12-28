//
//  SearchAddressContainer.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/21.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SearchAddressContainer.h"
#import "SearchAddressMapVC.h"
#import "SearchAddressListVC.h"

@interface SearchAddressContainer ()
@property (nonatomic ,strong) BasicViewController *currentVc;
@property (nonatomic ,strong) SearchAddressMapVC *searchVc;
@property (nonatomic ,strong) SearchAddressListVC *listVc;
@property (nonatomic ,strong) UIButton *footerBtn;
@end

@implementation SearchAddressContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchVc = [SearchAddressMapVC new];
    _searchVc.userCoordinate = _userCoordinate;
    _searchVc.searchText = _searchName;
    _searchVc.searchlist = [_searchlist mutableCopy];

    _listVc = [SearchAddressListVC new];
    _listVc.isFistLoad = YES;
    
    _footerBtn = [[UIButton alloc]initWithFrame:KFrame(0, KDeviceH-49, KDeviceW, 49)];
    [_footerBtn setTitle:@"列表显示" forState:UIControlStateNormal];
    _footerBtn.backgroundColor = KHexRGB(0xFC8E32);
    [_footerBtn addTarget:self action:@selector(jumpToSearchList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footerBtn];
    
    self.currentVc = _searchVc;
    [self displayViewController:_searchVc];
}

- (void)jumpToSearchList{
    
    [self hideViewController:self.currentVc];
    if ([_currentVc isKindOfClass:[SearchAddressListVC class]]) {
        _searchVc.searchText = _listVc.searchText;
        _searchVc.userCoordinate = _listVc.userCoordinate;
        _searchVc.isFromList = YES;
        self.currentVc = _searchVc;
        [_footerBtn setTitle:@"列表显示" forState:UIControlStateNormal];
    }else{
        _listVc.userCoordinate = _searchVc.userCoordinate;
        _listVc.searchText = _searchVc.searchText;
        self.currentVc = _listVc;
        [_footerBtn setTitle:@"地图显示" forState:UIControlStateNormal];
    }
    [self displayViewController:_currentVc];
}

- (void)displayViewController:(UIViewController *)controller {
    if (!controller) {
        return;
    }
    [self addChildViewController:controller];
    
    controller.view.frame = KFrame(0, 0, KDeviceW, KDeviceH-49);
    [self.view addSubview:controller.view];
    [self.view bringSubviewToFront:_footerBtn];//弹出的列表在footer下边呈现
    [controller didMoveToParentViewController:self];
}

- (void)hideViewController:(UIViewController *)controller {
    
    if (!controller) {
        return;
    }
    [controller willMoveToParentViewController:nil];
    
    [controller.view removeFromSuperview];
    
    [controller removeFromParentViewController];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


@end
