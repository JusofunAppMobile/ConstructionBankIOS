//
//  CustomSegmentView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CustomSegmentView.h"

#define BASE_TAG 1234

@interface CustomSegmentView ()
@property (nonatomic ,strong) NSArray *titleArray;
@property (nonatomic ,strong) UIView *lineView;
@end

@implementation CustomSegmentView


- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArr{
    if (self = [super initWithFrame:frame]) {
        _titleArray = titleArr;
        [self initSegmentButtons];
    }
    return self;
}

- (void)initSegmentButtons{
    if (!_titleArray.count) return;
    
    CGFloat width = self.width/_titleArray.count;
    
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *view = [[UIButton alloc]initWithFrame:KFrame(width*i, 0, width, self.height-2)];
        view.tag = BASE_TAG+i;
        view.titleLabel.font = KFont(15);
        [view setTitle:_titleArray[i] forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:view];
    }
    
    self.lineView = [[UIView alloc]initWithFrame:KFrame(0, self.height-2, width, 2)];
    _lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineView];
    
}

#pragma mark - button action
- (void)segmentAction:(UIButton *)sender{
    [self startLineAnimation:sender.tag - BASE_TAG];
    if ([self.delegate respondsToSelector:@selector(segmentDidSelectIndex:)]) {
        [self.delegate segmentDidSelectIndex:sender.tag - BASE_TAG];
    }
}

- (void)startLineAnimation:(NSInteger)index{
    CGFloat width = self.width/_titleArray.count;
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = _lineView.frame;
        rect.origin.x = width*index;
        _lineView.frame = rect;
    }];
}

@end
