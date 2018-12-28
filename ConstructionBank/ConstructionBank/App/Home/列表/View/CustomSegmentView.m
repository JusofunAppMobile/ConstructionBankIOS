//
//  CustomSegmentView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/27.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CustomSegmentView.h"
#import "UIView+GradientColor.h"

#define BASE_TAG 1234

@interface CustomSegmentView ()
@property (nonatomic ,strong) NSArray *titleArray;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) NSMutableArray *btnArr;
@end

@implementation CustomSegmentView


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)titleArr delegate:(id<CustomSegmentDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _delegate = delegate;//需要在此处结束delegate，这样init里的按钮时间才能被delegate相应
        _titleArray = titleArr;
        [self initSegmentButtons];
    }
    return self;
}

- (void)initSegmentButtons{
    if (!_titleArray.count) return;
    
    [self.btnArr removeAllObjects];
    
    CGFloat width = self.width/_titleArray.count;
    
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *view = [[UIButton alloc]initWithFrame:KFrame(width*i, 0, width, self.height-2)];
        view.tag = BASE_TAG+i;
        view.titleLabel.font = KFont(14);
        [view setTitle:_titleArray[i] forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0x333333) forState:UIControlStateSelected];
        [view addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:view];
        
        [self.btnArr addObject:view];
    }
    
    [self layoutIfNeeded];//不加此处，titlelabel 的frame为0
    CGRect frame = [self getTitleFrameAtIndex:0];
    
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:KFrame(0, self.height-1, self.width, 1)];
    bottomLine.backgroundColor = KHexRGB(0xf2f2f2);
    [self addSubview:bottomLine];
    
    self.lineView = [[UIView alloc]initWithFrame:KFrame(frame.origin.x, self.height-2, frame.size.width, 2)];
    [_lineView setGradientColor:@[(__bridge id)RGBHex(@"#FC8E32").CGColor,(__bridge id)RGBHex(@"#FFB22C").CGColor] locations:@[@0.5,@1.0]];
    [self addSubview:_lineView];
    [self segmentAction:_btnArr[0]];
    
}

#pragma mark - button action
- (void)segmentAction:(UIButton *)sender{
    [self changeButtonState:sender];
    [self startLineAnimation:sender.tag - BASE_TAG];
    if ([self.delegate respondsToSelector:@selector(segmentDidSelectIndex:)]) {
        [self.delegate segmentDidSelectIndex:sender.tag - BASE_TAG];
    }
}

- (void)changeButtonState:(UIButton *)sender{
    for (UIButton *button in _btnArr) {
        if ([button isEqual:sender]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        button.titleLabel.font = button.selected?KFont(16):KFont(14);
        [button.titleLabel sizeToFit];
    }
}

- (void)startLineAnimation:(NSInteger)index{
    CGRect frame = [self getTitleFrameAtIndex:index];
    [UIView animateWithDuration:.3 animations:^{
        _lineView.frame =KFrame(frame.origin.x, self.height-2, frame.size.width, 2);//test无法改变宽度
    }];
}

- (CGRect)getTitleFrameAtIndex:(NSInteger)index{
    
    UIButton *button = self.btnArr[index];
    CGRect frame = [self convertRect:button.titleLabel.frame  fromView:button];
    return frame;
}

#pragma mark - lazy load
- (NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

@end
