//
//  CustomTabBarController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CustomTabBarController.h"
#import "UserCenterController.h"
#import "BasicNavigationController.h"
#import "Macros.h"
#import "CustomTabBar.h"
#import "UIView+GradientColor.h"
#import "TabCoverView.h"
#import "MapViewController.h"
#import "CompanyListController.h"

static TabCoverView *coverView;

@interface CustomTabBarController ()<UITabBarDelegate,UITabBarControllerDelegate>

@property (nonatomic ,strong) UserCenterController *userVc;
@property (nonatomic ,strong) MapViewController *mapVc;
@property (nonatomic ,strong) CompanyListController *companyVc;

@property (nonatomic ,strong) BasicNavigationController *mapNavi;
@property (nonatomic ,strong) BasicNavigationController *userNavi;
@property (nonatomic ,strong) BasicNavigationController *compNavi;

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setTabbarController];
    [self setTabBarAppearance];//此方法要在上边方法之后调用，不然tabbar不显示
}

- (void)setCustomBar{
    CustomTabBar *tabBar = [[CustomTabBar alloc]init];
    [self setValue:tabBar forKey:@"tabBar"];
}

-(void)setTabbarController{
    
    _mapVc= [MapViewController new];
    _mapVc.tabBarItem.title = nil;
    _mapNavi=[[BasicNavigationController alloc]initWithRootViewController:_mapVc];
    
    _companyVc = [CompanyListController new];
    _companyVc.tabBarItem.title = nil;
    _compNavi=[[BasicNavigationController alloc]initWithRootViewController:_companyVc];

    _userVc=[[UserCenterController alloc]init];
    _userVc.tabBarItem.title = nil;
    _userNavi =[[BasicNavigationController alloc]initWithRootViewController:_userVc];
    
    self.viewControllers = @[_mapNavi,_compNavi,_userNavi];
}

- (UIImage *)getOriginalImage:(NSString *)imageName{
    UIImage *img = [UIImage imageNamed:imageName];
    UIImage *image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}


- (void)setTabBarAppearance{
    [[UITabBar appearance]setTranslucent:NO];
    [self setTabBarsss];
}

- (void)setTabBarsss{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coverView = [[TabCoverView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KTabBarHeight)];
        [[UITabBar appearance]insertSubview:coverView atIndex:0];
    });
    [coverView setIndex:0 title:@"地图显示"];//重新登录后，还原coverView（static类型的，保持和[UITabBar appearance]的生命周期一致）
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [self.childViewControllers indexOfObject:viewController];
    [coverView setIndex:currentIndex title:nil];
    return YES;
}


// 不自动旋转
-(BOOL)shouldAutorotate{
    
    return [self.selectedViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.selectedViewController supportedInterfaceOrientations];
}


//
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


@end
