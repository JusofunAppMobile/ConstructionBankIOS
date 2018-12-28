//
//  AnalysisPieCell.h
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderView.h"
#import "AnalysisBaseCell.h"
#import "YTLPieView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AnalysisPieCell : AnalysisBaseCell
@property (nonatomic, strong) YTLPieView * pieChart;
@property(nonatomic,strong)NSDictionary*dataDic;

@end

NS_ASSUME_NONNULL_END
