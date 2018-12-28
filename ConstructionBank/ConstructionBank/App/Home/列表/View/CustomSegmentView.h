//
//  CustomSegmentView.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomSegmentDelegate <NSObject>

- (void)segmentDidSelectIndex:(NSInteger)index;

@end


@interface CustomSegmentView : UIView

@property (nonatomic ,weak) id <CustomSegmentDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)titleArr delegate:(id<CustomSegmentDelegate>)delegate;

@end
