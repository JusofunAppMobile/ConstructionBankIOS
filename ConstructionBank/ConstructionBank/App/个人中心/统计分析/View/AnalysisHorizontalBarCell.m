//
//  AnalysisHorizontalBarCell.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnalysisHorizontalBarCell.h"

@implementation AnalysisHorizontalBarCell
{
    NSMutableArray *countArray;
    NSMutableArray *nameArray;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.barChart = [[ZFHorizontalBarChart alloc] initWithFrame:CGRectMake(0, -10, SCREEN_WIDTH, 200)];
        self.barChart.dataSource = self;
        self.barChart.delegate = self;
        self.barChart.topicLabel.hidden = YES;
        self.barChart.unit = @"";
        self.barChart.topicLabel.textColor = ZFPurple;
        self.barChart.isShowAxisArrows = NO;
        self.barChart.horizontalAxis.yAxisLine.changeAxisLineStartXPos = 80;
        self.barChart.horizontalAxis.xAxisLine.changeAxisLineStartXPos = 80;
//         self.barChart.horizontalAxis.yAxisLine.yLineEndXPos = 80;
        //self.barChart.xLineNameLabelToXAxisLinePadding = 100;
        //    self.barChart.valueLabelPattern = kPopoverLabelPatternBlank;
        //    self.barChart.isResetAxisLineMinValue = YES;
        //    self.barChart.isShowXLineSeparate = YES;
        //    self.barChart.isShowYLineSeparate = YES;
        //    self.barChart.backgroundColor = ZFPurple;
        //    self.barChart.unitColor = ZFWhite;
        self.barChart.xAxisColor = ZFWhite;
        self.barChart.yAxisColor = ZFColor(153, 153, 153);;
        self.barChart.isShadowForValueLabel = NO;
        self.barChart.valueLabelPattern = kPopoverLabelPatternBlank;
        //    self.barChart.axisLineNameColor = ZFWhite;
        self.barChart.axisLineValueColor = ZFWhite;
        // self.barChart.isShowAxisLineValue = NO;
        //    self.barChart.isAnimated = NO;
        //    self.barChart.separateLineStyle = kLineStyleDashLine;
        //    self.barChart.separateLineDashPhase = 0.f;
        //    self.barChart.separateLineDashPattern = @[@(5), @(5)];
            self.barChart.isMultipleColorInSingleBarChart = YES;
        
       // self.barChart.genericAxis.yLineStartXPos = 60;
        [self.contentView addSubview:self.barChart];
        [self.barChart strokePath];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    
    
    
    NSArray *array = [dataDic objectForKey:@"followSitList"];
    
    self.barChart.hidden = NO;
    self.placeHolderView.hidden = YES;
    if(array.count == 0)
    {
        self.placeHolderView.hidden = NO;
        self.barChart.hidden = YES;
        return;
    }
    
    countArray = [NSMutableArray arrayWithCapacity:1];
    nameArray = [NSMutableArray arrayWithCapacity:1];
    for(NSDictionary *dic in array)
    {
        [countArray addObject:KNSString([dic objectForKey:@"count"])];
        [nameArray addObject:KNSString([dic objectForKey:@"label"])];
    }
    
    [self.barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return countArray;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return nameArray;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    //return @[ZFRandom];

    return @[KRGB(95, 206, 225),KRGB(217, 113, 180), KRGB(249, 128, 41), KRGB(94, 204, 95),KRGB(223, 44, 48)];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return 50;
//}

//- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
//    return 10;
//}

//- (NSInteger)axisLineStartToDisplayValueAtIndex:(ZFGenericChart *)chart{
//    return -7;
//}

- (void)genericChartDidScroll:(UIScrollView *)scrollView{
    NSLog(@"当前偏移量 ------ %f", scrollView.contentOffset.y);
}

#pragma mark - ZFHorizontalBarChartDelegate

- (CGFloat)barHeightInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
    return 10.f;
}

- (CGFloat)paddingForGroupsInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
    return 15.f;
}

//- (CGFloat)paddingForBarInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
//    return 5.f;
//}

- (id)valueTextColorArrayInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
    return ZFColor(102, 102, 102);
}

//- (NSArray<ZFGradientAttribute *> *)gradientColorArrayInHorizontalBarChart:(ZFHorizontalBarChart *)barChart{
//    ZFGradientAttribute * gradientAttribute = [[ZFGradientAttribute alloc] init];
//    gradientAttribute.colors = @[(id)ZFMagenta.CGColor, (id)ZFWhite.CGColor];
//    gradientAttribute.locations = @[@(0.0), @(0.9)];
//
//    return [NSArray arrayWithObjects:gradientAttribute, nil];
//}


- (void)horizontalBarChart:(ZFHorizontalBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex horizontalBar:(ZFHorizontalBar *)horizontalBar popoverLabel:(ZFPopoverLabel *)popoverLabel{
    //特殊说明，因传入数据是3个subArray(代表3个类型)，每个subArray存的是6个元素(代表每个类型存了1~6年级的数据),所以这里的groupIndex是第几个subArray(类型)
    //eg：三年级第0个元素为 groupIndex为0，barIndex为2
    NSLog(@"第%ld个颜色中的第%ld个",(long)groupIndex,(long)barIndex);
    
    //可在此处进行bar被点击后的自身部分属性设置
    //    horizontalBar.barColor = ZFYellow;
    //    horizontalBar.isAnimated = YES;
    //    horizontalBar.opacity = 0.5;
    //    [horizontalBar strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}

- (void)horizontalBarChart:(ZFHorizontalBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
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
