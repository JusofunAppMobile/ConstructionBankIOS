//
//  ButtonModel.h
//  jusfounData
//
//  Created by jusfoun on 15/10/16.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonModel : NSObject


@property (nonatomic,strong) NSString *centerCompId;

@property (nonatomic,strong) NSString *centerCompX;

@property (nonatomic,strong) NSString *centerCompY;




@property (nonatomic,strong) NSString *otherCompId;

@property (nonatomic,strong) NSString *otherCenterCompX;
@property (nonatomic,strong) NSString *otherCenterCompY;


@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,strong) UIImageView *pointImageView;

@property (nonatomic,assign) CGMutablePathRef pointImageViewPath;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,assign) float angle;



@property (nonatomic,strong) NSString *firstX;

@property (nonatomic,strong) NSString *firstY;


@property (nonatomic,strong)UIButton *otherCenterBtn;

@property (nonatomic,strong)UIButton *selfBtn;



@property (nonatomic,strong)UIImageView *arrowImageView;

@property (nonatomic,assign)BOOL isLeft;


@property (nonatomic,assign)BOOL isInSide;


@property(nonatomic,strong)NSDictionary *dataDic;

@end
