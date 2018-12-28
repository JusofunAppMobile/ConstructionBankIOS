//
//  CompanyMap.m
//  jusfounData
//
//  Created by clj on 15/10/21.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "CompanyMap.h"
#define HEIGHT  ([UIScreen mainScreen].bounds.size.height / 568.0)
#define WIDTH  ([UIScreen mainScreen].bounds.size.width / 320.0)

@interface CompanyMap()
{
    UIView *relationView;
    NSDictionary *dataDic;
}

@end

@implementation CompanyMap

- (instancetype)initWithFrame:(CGRect)frame andDicInfo:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat widthBelong = KDeviceW/3;
        self.backgroundColor = [UIColor whiteColor];
        
        dataDic = dic;
        
        NSArray *sharehArray = dic[@"shareholders"];
        NSArray *invesArray = dic[@"investments"];
        UIView *leftView = [self createRadiusViewWithLayerColor:KInClolor andViewFrame:CGRectMake(widthBelong - 15 - 67/2,22* HEIGHT, 67 , 67 ) andValue:sharehArray.count andKey:@"股东"];
        [self addSubview:leftView];
        
        UIView *rightView = [self createRadiusViewWithLayerColor:KOutClolor andViewFrame:CGRectMake(KDeviceW - widthBelong - 67/2 + 15, 22 * HEIGHT, 67 , 67 ) andValue:invesArray.count andKey:@"投资"];
        [self addSubview:rightView];
        
        [self drawRelationView];
    }
    return self;
}


-(void)drawRelationView
{
    
    relationView = [[UIView alloc]initWithFrame:KFrame(0,  115* HEIGHT , KDeviceW, 291* HEIGHT)];
    relationView.backgroundColor = KRGB(240, 240, 240);
    
    [self addSubview:relationView];
    
    CGFloat centerY = relationView.center.y -  relationView.frame.origin.y;
    CGFloat centerX = relationView.center.x -  relationView.frame.origin.x;
    

    
    NSArray *sharehArray = dataDic[@"shareholders"];
    NSArray *invesArray = dataDic[@"investments"];
    
    
 
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1];
    
    if(sharehArray.count >0 && invesArray.count>0)
    {
        
        
        if(sharehArray.count > 8*1)
        {
            for(int i = 8 *(1-1);i<8*1;i++)
            {
                [array1 addObject:sharehArray[i]];
            }
           
        }
        else if (sharehArray.count <= 8*1 && sharehArray.count > 0)
        {
            for(int i = 8 *(1-1);i<sharehArray.count;i++)
            {
                [array1 addObject:sharehArray[i]];
            }
           
        }
        
        
        
        if(invesArray.count > 8*1)
        {
            for(int i = 8 *(1-1);i<8*1;i++)
            {
                [array2 addObject:invesArray[i]];
            }
         
           
            
        }
        else if (invesArray.count <= 8*1 && invesArray.count > 0)
        {
            for(int i = 8 *(1-1);i<invesArray.count;i++)
            {
                [array2 addObject:invesArray[i]];
            }
            
        }
        
         [self initRelationViewWithGuDongArray:array1 withIsInside1:YES withTouZiArray:array2 withIsInside2:NO];
      //  [self initRelationViewWithsharehArray:array1 withIsInside1:YES withinvesArray:array2 withIsInside2:NO];
        
    }
    else if (sharehArray.count ==0 && invesArray.count>0)
    {
        
        
        if(invesArray.count >= 1*16)
        {
            for(int i = 8 *(1-1);i<1*16;i++)
            {
                if (i%2 == 0) {
                    [array2 addObject:invesArray[i]];
                }else
                {
                    [array1 addObject:invesArray[i]];
                }
                
            }
            
           
        }
        else
        {
            
            for(int i=0 ;i< (int)invesArray.count ;i++)
            {
                if (i%2 == 0) {
                    [array2 addObject:invesArray[i]];
                }else
                {
                    [array1 addObject:invesArray[i]];
                }
            }
            
        }
        
         [self initRelationViewWithGuDongArray:array1 withIsInside1:NO withTouZiArray:array2 withIsInside2:NO];
        
         }
    else if (sharehArray.count >0 && invesArray.count==0)
    {
        
        
        
        if(sharehArray.count >= 1*16)
        {
           for(int i =0;i<1*16;i++)
           {
               if (i%2 ==0)
               {
                   [array1 addObject:sharehArray[i]];
               }else
               {
                  [array2 addObject:sharehArray[i]];
               }
           }
            
        }
        else
        {
            
            for (int i =0; i<(int) sharehArray.count; i++) {
                if (i%2 ==0)
                {
                    [array1 addObject:sharehArray[i]];
                }else
                {
                    [array2 addObject:sharehArray[i]];
                }

            }
            
        }
        
        
        [self initRelationViewWithGuDongArray:array1 withIsInside1:YES withTouZiArray:array2 withIsInside2:YES];
        
    }
    else //if (sharehArray.count ==0 && invesArray.count==0)
    {
         [self initRelationViewWithGuDongArray:array1 withIsInside1:YES withTouZiArray:array2 withIsInside2:YES];
    }
    
    
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:KFrame(centerX - 25, centerY- 25, 50, 50)];
    centerLabel.text = [dataDic objectForKey:@"centShortName"];
    centerLabel.numberOfLines = 0;
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.layer.cornerRadius = 25;
    centerLabel.clipsToBounds = YES;
    centerLabel.backgroundColor = KRGB(254, 114, 14);
    centerLabel.font = KFont(13);
    centerLabel.textColor = [UIColor whiteColor];
    [relationView addSubview:centerLabel];
    

    UILabel *hasNoLabel = [[UILabel alloc] init];
    hasNoLabel.frame = CGRectMake(10,CGRectGetMaxY(centerLabel.frame) +10 ,KDeviceW - 20, 20);
    hasNoLabel.text = @"暂无股东,投资数据";
    [hasNoLabel sizeToFit];
    hasNoLabel.textColor = [UIColor lightGrayColor];
    hasNoLabel.font = KFont(12);
    hasNoLabel.center = CGPointMake(centerLabel.center.x, CGRectGetMaxY(centerLabel.frame) +20);
    hasNoLabel.textAlignment = NSTextAlignmentCenter;
    [relationView addSubview:hasNoLabel];
    
    if (sharehArray.count == 0 && invesArray.count == 0) {
        hasNoLabel.hidden = NO;
    }else
    {
        hasNoLabel.hidden = YES;
    }
    
    
    UIButton *zhanKaiButton = [[UIButton alloc] init];
    zhanKaiButton.frame = CGRectMake(KDeviceW -  40, 10, 30 , 30);
    [zhanKaiButton setImage:[Tools scaleImage:KImageName(@"看大图") size:CGSizeMake(20, 20)]forState:UIControlStateNormal];
    [zhanKaiButton addTarget:self action:@selector(zhanKaiClick) forControlEvents:UIControlEventTouchUpInside];
    [relationView addSubview:zhanKaiButton];
    
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.frame = CGRectMake(0, CGRectGetMaxY(relationView.frame) + 10, 0, 20);
    detailLabel.text = @"点击查看大图";
    [detailLabel sizeToFit];
    detailLabel.textColor = KRGB(154, 154, 164);
    detailLabel.frame = CGRectMake(CGRectGetMaxX(relationView.frame) - detailLabel.frame.size.width-20,CGRectGetMaxY(relationView.frame) + 10 , detailLabel.frame.size.width, detailLabel.frame.size.height);
    [self addSubview:detailLabel];
    
    UIImageView *detailImageView = [[UIImageView alloc] init];
    detailImageView.frame = CGRectMake(detailLabel.frame.origin.x - 18,detailLabel.frame.origin.y + 4 , 13, 13);
    
    
    UIImage *image1 = [UIImage imageNamed:@"tip-1"];
    UIImage *image2 = [UIImage imageNamed:@"tip-2"];
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithObjects:image1,image2, nil];
    [detailImageView setAnimationImages:imageArray];
    [detailImageView setAnimationRepeatCount:0];
    [detailImageView setAnimationDuration:0.6];
    [detailImageView startAnimating];
    [self addSubview:detailImageView];
    
    
    UITapGestureRecognizer *tapOnRelationView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhanKaiClick)];
    [relationView addGestureRecognizer:tapOnRelationView];
    
}

- (void)initRelationViewWithGuDongArray:(NSMutableArray *)tmpArray1 withIsInside1:(BOOL)isInside1 withTouZiArray:(NSMutableArray *)tmpArray2 withIsInside2:(BOOL)isInside2
{
    
    CGFloat centerY = relationView.center.y -  relationView.frame.origin.y;
    CGFloat centerX = relationView.center.x -  relationView.frame.origin.x;
    

    
    double startAngle = (M_PI - M_PI_4)/(tmpArray1.count+1);
    double startAngle2 = (M_PI - M_PI_4)/(tmpArray2.count+1);
    
    

        for(int i = 0;i<tmpArray1.count;i++)
        {
            NSDictionary *tmpDic = [tmpArray1 objectAtIndex:i];
            [self drawWithDataDic:tmpDic withIsLeft:YES withCenterX:centerX withCenterY:centerY withAngle:startAngle  withIsInSide:isInside1];
            startAngle += (M_PI - M_PI_4)/(tmpArray1.count+1);
        }
        
        for(int i = 0;i<tmpArray2.count;i++)
        {
            
            NSDictionary *tmpDic = [tmpArray2 objectAtIndex:i];
            [self drawWithDataDic:tmpDic withIsLeft:NO withCenterX:centerX withCenterY:centerY withAngle:startAngle2  withIsInSide:isInside2];
            startAngle2 += (M_PI - M_PI_4)/(tmpArray2.count+1);
        }
}



#pragma mark - 展开视图
-(void)zhanKaiClick
{
    if (_delegate &&[ _delegate respondsToSelector:@selector(zhanKaiCompanyMap)]) {
        [_delegate zhanKaiCompanyMap];
    }
}


#pragma mark - 建立主图谱
-(void)drawWithDataDic:(NSDictionary *)compDic withIsLeft:(BOOL)isLeft withCenterX:(CGFloat)centerX withCenterY:(CGFloat)centerY withAngle:(double)startAngle  withIsInSide:(BOOL)isInSide
{
    // NSDictionary *tmpDic = [compArray objectAtIndex:i];
    
    //半径 直线的半径
    CGFloat radius = (KDeviceW - 160)/2;
    
    double x = 0;
    double y = 0;
    
    CGPoint labelCenter;
    CGPoint imageCenter;
    
    double plusAngel;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    UIColor *lineColor;
    
   
    UIImage *arrowImage;
   // UIImage *compImage;
    
    if(isLeft)
    {
        plusAngel = - M_PI_4- M_PI_4/2;
        
        x = centerX - radius *cos(startAngle + plusAngel );
        y = centerY - radius*sin( startAngle + plusAngel);
    }
    else
    {
        plusAngel = M_PI_2+M_PI_4/2;
        x = centerX - radius *cos(startAngle + plusAngel );
        y = centerY - radius*sin( startAngle + plusAngel);
    }
    
    
    
    if(isInSide)
    {
        lineColor = KInClolor;
        
        arrowImage = KImageName(@"企业图谱箭头 红");
       // compImage = KImageName(@"redPoint-1");
        
        CGPathMoveToPoint(curvedPath, NULL, x, y);
        CGPathAddLineToPoint(curvedPath, NULL, centerX, centerY);
        
        imageCenter.x = centerX -  40 *cos(startAngle + plusAngel );
        imageCenter.y = centerY -  40 *sin(startAngle + plusAngel);
        
    }
    else
    {
        lineColor = KOutClolor;
       
        arrowImage = KImageName(@"企业图谱箭头 蓝");
       // compImage = KImageName(@"bluePoint");
        
        CGPathMoveToPoint(curvedPath, NULL, centerX, centerY);
        CGPathAddLineToPoint(curvedPath, NULL, x, y);
        
        imageCenter.x = centerX -  (radius -20 ) *cos(startAngle + plusAngel);
        imageCenter.y = centerY -  (radius - 20) *sin(startAngle + plusAngel);
    }
    
    if(isLeft)
    {
        labelCenter.x = centerX - (radius + 40) *cos(startAngle + plusAngel);
        labelCenter.y = centerY - (radius + 40) *sin(startAngle + plusAngel);
    }
    else
    {
        labelCenter.x = centerX - (radius + 40) *cos(startAngle + plusAngel);
        labelCenter.y = centerY - (radius + 40) *sin(startAngle + plusAngel);
    }
    
    NSString *nameStr;
    
    if(isInSide)//股东
    {
        
        if([[compDic objectForKey:@"type"] intValue] == 1)//公司
        {
            nameStr = [compDic objectForKey:@"shortName"];
        }
        else //人
        {
            nameStr = [compDic objectForKey:@"name"];
        }
    }
    else
    {
        nameStr = [compDic objectForKey:@"shortName"];
    }
    
    


    //公司名字
    UILabel *nameLabel  = [[UILabel alloc]initWithFrame:KFrame(0, 0, 60, 20)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    nameLabel.center = labelCenter;
    if(isLeft)
    {
        nameLabel.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    nameLabel.text = nameStr;
    nameLabel.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2 );
    
    [relationView addSubview:nameLabel];
    
    
    //箭头
    UIImageView* arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 7, 7)];
    arrowImageView.image = arrowImage;
    
    if(isLeft && !isInSide)
    {
        arrowImageView.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2-M_PI);
    }
    else if(!isLeft && isInSide)
    {
        arrowImageView.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2-M_PI);
    }
    else
    {
        arrowImageView.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2);
    }
    
    
    arrowImageView.center = imageCenter;
    [relationView addSubview:arrowImageView];
    
    
    //画的线
    CAShapeLayer *arcLayer=[CAShapeLayer layer];
    arcLayer.path=curvedPath;//46,169,230
    arcLayer.fillColor=[UIColor clearColor].CGColor;
    arcLayer.strokeColor= lineColor.CGColor;
    arcLayer.lineWidth=1;
    arcLayer.frame=CGRectMake(0, 0, KDeviceW, KDeviceH  - 38);
    
    
    
    UIImageView* compImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 7, 7)];
    //compImageView.image = compImage;
    compImageView.backgroundColor = lineColor;
    compImageView.layer.cornerRadius = 8;
    compImageView.layer.masksToBounds = YES;
    compImageView.frame = CGRectMake(x-8, y-8, 16, 16);
   
    [relationView addSubview:compImageView];
    
    

    [relationView.layer addSublayer:arcLayer];
    

    
    CGPathRelease(curvedPath);
}

-(UIView *)createRadiusViewWithLayerColor:(UIColor *)color andViewFrame:(CGRect)frame andValue:(NSInteger)value andKey:(NSString *)key{
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    //
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.frame = CGRectMake(0, 5,view.frame.size.width, 20);
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
    numLabel.textColor = color;
    numLabel.font = [UIFont systemFontOfSize:16];
    numLabel.center =CGPointMake(frame.size.width/2, frame.size.height/4 + numLabel.frame.size.height/2 - 5);
    [view addSubview:numLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, CGRectGetMaxY(numLabel.frame)+10, view.frame.size.width, 20);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = key;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.center =CGPointMake(frame.size.width/2, frame.size.height/2 + nameLabel.frame.size.height/2);
    [view addSubview:nameLabel];
    
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = frame.size.width/2;
    view.layer.borderWidth = 2;
    view.layer.borderColor = color.CGColor;
    
    return view;
}

@end
