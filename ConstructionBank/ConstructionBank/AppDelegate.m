//
//  AppDelegate.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <IQKeyboardManager.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "BasicNavigationController.h"
@interface AppDelegate ()<BMKGeneralDelegate,BMKLocationServiceDelegate>
@property (nonatomic ,strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setIQKeyboardManager];
    [self registerNotification];
    [self setRootView];
    [self setTableviewAppearance];
    [self setBaiduMap];
    // Override point for customization after application launch.
    return YES;
}


-(void)setRootView
{
    NSArray *array = [UserModel findAll];
    if(array.count>0)
    {
        UserModel *user ;
        user = [array objectAtIndex:0];

    }
    
    if(KUSER.userID.length == 0)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        BasicNavigationController *rootNavi = [[BasicNavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = rootNavi;
    }
    else
    {
        _rootTab = [[CustomTabBarController alloc]init];
        self.window.rootViewController = _rootTab;
    }
    
    [self.window makeKeyAndVisible];
}


- (void)setTableviewAppearance{
    if (@available(iOS 11.0, *)) {//设置tableview header和footer
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
    }
}

- (void)setBaiduMap{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDu_Appkey  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)onGetPermissionState:(int)iError{
    
    NSLog(@"错误____%d",iError);
}

-(void)registerNotification
{
    [KNotificationCenter addObserver:self selector:@selector(setRootView) name:KLoginSuccess object:nil];
    [KNotificationCenter addObserver:self selector:@selector(setRootView) name:KLoginOut object:nil];
}
#pragma mark - 自动隐藏键盘的第三方类库
-(void)setIQKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldShowTextFieldPlaceholder = NO;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
