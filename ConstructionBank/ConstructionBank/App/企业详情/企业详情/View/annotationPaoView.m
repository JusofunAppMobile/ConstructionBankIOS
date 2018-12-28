//
//  annotationPaoView.m
//  EnterpriseInquiry
//
//  Created by clj on 15/11/24.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "annotationPaoView.h"

@implementation annotationPaoView

-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if(self)
    {
        CGSize size =  [self labelAutoCalculateRectWith:title FontSize:14 MaxSize:CGSizeMake(279 - 60, 60)];
        CGFloat width = 20 + size.width + 60;
        CGFloat height = 60;
        self.frame = KFrame(0, 0, width, height);
        
        UIImageView *imageViewLeft = [[UIImageView alloc] init];
        imageViewLeft.frame = CGRectMake(0, 0,self.frame.size.width/2, self.frame.size.height);
        imageViewLeft.image = [[UIImage imageNamed:@"mapPaoLeft"]  resizableImageWithCapInsets:UIEdgeInsetsMake(5, 3,3,20)];
        [self addSubview:imageViewLeft];

        
        UIImageView *imageViewRight = [[UIImageView alloc] init];
        imageViewRight.frame = CGRectMake(self.frame.size.width/2, 0,self.frame.size.width/2, self.frame.size.height);
        imageViewRight.image = [[UIImage imageNamed:@"mapPaoRight"]  resizableImageWithCapInsets:UIEdgeInsetsMake(5, 6.8,5,52.8)];
        [self addSubview:imageViewRight]; 
    
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(10, 5, size.width, size.height)];
        label.text = title;
        label.numberOfLines = 2;
        label.textColor = [UIColor blackColor];
        label.font = KFont(14);
        label.backgroundColor = [UIColor clearColor];
        label.center = CGPointMake(10+ size.width/2, height/2 -5);
        [self addSubview:label];

        
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.frame = CGRectMake(0, 0, 8, 13);
        iconImage.image = [UIImage imageNamed:@"icon_map"];
        iconImage.center = CGPointMake(self.frame.size.width - 26, 17);
        [self addSubview:iconImage];
        

        UILabel *daoHangLabel = [[UILabel alloc] init];
        daoHangLabel.frame = CGRectMake(self.frame.size.width - 52, CGRectGetMaxY(iconImage.frame)+ 6 , 52, 20);
        daoHangLabel.text = @"导航";
        daoHangLabel.textAlignment = NSTextAlignmentCenter;
        daoHangLabel.textColor = [UIColor whiteColor];
        [self addSubview:daoHangLabel];
        
    }
    
    return self;
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:KFont(fontSize),NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}



@end
