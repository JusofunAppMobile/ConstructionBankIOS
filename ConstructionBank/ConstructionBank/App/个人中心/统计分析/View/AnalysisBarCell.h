//
//  AnalysisBarCell.h
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFChart.h"
#import "PlaceHolderView.h"
#import "AnalysisBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface AnalysisBarCell : AnalysisBaseCell<ZFGenericChartDataSource, ZFBarChartDelegate>
@property (nonatomic, strong) ZFBarChart * barChart;

@property(nonatomic,strong)NSArray*dataArray;

@property(nonatomic,strong)NSDictionary*dataDic;


@end

NS_ASSUME_NONNULL_END
