//
//  DetailGridCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DetailGridCell.h"
@interface DetailGridCell()
{
    BOOL isOver;
}
@end
@implementation DetailGridCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor  = [UIColor whiteColor];
        [self drawView:nil];
        isOver = NO;
    }
    
    return self;
}


-(void)setCellData:(NSArray *)dataArray
{
    [self drawView:dataArray];
}

-(void)buttonClick:(UIButton*)button
{
    
    if(self.detailGridDelegate && [self.detailGridDelegate respondsToSelector:@selector(gridButtonClick:cellSection:)])
    {
        [self.detailGridDelegate gridButtonClick:(GridButton*)button cellSection:self.section];
    }
}

-(void)drawView:(NSArray*)dataArray
{
    if(isOver)
    {
        return;
    }
    for(UIView *view in self.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    if(!dataArray || dataArray.count == 0)
    {
        for(int i = 0;i<11;i++)
        {
            GridButton *button = [[GridButton alloc]initWithFrame:KFrame(x, y, KDetailGridWidth, KDetailGridWidth)];
            [button setImage:KImageName(@"personal_logo") forState:UIControlStateNormal];
            [button setTitle:@"--" forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            
            x = x+KDetailGridWidth;
            if(x >= KDeviceW)
            {
                y = y+KDetailGridWidth;
                x = 0;
            }
            
        }
    }
    else
    {
        isOver = YES;
        for(int i = 0;i<dataArray.count;i++)
        {
            NSDictionary *dic = [dataArray objectAtIndex:i];
            
            GridButton *button = [[GridButton alloc]initWithFrame:KFrame(x, y, KDetailGridWidth, KDetailGridWidth)];
            [button setImage:KImageName(@"personal_logo") forState:UIControlStateNormal];
            button.buttonDic = dic;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            NSString *countStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"count"]];
           
            if(countStr.length == 0||[countStr isEqualToString:@"null"]||[countStr isEqualToString:@"NULL"]||[countStr isEqualToString:@"<null>"]||[countStr isEqualToString:@"-"]||[countStr isEqualToString:@"(null)"])
            {
                countStr = @"";
            }
            
            if([countStr intValue] > 99)
            {
                countStr = @"99+";
            }
            
            button.counLabel.text = countStr;

            
            [self.contentView addSubview:button];
            
            [button setTitle:[dic objectForKey:@"menuname"] forState:UIControlStateNormal];
            
            if ([[dic objectForKey:@"hasData"]  integerValue] == 1) {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.enabled = YES;
                
            }else
            {
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                button.enabled = NO;
            }
            NSString* urlstr = [[dic objectForKey:@"icon"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:urlstr]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        
                                        [button setImage:image forState:UIControlStateNormal];
                                    }
                                }];

            
            
            x = x+KDetailGridWidth;
            if(x >= KDeviceW)
            {
                y = y+KDetailGridWidth;
                x = 0;
            }

        }
    }
    
    
    
}



@end

@implementation GridButton



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _counLabel = [[UILabel alloc]initWithFrame:KFrame(frame.size.width - 10 -50, 10, 50, 10)];
        _counLabel.text = @"";
        _counLabel.textColor = KHexRGB(0x999999);
        _counLabel.font = KBlodFont(11);
        _counLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_counLabel];
        
        CALayer *border = [CALayer layer];
        border.frame = CGRectMake(frame.size.width-0.5, 0, 0.5, frame.size.height);
        border.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00].CGColor;
        [self.layer addSublayer:border];
        
        
        CALayer *border2 = [CALayer layer];
        border2.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
        border2.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00].CGColor;
        [self.layer addSublayer:border2];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        self.titleLabel.font = KFont(13);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
       
    }
    
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = KFrame(KDetailGridWidth/2-10, 25, 20, 23);
    self.titleLabel.frame = KFrame(10, self.imageView.maxY + 10, KDetailGridWidth-20, 15);

}

@end
