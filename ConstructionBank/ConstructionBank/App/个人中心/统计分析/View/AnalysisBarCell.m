//
//  AnalysisBarCell.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnalysisBarCell.h"

@implementation AnalysisBarCell
{
    NSMutableArray *followArray;
    NSMutableArray *formalwArray;
    NSMutableArray *dateArray;
    UIButton *followBtn;
    UIButton *formalBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        followArray = [NSMutableArray arrayWithCapacity:1];
        formalwArray = [NSMutableArray arrayWithCapacity:1];
        dateArray = [NSMutableArray arrayWithCapacity:1];
        
        self.barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        self.barChart.dataSource = self;
        self.barChart.delegate = self;
        self.barChart.isShadowForValueLabel = NO;
        self.barChart.valueLabelPattern = kPopoverLabelPatternPopover;
        self.barChart.isShowAxisLineValue = NO;
        self.barChart.isShowYLineSeparate = YES;
        self.barChart.isShowXLineSeparate = NO;
        self.barChart.isShowAxisArrows = NO;
        self.barChart.xAxisColor = KRGB(205, 205, 205);
        self.barChart.separateColor = KRGB(246, 246, 246);
        self.barChart.yAxisColor = [UIColor whiteColor];
        self.barChart.axisLineNameFont = KFont(10);
        // self.barChart.axisLineNameColor = ZFWhite;
        self.barChart.axisLineValueColor = KRGB(175, 175, 175);
        self.barChart.axisLineNameColor = KRGB(175, 175, 175);
        self.barChart.separateLineStyle = kLineStyleDashLine;
        self.barChart.valueType = kValueTypeInteger;
        self.barChart.numberOfDecimal = 2;
        //  self.barChart.genericAxis = 20;
        [self.barChart strokePath];
        [self.contentView addSubview:self.barChart];
        
        UIView *view = [[UIView alloc]initWithFrame:KFrame(KDeviceW/2-70-15, 15, 10, 10)];
        view.backgroundColor = KRGB(251, 157, 49);
        [self.contentView addSubview:view];
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(view.maxX+5, view.y, 70, 10)];
        label.font = KFont(10);
        label.text = @"新增跟进客户";
        label.textColor = KHexRGB(0x999999);
        [self.contentView addSubview:label];
        
        UIView *view2 = [[UIView alloc]initWithFrame:KFrame(KDeviceW/2+ 20, 15, 10, 10)];
        view2.backgroundColor = KRGB(52, 167, 239);
        [self.contentView addSubview:view2];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:KFrame(view2.maxX+5, view2.y, label.width, 10)];
        label2.font = KFont(10);
        label2.text = @"新增正式客户";
        label2.textColor = KHexRGB(0x999999);
        [self.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:KFrame(15, self.barChart.maxY + 30, 90, 15)];
        label3.font = KFont(12);
        label3.text = @"跟进客户拓展率";
        label3.textColor = KHexRGB(0x666666);
        [self.contentView addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:KFrame((KDeviceW-15*3)/2.0+30, label3.y, 90, 15)];
        label4.font = KFont(12);
        label4.text = @"正式客户转化率";
        label4.textColor = KHexRGB(0x666666);
        [self.contentView addSubview:label4];
        
        followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.frame = KFrame(15, label4.maxY+7, (KDeviceW-15*3)/2.0, 95);
        followBtn.layer.cornerRadius = 5;
        followBtn.clipsToBounds = YES;
        followBtn.backgroundColor = KRGB(250, 250, 250);
        [self.contentView addSubview:followBtn];
        
       
        
        
        formalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        formalBtn.frame = KFrame(label4.x, label4.maxY+7, (KDeviceW-15*3)/2.0, 95);
        formalBtn.layer.cornerRadius = 5;
        formalBtn.clipsToBounds = YES;
        formalBtn.backgroundColor = KRGB(250, 250, 250);
        [self.contentView addSubview:formalBtn];
        
        
        
        UILabel *label5 = [[UILabel alloc]initWithFrame:KFrame(formalBtn.width-45, formalBtn.height-20, 40, 10)];
        label5.font = KFont(12);
//        label5.text = @"查看 >";
        label5.textColor = KHexRGB(0x999999);
        [formalBtn addSubview:label5];
        
        UILabel *label6 = [[UILabel alloc]initWithFrame:KFrame(formalBtn.width-45, formalBtn.height-20, 40, 10)];
        label6.font = KFont(12);
//        label6.text = @"查看 >";
        label6.textColor = KHexRGB(0x999999);
        [formalBtn addSubview:label6];
        
         
        [self.contentView bringSubviewToFront:self.placeHolderView];
        

    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    
    self.dataArray = [dataDic objectForKey:@"addTrendList"];
    
    int formaltRateState = [[dataDic objectForKey:@"formaltRateState"]intValue];
    int followRateState = [[dataDic objectForKey:@"followRateState"]intValue];
    
    
    //self.barChart.hidden = NO;

    
    
    NSArray *imageArray = @[KImageName(@"下箭头"),KImageName(@"上箭头"),KImageName(@"yuedengyu")];
    
    float followRate = [[dataDic objectForKey:@"followRate"]floatValue];
    NSString *string = [NSString stringWithFormat:@"%.1f%% ",followRate];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:NSMakeRange(0, string.length-2)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(string.length-2, 2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KRGB(251, 157, 49) range:NSMakeRange(0, string.length-2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KRGB(145, 145, 145) range:NSMakeRange(string.length-2, 2)];
    
    NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
    imageAtta.bounds = CGRectMake(0, 0, 15, 15);
    imageAtta.image = [imageArray objectAtIndex:followRateState];
    NSAttributedString *attach = [NSAttributedString attributedStringWithAttachment:imageAtta];
    [attributedString appendAttributedString:attach];
    
    [followBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    float formaltRate = [[dataDic objectForKey:@"formaltRate"]floatValue];
    NSString *string2 = [NSString stringWithFormat:@"%.1f%% ",formaltRate];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:string2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:NSMakeRange(0, string2.length-2)];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(string2.length-2, 2)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:KRGB(43, 159, 238) range:NSMakeRange(0, string2.length-2)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:KRGB(145, 145, 145) range:NSMakeRange(string2.length-2, 2)];
    
    NSTextAttachment *imageAtta2 = [[NSTextAttachment alloc] init];
    imageAtta2.bounds = CGRectMake(0, 0, 15, 15);
    imageAtta2.image = [imageArray objectAtIndex:formaltRateState];;
    NSAttributedString *attach2 = [NSAttributedString attributedStringWithAttachment:imageAtta2];
    [attributedString2 appendAttributedString:attach2];
    
    [formalBtn setAttributedTitle:attributedString2 forState:UIControlStateNormal];
    
}
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    self.placeHolderView.hidden = YES;
    if(dataArray.count == 0)
    {
        self.placeHolderView.hidden = NO;
        self.placeHolderView.frame = KFrame(0, 0, self.width, self.barChart.height);
        return;
    }
    
    followArray = [NSMutableArray arrayWithCapacity:1];
    formalwArray = [NSMutableArray arrayWithCapacity:1];
    dateArray = [NSMutableArray arrayWithCapacity:1];
    
    for(NSDictionary *dic in _dataArray)
    {
        [followArray addObject:KNSString([dic objectForKey:@"followCount"])];
        [formalwArray addObject:KNSString([dic objectForKey:@"formalCount"])];
        [dateArray addObject:KNSString([dic objectForKey:@"date"])];
    }
    
    [self.barChart strokePath];
}


-(void)layoutSubviews
{
    self.placeHolderView.frame = KFrame(0, 0, self.width, self.barChart.height);
    
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    
    return @[followArray,formalwArray];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return dateArray;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[KRGB(250, 151, 47), KRGB(12, 130, 233)];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 30;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return 100;
//}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 5;
}

#pragma mark - ZFBarChartDelegate

- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart{
    return 10.f;
}

- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart{
    return 40.f;
}

- (CGFloat)paddingForBarInBarChart:(ZFBarChart *)barChart{
    return 10.f;
}

- (id)valueTextColorArrayInBarChart:(ZFBarChart *)barChart{
    return ZFBlue;
    //    return @[ZFColorA(71, 204, 255, 1), ZFColorA(253, 203, 76, 1), ZFColorA(16, 140, 39, 1)];
}

- (NSArray<ZFGradientAttribute *> *)gradientColorArrayInBarChart:(ZFBarChart *)barChart{
    //该组第1个bar渐变色
    ZFGradientAttribute * gradientAttribute1 = [[ZFGradientAttribute alloc] init];
    gradientAttribute1.colors = @[(id)KRGB(250, 152, 48).CGColor, (id)KRGB(253, 199, 60).CGColor];
    gradientAttribute1.locations = @[@(0.5), @(0.99)];
    gradientAttribute1.startPoint = CGPointMake(0, 0);
    gradientAttribute1.endPoint = CGPointMake(1, 1);

    //该组第2个bar渐变色
    ZFGradientAttribute * gradientAttribute2 = [[ZFGradientAttribute alloc] init];
    gradientAttribute2.colors = @[(id)KRGB(65, 153, 246).CGColor, (id)KRGB(88, 197, 244).CGColor];
    gradientAttribute2.locations = @[@(0.5), @(0.99)];
    gradientAttribute2.startPoint = CGPointMake(0,0 );
    gradientAttribute2.endPoint = CGPointMake(1, 1);

   

    return [NSArray arrayWithObjects:gradientAttribute1, gradientAttribute2, nil];
}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex bar:(ZFBar *)bar popoverLabel:(ZFPopoverLabel *)popoverLabel{
    //特殊说明，因传入数据是3个subArray(代表3个类型)，每个subArray存的是6个元素(代表每个类型存了1~6年级的数据),所以这里的groupIndex是第几个subArray(类型)
    //eg：三年级第0个元素为 groupIndex为0，barIndex为2
    NSLog(@"第%ld个颜色中的第%ld个",(long)groupIndex,(long)barIndex);
    
    //可在此处进行bar被点击后的自身部分属性设置
    //    bar.barColor = ZFDeepPink;
    //    bar.isAnimated = YES;
    //    bar.opacity = 0.5;
    //    [bar strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    popoverLabel.hidden = NO;
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    //理由同上
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    //    popoverLabel.textColor = ZFSkyBlue;
    //    [popoverLabel strokePath];
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
