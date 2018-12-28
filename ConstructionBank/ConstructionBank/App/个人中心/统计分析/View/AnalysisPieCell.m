//
//  AnalysisPieCell.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnalysisPieCell.h"

@implementation AnalysisPieCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.pieChart = [[DVPieChart alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 210-60)];

       // [self.contentView addSubview:self.pieChart];
        
        
        self.pieChart = [[YTLPieView alloc] initWithFrame:CGRectMake(0, 0, KDeviceW, 210)
                                                        dataItems:@[@0.1,@0.1]
                                                       colorItems:@[
                                                                    [UIColor colorWithRed:44/255.0 green:164/255.0 blue:241/255.0 alpha:1.00f],
                                                                    KRGB(253, 176, 66),
                                                                    [UIColor colorWithRed:1.00f green:0.23f blue:0.19f alpha:1.00f],
                                                                    [UIColor blackColor]]
                                                      upTextItems:@[@"0",@"0"]
                                                    downTextItems:@[@"正式客户",@"跟进客户"]];
        [self.contentView addSubview:self.pieChart];
        
        
        
    }
    return self;
}


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.pieChart.hidden = NO;
    self.placeHolderView.hidden = YES;
    
    float formalNum = [[dataDic objectForKey:@"formalCount"] floatValue];
    float followNum = [[dataDic objectForKey:@"followCount"] floatValue];
    
    if(followNum == 0 && followNum == 0)
    {
        self.placeHolderView.hidden = NO;
        self.pieChart.hidden = YES;
        return;
    }
    
//    float formalNum = 14;
//    float followNum = 15;
    
    self.pieChart.dataItems = @[[NSNumber numberWithFloat:formalNum],[NSNumber numberWithFloat:(float)followNum]];
    self.pieChart.upTextItems = @[[NSString stringWithFormat:@"%d",(int)formalNum],[NSString stringWithFormat:@"%d",(int)followNum],];
    [self.pieChart draw];
    
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
