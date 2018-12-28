//
//  AnalysisHeadView.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnalysisHeadView.h"

@implementation AnalysisHeadView
{
    UIImageView *headImageView;
    UILabel*nameLabel;
    UILabel *jobLabel;
    UILabel *allLabel;
    UILabel *allNumLabel;
    UILabel *newLabel;
    UILabel *newNumLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //95
        headImageView = [[UIImageView alloc]init];
        headImageView.image = KImageName(@"AppIcon");
        [self addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(15);
            make.top.mas_equalTo(self).offset(15);
            make.width.height.mas_equalTo(65);
        }];
        
        float width = (KDeviceW-headImageView.width-30-20-10-30)/2.0;
        
        nameLabel = [[UILabel alloc]init];
        [self addSubview:nameLabel];
        nameLabel.font = KFont(16);
        nameLabel.textColor = KHexRGB(0x333333);
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(20);
            make.left.mas_equalTo(headImageView.mas_right).offset(20);
                make.height.mas_equalTo(18);
            make.width.mas_lessThanOrEqualTo(width);
            
        }];
        
        jobLabel = [[UILabel alloc]init];
        [self addSubview:jobLabel];
        jobLabel.font = KFont(12);
        jobLabel.textColor = KHexRGB(0x999999);
        [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(nameLabel);
                make.top.mas_equalTo(nameLabel); make.left.mas_equalTo(nameLabel.mas_right).offset(10);
                make.width.mas_lessThanOrEqualTo(width);
        }];
        
        allLabel = [[UILabel alloc]init];
        [self addSubview:allLabel];
        allLabel.font = KFont(14);
        allLabel.text = @"客户总数:";
        allLabel.textColor = KHexRGB(0x333333);
        [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.mas_equalTo(nameLabel);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
            make.width.mas_equalTo(65);
        }];
        
       
        
        float numWidth = width - 65;
        
        allNumLabel = [[UILabel alloc]init];
        [self addSubview:allNumLabel];
        allNumLabel.font = KFont(14);
        allNumLabel.textColor = KRGB(248, 124, 60);
        [allNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(allLabel.mas_right);
            make.height.top.mas_equalTo(allLabel);
            make.width.mas_lessThanOrEqualTo(numWidth);
        }];
        
        
        
        newLabel = [[UILabel alloc]init];
        [self addSubview:newLabel];
        newLabel.text = @"新增:";
        newLabel.font = allLabel.font;
        newLabel.textColor = allLabel.textColor;
        [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headImageView.mas_right).offset(width+10);
            make.height.top.mas_equalTo(allLabel);
            make.width.mas_equalTo(40);
            
        }];
        
       
        newNumLabel = [[UILabel alloc]init];
        [self addSubview:newNumLabel];
        newNumLabel.font = allNumLabel.font;
        newNumLabel.textColor = allNumLabel.textColor;
        [newNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(newLabel.mas_right);
            make.height.top.mas_equalTo(allNumLabel);
            make.width.mas_lessThanOrEqualTo(numWidth);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, -1 , self.frame.size.width , 1);
        lineView.backgroundColor = KRGB(217, 217, 217);
        
        [self addSubview:lineView];
        
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    nameLabel.text = KUSER.realName;
    jobLabel.text = KUSER.organName;
    allNumLabel.text = KNSString([dataDic objectForKey:@"clientCount"]) ;
    newNumLabel.text = KNSString([dataDic objectForKey:@"addCount"]) ;
}


@end
