//
//  ItemView.m
//  EnterpriseInquiry
//
//  Created by clj on 15/11/13.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "ItemView.h"
#import "UIImageView+WebCache.h"


@implementation ItemButton
-(id)initWithFrame:(CGRect)frame andButtonTitle:(NSString *)buttonTitle andIsNeedImageView:(BOOL)isNeed andHotImageURL:(NSString *)HotImageURL
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleName = buttonTitle;
        self.titleLabel.font = KFont(13);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitle:buttonTitle forState:UIControlStateNormal];
//        [self setTitleColor:KHexRGB(0x342927) forState:UIControlStateNormal];
        [self setTitleColor:KHexRGB(0xFF6400) forState:UIControlStateNormal];
        if (isNeed) {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            self.layer.cornerRadius = 5;
            self.clipsToBounds = YES;
            self.layer.borderColor = KRGB(236, 236, 236).CGColor;
            self.layer.borderWidth = 1;
            self.backgroundColor = [UIColor whiteColor];

        }else
        {
           // UIImage *image = [UIImage imageNamed:@"dwtz20151127"];
            UIImage *Scaleimage = [Tools scaleImage:KImageName(@"dwtz20151127") size:CGSizeMake(30 * KScaleWidth, 30 *KScaleWidth)];
            [self setImage:Scaleimage forState:UIControlStateNormal];
            [self setTitle:buttonTitle forState:UIControlStateNormal];
            self.titleLabel.font = KFont(13);
            self.titleLabel.textColor = KHexRGB(0x333333);
            self.backgroundColor = [UIColor whiteColor];
            //self.layer.borderColor = KRGB(235,235,235).CGColor;
            //self.layer.borderWidth = 0.5;
            [self centerImageAndTitle];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:KFrame(frame.size.width-0.5, 0, 0.5, frame.size.height)];
            lineView2.backgroundColor = KRGB(235,235,235);
            [self addSubview:lineView2];
            
            UIView *lineView3 = [[UIView alloc]initWithFrame:KFrame(0, frame.size.height-0.5, frame.size.width, 0.5)];
            lineView3.backgroundColor = KRGB(235,235,235);
            [self addSubview:lineView3];
            
            //HotImageURL = @"http://top.bdimg.com/frontend/static/common/images/icon-tuan.png";
            
//            if(HotImageURL.length >0)
//            {
//
//                self.hotImageView = [[UIImageView alloc]initWithFrame:KFrame(CGRectGetWidth(self.frame) - 36, 0, 36, 18)];
//                //self.hotImageView.backgroundColor = [UIColor redColor];
//                [self addSubview:_hotImageView];
//                
//                SDWebImageManager *manager = [SDWebImageManager sharedManager];
//                [manager downloadImageWithURL:[NSURL URLWithString:HotImageURL]
//                                      options:0
//                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                         
//                                     }
//                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                        if (image) {
//                                            
//                                            UIImage *Scaleimage = [Tools scaleImage:image size:CGSizeMake(36, 18)];
//                                            _hotImageView.image = Scaleimage;
//                                            
//                                        }
//                                    }];
//                
//            }
            
        }
        
    }
    return self;
}



-(id)initWithFrame:(CGRect)frame andButtonTitle:(NSString *)buttonTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleName = buttonTitle;
        self.titleLabel.font = KFont(13);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitle:buttonTitle forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:KHexRGB(0xfe6306) forState:UIControlStateSelected];
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:KFrame(frame.size.width-0.5, 0, 0.5, frame.size.height)];
        lineView2.backgroundColor = KHexRGB(0xd9d9d9);
        [self addSubview:lineView2];
        
        UIView *lineView3 = [[UIView alloc]initWithFrame:KFrame(0, frame.size.height-0.5, frame.size.width, 0.5)];
        lineView3.backgroundColor = KHexRGB(0xd9d9d9);
        [self addSubview:lineView3];
    }
    return self;
}








-(void)centerImageAndTitle:(float)space
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight -imageSize.height) + 10, 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, - imageSize.width, - (totalHeight - titleSize.height) - 8, 0.0);
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 8.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

@end



@implementation ItemView

-(id)initWithframe:(CGRect)frame andArray:(NSArray *)dataArray andIsNeedImageView:(BOOL)isNeed andCurrentModel:(ItemModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentSquareModel = model;
        
        self.backgroundColor = KRGB(242, 243, 244);
        _itemArray = [NSMutableArray arrayWithArray:dataArray];
        _itemBtnArray = [NSMutableArray arrayWithCapacity:1];
        [self createButtonIsNeedImageView:isNeed];
    }
    return self;
}

-(id)initWithframe:(CGRect)frame andArray:(NSArray *)dataArray andThisModel:(ItemModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemArray = [NSMutableArray arrayWithArray:dataArray];
        [self createButtonWithModel:model];
    }
    return self;
}

-(void)createButtonWithModel:(ItemModel *)model
{
    //self.backgroundColor = [Utility hexStringToColor:@"#d9d9d9"];
    self.backgroundColor = [UIColor whiteColor];
    CGPoint point = CGPointMake(0,1);
    UIView *lineView1 = [[UIView alloc]initWithFrame:KFrame(0, 0, self.frame.size.width, 0.5)];
    lineView1.backgroundColor = KHexRGB(0xd9d9d9);
    [self addSubview:lineView1];

    for (int i=0; i< _itemArray.count; i++) {
        
        ItemModel *sqModel = [ItemModel mj_objectWithKeyValues:[_itemArray objectAtIndex:i]];
        //ItemModel *sqModel = (ItemModel *)[_itemArray objectAtIndex:i];
        NSString *title =[NSString stringWithFormat:@"%@",sqModel.menuname];
        
        ItemButton *button = [[ItemButton alloc] initWithFrame:CGRectMake(point.x,point.y ,  ([UIScreen mainScreen].bounds.size.width-2*0.5)/3, 35) andButtonTitle:title];
        button.squareModel = sqModel;
        [button addTarget:self action:@selector(pullItemClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([model.menuname isEqual:sqModel.menuname]) {
            button.selected = YES;
        }
        if ([button.squareModel.hasData integerValue] == 1) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.enabled = YES;
        }else
        {
            [button setTitleColor:KHexRGB(0xaaaaaa) forState:UIControlStateNormal];
            button.enabled = NO;
        }

        if ((i+1)%3 == 0 ) {
            point.x = 0;
            point.y = point.y + 35;
        }else
        {
            point.x = point.x +  ([UIScreen mainScreen].bounds.size.width-2*0.5)/3 ;
        }
        [self addSubview:button];
    }

}



-(void)createButtonIsNeedImageView:(BOOL)isNeed
{
    if (isNeed) {
        CGPoint point = CGPointMake(16, 0);
        for (int i=0; i< _itemArray.count; i++) {
             ItemModel *sqModel = [ItemModel mj_objectWithKeyValues:[_itemArray objectAtIndex:i]];
           // ItemModel *sqModel = (ItemModel *)[_itemArray objectAtIndex:i];
            NSString *title =[NSString stringWithFormat:@"%@",sqModel.menuname];
            
            ItemButton *button = [[ItemButton alloc] initWithFrame:CGRectMake(point.x,point.y , ([UIScreen mainScreen].bounds.size.width-50)/4, 26) andButtonTitle:title andIsNeedImageView:isNeed andHotImageURL:@""];
            button.squareModel = sqModel;
            
            if ([self.currentSquareModel.menuname isEqualToString:button.squareModel.menuname]) {
                button.selected = YES;
                button.backgroundColor = KRGB(251, 123, 47);
//                button.layer.borderColor = KHexRGB(0xf6996e).CGColor;
            }
            
            [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            

            if ((i+1)%4 == 0 ) {
                point.x = 16;
                point.y = point.y + button.height + 15;
            }else
            {
                point.x = point.x + ([UIScreen mainScreen].bounds.size.width-62)/4 + 10;
            }
            [self addSubview:button];
        }
 
    }else
    {
       // self.backgroundColor = [Utility hexStringToColor:@"#d9d9d9"];
        CGPoint point = CGPointMake(0, 0.5);
        for (int i=0; i< _itemArray.count; i++) {
             ItemModel *sqModel = [ItemModel mj_objectWithKeyValues:[_itemArray objectAtIndex:i]];
            //ItemModel *sqModel = (ItemModel *)[_itemArray objectAtIndex:i];
            NSString *title =[NSString stringWithFormat:@"%@",sqModel.menuname];
            
            ItemButton *button = [[ItemButton alloc] initWithFrame:CGRectMake(point.x,point.y , ([UIScreen mainScreen].bounds.size.width-3*0.5)/4, 72*([UIScreen mainScreen].bounds.size.height / 568.0)) andButtonTitle:title andIsNeedImageView:isNeed andHotImageURL:sqModel.HotImageUrl];
            button.squareModel = sqModel;
            [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([button.squareModel.hasData integerValue] == 1) {
                
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.enabled = YES;
            }else
            {
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                button.enabled = NO;
                
            }
            
            //获取图片名
           // NSArray *array = [iconUrl componentsSeparatedByString:@"/"];
           // NSString *imageNameStr = array.lastObject;
            NSString *imageNameStr = @"personal_logo";
            UIImage *Scaleimage = [Tools scaleImage:KImageName(imageNameStr) size:CGSizeMake(28* KScaleWidth, 28*KScaleWidth)];
            [button setImage:Scaleimage forState:UIControlStateNormal];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:button.squareModel.ItemUrls]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
//                                     NSLog(@"%ld",receivedSize/expectedSize);
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        
                                        UIImage *Scaleimage = [Tools scaleImage:image size:CGSizeMake(30* KScaleWidth, 30*KScaleWidth)];
                                        [button setImage:Scaleimage forState:UIControlStateNormal];
                                    }
                                }];
            
            
            if ((i+1)%4 == 0 ) {
                point.x = 0;
                point.y = point.y + 72*([UIScreen mainScreen].bounds.size.height / 568.0)+  0.5;
            }else
            {
                point.x = point.x + ([UIScreen mainScreen].bounds.size.width-3*0.5)/4 +  0.5;
            }
            [self addSubview:button];
            
            if(sqModel.HotImageUrl.length >0)
            {
                [_itemBtnArray addObject:button];
            }
            
        }
        
        [self setHotImageViewMove];
    }
}


-(void)setHotImageViewMove
{
    int num = 2;
    
    NSArray *randomArray = [self randomArray:_itemBtnArray];

    
    
    for(int i = 0;i<randomArray.count;i++)
    {
        ItemButton *btn = (ItemButton *)[randomArray objectAtIndex:i];
        [btn.hotImageView.layer removeAllAnimations];
        [self hotImageViewAnimation:btn.hotImageView num:num];
        num += 10;
    }
    
    
}


-(NSArray *)randomArray:(NSArray *)temp
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:temp];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    int i;
    int count = (int)temp.count;
    for (i = 0; i < count; i ++) {
        int index = arc4random() % (count - i);
        [resultArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
        
    }
    
    
    return resultArray;
}


-(void)hotImageViewAnimation:(UIImageView *)imageView num:(int)num
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(num * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        CGFloat currentTx = imageView.transform.tx;
        float time = _itemBtnArray.count *10.0;
        float moveTime = 0.0025;//移动的时间
        animation.duration = time;
        animation.repeatCount = MAXFLOAT;
        animation.values = @[ @(currentTx), @(currentTx - 6), @(currentTx), @(currentTx - 4), @(currentTx), @(currentTx - 2), @(currentTx) ];
       // animation.keyTimes = @[ @(0), @(0.00025), @(0.0005), @(0.00075), @(0.0010), @(0.00125),@(0.0015) ];
        animation.keyTimes = @[ @(0), @(moveTime/6/time), @(moveTime/6*2/time), @(moveTime/6*3/time), @(moveTime/6*4/time), @(moveTime/6*5/time),@(moveTime/6*6/time) ];
        //animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [imageView.layer addAnimation:animation forKey:@"AnimationKey"];
    });
}


-(void)itemClick:(ItemButton *)button
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(ItemButtonClick:)]) {
        [_delegate ItemButtonClick:button];
    }
}



-(void)pullItemClick:(ItemButton *)button
{
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(pullItemButtonClick:)]) {
        [self cancleSelected];
        [_delegate pullItemButtonClick:button];
    }
}



//取消选中状态
-(void)cancleSelected
{
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[ItemButton class]])
        {
            ItemButton *button = (ItemButton *)view;
            button.selected = NO;
        }
        
    }
}



@end
