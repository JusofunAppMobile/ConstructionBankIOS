//
//  CustomPickerView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CustomPickerView.h"
#define MainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]

#define Picker_H 216.f
#define Bar_H 44.f

@interface CustomPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,strong) UIView       *backView;

@property (strong, nonatomic) UIButton     *cancelBtn;

@property (strong, nonatomic) UIButton     *confirmBtn;


@property (strong, nonatomic) UIView       *darkView;

@property (strong, nonatomic) UIBezierPath *bezierPath;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@property (strong, nonatomic) UIPickerView *pickerView;

@property (nonatomic ,strong) NSArray *datalist;

@property (nonatomic ,copy) ResultBlock resultBlock;

@property (nonatomic ,strong) UIView *lineView;


@property (nonatomic,copy) NSString* keyName;

@end

@implementation CustomPickerView


- (instancetype)initWithTitles:(NSArray *)titleArr resultBlock:(ResultBlock)resultBlock{
    if (self = [super init]) {
        self.datalist = titleArr;
        self.resultBlock = resultBlock;
        [self initView];
    }
    return self;
}

- (instancetype)initWithDicArray:(NSArray *)dicArray keyName:(NSString*)keyName resultBlock:(ResultBlock)resultBlock
{
    if (self = [super init]) {
        if(keyName.length == 0){
            self.datalist = [NSMutableArray array];
        }else{
            self.datalist = dicArray;
        }
        _keyName = keyName;
        _resultBlock = resultBlock;
        [self initView];
    }
    return self;
}

- (void)initView{
    
    self.frame = CGRectMake(0, 0, KDeviceW, KDeviceH);
    
    [self addSubview:self.darkView];
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.confirmBtn];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.pickerView];
    
//    [self bezierPath];
//    [self shapeLayer];
    
}

- (void)setDatalist:(NSArray *)datalist{
    _datalist = datalist;
    [_pickerView reloadAllComponents];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _datalist.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KFont(20);
    }
    
    if([_datalist[row] isKindOfClass:[NSString class]]){
        label.text = _datalist[row];
    }else{
        if (self.keyName) {
            id value = [self.datalist[row] valueForKey:self.keyName];
            if ([value isKindOfClass:[NSString class]]) {
                label.text = value;
            } else {
                 label.text = @"";
            }
        }
    }
    return label;
}

#pragma mark 隐藏 显示
- (void)show{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        
        CGPoint point    = _backView.center;
        point.y          -=  Bar_H+Picker_H+.5f;
        _backView.center = point;
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)dismiss{
    [UIView animateWithDuration:.3 animations:^{
        
        CGPoint point    = _backView.center;
        point.y          +=  Bar_H+Picker_H+.5f;
        _backView.center = point;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


- (void)confirmAction{    
    if ([self anySubViewScrolling:_pickerView]) {
        return;
    }
    [self dismiss];
    NSInteger selectRow = [_pickerView selectedRowInComponent:0];
    if(self.keyName&& self.keyName.length >0){
        if (_resultBlock) {
            _resultBlock(_datalist[selectRow]);
        }
    }else{
        NSString * result = _datalist[selectRow];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@(selectRow+1) forKey:@"followState"];
        [dic setObject:result forKey:@"followStateText"];
        if (_resultBlock) {
            _resultBlock(dic);
        }
    }
    
}

- (void)tapAction{
    [self dismiss];
}


- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark lazy load

- (UIView *)darkView {
    if (!_darkView) {
        _darkView                 = [[UIView alloc]init];
        _darkView.frame           = self.frame;
        _darkView.backgroundColor = [UIColor blackColor];
        _darkView.alpha           = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_darkView addGestureRecognizer:tap];
    }
    return _darkView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView                 = [[UIView alloc]init];
        _backView.frame           = CGRectMake(0, KDeviceH, KDeviceW, Bar_H+Picker_H+.5f);
        _backView.backgroundColor = MainBackColor;
        _backView.backgroundColor = [UIColor whiteColor];

    }
    return _backView;
}

//- (UIBezierPath *)bezierPath {
//    if (!_bezierPath) {
//        _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//    }
//    return _bezierPath;
//}
//
//- (CAShapeLayer *)shapeLayer {
//    if (!_shapeLayer) {
//        _shapeLayer          = [[CAShapeLayer alloc] init];
//        _shapeLayer.frame    = _backView.bounds;
//        _shapeLayer.path     = _bezierPath.CGPath;
//        _backView.layer.mask = _shapeLayer;
//    }
//    return _shapeLayer;
//}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView                 = [[UIPickerView alloc]init];
        _pickerView.frame           = CGRectMake(0, Bar_H +.5f, KDeviceW, Picker_H);
        _pickerView.delegate        = self;
        _pickerView.dataSource      = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(0, 0, 60, Bar_H);
        _cancelBtn.titleLabel.font = KFont(15);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:KHexRGB(0x464646) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.frame = CGRectMake(KDeviceW - 60, 0, 60, Bar_H);
        _confirmBtn.titleLabel.font = KFont(15);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:KHexRGB(0x464646) forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, Bar_H, self.width, 0.5)];
        _lineView.backgroundColor = KHexRGB(0xf2f2f2);
    }
    return _lineView;
}




@end
