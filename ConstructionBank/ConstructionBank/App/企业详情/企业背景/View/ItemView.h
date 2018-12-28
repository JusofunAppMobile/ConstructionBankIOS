//
//  ItemView.h
//  EnterpriseInquiry
//
//  Created by clj on 15/11/13.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@interface ItemButton : UIButton
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) ItemModel *squareModel;
@property (nonatomic,strong) UIImageView *hotImageView;
-(id)initWithFrame:(CGRect)frame andButtonTitle:(NSString *)buttonTitle andIsNeedImageView:(BOOL)isNeed andHotImageURL:(NSString *)HotImageURL;

-(id)initWithFrame:(CGRect)frame andButtonTitle:(NSString *)buttonTitle;

@end


@protocol ItemViewDelegate <NSObject>

@optional
-(void)ItemButtonClick:(ItemButton *)titileName;
@optional
-(void)pullItemButtonClick:(ItemButton *)button;
@end


@interface ItemView : UIView

@property (nonatomic,assign) id<ItemViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) ItemModel *currentSquareModel;
@property (nonatomic,strong) NSMutableArray *itemBtnArray;

//让Hot图片移动
-(void)setHotImageViewMove;

-(id)initWithframe:(CGRect)frame andArray:(NSArray *)dataArray andIsNeedImageView:(BOOL)isNeed andCurrentModel:(ItemModel *)model;
-(id)initWithframe:(CGRect)frame andArray:(NSArray *)dataArray andThisModel:(ItemModel *)model;
@end
