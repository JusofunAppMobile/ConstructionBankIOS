//
//  SearchContainerController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/11/8.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SearchContainerController.h"
#import "SearchListController.h"
#import "CompanySearchController.h"

@interface SearchContainerController ()
@property (nonatomic ,strong) BasicViewController *currentVc;
@property (nonatomic ,strong) CompanySearchController *searchVc;
@property (nonatomic ,strong) SearchListController *listVc;
@property (nonatomic ,strong) UIButton *footerBtn;
@end

@implementation SearchContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchVc = [CompanySearchController new];
    _searchVc.searchText = _searchText;
    
    _listVc = [SearchListController new];
    _listVc.searchText = _searchText;
    
    _footerBtn = [[UIButton alloc]initWithFrame:KFrame(0, KDeviceH-49, KDeviceW, 49)];
    [_footerBtn setTitle:@"列表显示" forState:UIControlStateNormal];
    _footerBtn.backgroundColor = KHexRGB(0xFC8E32);
    [_footerBtn addTarget:self action:@selector(jumpToSearchList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footerBtn];
    
    self.currentVc = _listVc;
    [self jumpToSearchList];
}


- (void)jumpToSearchList{
    
    [self hideViewController:self.currentVc];
    if ([_currentVc isKindOfClass:[SearchListController class]]) {
        _searchVc.searchText = _listVc.searchText;
        _searchVc.entlist = _listVc.entlist;
        self.currentVc = _searchVc;
        [_footerBtn setTitle:@"列表显示" forState:UIControlStateNormal];
    }else{
        _listVc.entlist = _searchVc.entlist;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
