//
//  RiskSegmentView.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "RiskSegmentView.h"
#import "TabListModel.h"

@interface RiskSegmentView ()

@property (nonatomic ,strong) NSMutableDictionary *btnDic;

@property (nonatomic ,strong) UIScrollView *titleScrollView;

@property (nonatomic ,strong) UIButton *selectedBtn;

@end

@implementation RiskSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews{

    [self addBorderLine:self.height-.5];
}


- (void)setTabList:(NSArray *)tabList{
    if (![tabList count]) {
        return;
    }
    _tabList = tabList;
    [self reset];
    [self initView];
}

- (void)initView{
    
    CGFloat x = 0;

    for (int i = 0; i<[_tabList count]; i++) {
        
        UIButton *view = self.btnDic[@(i)];
        if (view == nil) {
            view = [self createButtonWithIndex:i];
        }
        
        TabListModel *model = _tabList[i];
        [view setTitle:model.title forState:UIControlStateNormal];
        
        CGFloat width = [self getButtonWidthWithTitle:model.title];
        [view setFrame:KFrame(x, 0, width, 40)];
        x +=width;
        
        [self.titleScrollView addSubview:view];
        [_btnDic setObject:view forKey:@(i)];
    }
    [self segmentAction:_btnDic[@0]];
    self.titleScrollView.contentSize = CGSizeMake(x, 40);
}

- (UIButton *)createButtonWithIndex:(NSInteger)index{

    UIButton *button       = [UIButton new];
    button.tag             = index;
    button.titleLabel.font = KFont(16);
    [button setTitleColor:KHexRGB(0xff6500) forState:UIControlStateSelected];
    [button setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 按钮宽度
- (CGFloat)getButtonWidthWithTitle:(NSString *)title{

    
    CGFloat aWidth = KDeviceW/_tabList.count;//占满一屏需要的宽
    
    CGFloat minWidth = 375.f/4;
    
    CGFloat titleWidth = [self widthForText:title fontSize:16];//显示字体需要的宽度
    
    titleWidth = titleWidth < minWidth ? minWidth : titleWidth;
    
    if (_tabList.count == 1) {
        return titleWidth;
    }else{
        return MAX(aWidth, titleWidth);//防止titleWidth占不满屏幕
    }
}

- (CGFloat)widthForText:(NSString *)text fontSize:(CGFloat)font{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil]];
    return ceilf(size.width);
}

#pragma mark - 点击按钮
- (void)segmentAction:(UIButton *)sender{
    
    if ([_selectedBtn isEqual:sender]) {
        return;
    }
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    _selectedBtn.selected = YES;
    
    if ([_delegate respondsToSelector:@selector(didSelectBarAtIndex:)]) {
        [_delegate didSelectBarAtIndex:sender.tag];
    }
}

- (void)reset{
    _selectedBtn.selected = NO;
    _selectedBtn = nil;
}

#pragma mark - 底部添加分割线
- (void)addBorderLine:(CGFloat)y{
    
    CALayer *layer = [CALayer new];
    layer.frame = KFrame(0, y, self.width, .5);
    layer.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00].CGColor;;
    [self.layer addSublayer:layer];
}

#pragma mark - lazy load
- (NSMutableDictionary *)btnDic{//重用
    if (!_btnDic) {
        _btnDic = [NSMutableDictionary dictionary];
    }
    return _btnDic;
}

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_titleScrollView];
    }
    return _titleScrollView;
}


@end
