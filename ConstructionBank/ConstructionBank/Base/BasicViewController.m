//
//  BasicViewController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)showLoadDataAnimation{}
-(void)hideLoadDataAnimation{}

-(void)setNavigationBarTitle:(NSString *)title
{
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:KNavigationTitleFontSize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //    self.title = title;
    [self setNavigationBarTitle:title andTextColor:[UIColor blackColor]];
}

/**
 *  设置导航文字，自定义字体颜色和内容
 *
 *  @param title 标题
 *  @param color 颜色
 */
-(void)setNavigationBarTitle:(NSString *)title andTextColor:(UIColor *)color
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:KFont(KNavigationTitleFontSize),NSForegroundColorAttributeName:color}];
    self.navigationItem.title = title;//独立的 不与tab一样
}

-(void)setBackBtn:(NSString *)imageName
{
    
    UIButton *backGroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    backGroundButton.backgroundColor = [UIColor clearColor];
    
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    if(imageName.length == 0){
        backBtn.frame = CGRectMake(- 4, 0, 44, 44);
        [backBtn setTitle:@"back" forState:UIControlStateNormal];
        [backBtn setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
        backBtn.titleLabel.font = KNormalFont;
    }else{
        //        imageName = @"返回";
       
    }
    
    backBtn.frame = CGRectMake(-0, (44 - 18)/2, 10, 16);
    [backBtn setImage:[Tools scaleImage:KImageName(@"back") size:backBtn.size] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backGroundButton addSubview:backBtn];
    [backGroundButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:backGroundButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  展示加载失败的页面
 *
 *  @param msg 提示语
 */

- (void)showNetFailViewWithFrame:(CGRect)frame{
    
  
}


/**
 *  隐藏加载失败的页面
 */

- (void)hideNetFailView{
}

- (void)networkReload{
}

/**
 *  加载失败动画点击重新加载方法
 */
-(void)abnormalViewReload
{
    
}






// 支持屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait /*| UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight*/);
}

// 不自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

//
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return (UIInterfaceOrientationPortrait /*| UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight*/);
}


@end
