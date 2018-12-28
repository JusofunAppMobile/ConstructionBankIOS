//
//  BasicViewController.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Add.h"
#import "UINavigationBar+Extention.h"
#import "ItemModel.h"


@interface BasicViewController : UIViewController
@property(nonatomic,strong)ItemModel*itemModel;


/**
 *  设置title
 *
 *  @param title 标题
 */
-(void)setNavigationBarTitle:(NSString *)title;

/**
 *  设置导航文字，自定义字体颜色和内容
 *
 *  @param title 标题
 *  @param color 颜色
 */
-(void)setNavigationBarTitle:(NSString *)title andTextColor:(UIColor *)color;



/**
 *  设置返回按钮
 *
 *  @param imageName 返回按钮的图片名字
 */
-(void)setBackBtn:(NSString *)imageName;

/**
 *  返回界面，如需更改子类重写
 */
-(void)back;


/**
 *  加载数据动画
 */
-(void)showLoadDataAnimation;

/**
 *  隐藏加载数据动画
 */
-(void)hideLoadDataAnimation;

/**
 *  展示加载失败的页面
 *
 *  @param msg 提示语
 */
- (void)showNetFailViewWithFrame:(CGRect)frame;
/**
 *  隐藏加载失败的页面
 */
-(void)hideNetFailView;

/**
 *  加载失败动画点击重新加载方法
 */
-(void)abnormalViewReload;

@end
