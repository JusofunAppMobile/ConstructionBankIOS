//
//  AnalysisHorizontalBarCell.h
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFChart.h"

#import "AnalysisBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface AnalysisHorizontalBarCell : AnalysisBaseCell<ZFGenericChartDataSource, ZFHorizontalBarChartDelegate>
@property (nonatomic, strong) ZFHorizontalBarChart * barChart;
@property(nonatomic,strong)NSDictionary*dataDic;


@end

NS_ASSUME_NONNULL_END
