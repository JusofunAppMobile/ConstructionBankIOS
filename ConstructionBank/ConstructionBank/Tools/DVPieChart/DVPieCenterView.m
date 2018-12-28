//
//  DVPieCenterView.m
//  DVPieChart
//
//  Created by SmithDavid on 2018/2/27.
//  Copyright © 2018年 SmithDavid. All rights reserved.
//

#import "DVPieCenterView.h"

@interface DVPieCenterView ()
{
    
}

@property (strong, nonatomic) UIView *centerView;

@end



@implementation DVPieCenterView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        
        
        
        UIView *centerView = [[UIView alloc] init];
        
        centerView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:centerView];
        self.centerView = centerView;
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = KHexRGB(0xFFA000);
        nameLabel.font = [UIFont systemFontOfSize:24];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.numberOfLines = 0;
        self.nameLabel = nameLabel;
        
      
        
        
        
        
        [centerView addSubview:nameLabel];
    }
    
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.masksToBounds = true;
    
    self.centerView.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height );
    self.centerView.layer.cornerRadius = self.centerView.frame.size.width * 0.5;
    self.centerView.layer.masksToBounds = true;
    
    self.nameLabel.frame = self.centerView.bounds;
}


-(void)setTitle:(NSString *)title
{
    _title = title;
    
    NSString *string = [NSString stringWithFormat:@"%@\n客户总数",title];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, string.length-4)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(string.length-4, 4)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KRGB(251, 156, 44) range:NSMakeRange(0, string.length-4)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KRGB(49, 49, 49) range:NSMakeRange(string.length-4, 4)];
    
    self.nameLabel.attributedText = attributedString;
    
}

@end
