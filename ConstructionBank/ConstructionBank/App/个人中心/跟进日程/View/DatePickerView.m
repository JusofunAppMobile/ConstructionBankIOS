//
//  DatePickerView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/20.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "DatePickerView.h"
#import "ZJPickerViewMacro.h"

@interface DatePickerView ()
/** 限制最小日期 */
@property (nonatomic, strong) NSDate *minLimitDate;
/** 限制最大日期 */
@property (nonatomic, strong) NSDate *maxLimitDate;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic ,copy) NSString *title;
/** 选中后的回调 */
@property (nonatomic, copy) ZJDateResultBlock resultBlock;
/** 取消选择的回调 */
@property (nonatomic, copy) ZJDateCancelBlock cancelBlock;

/** 当前选择的日期 */
@property (nonatomic, strong) NSDate *selectDate;

@property (nonatomic ,strong) NSDateFormatter *dateFormatter;

@end
@implementation DatePickerView

+ (void)showDatePickerWithTitle:(NSString *)title
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                       resultBlock:(ZJDateResultBlock)resultBlock
                       cancelBlock:(ZJDateCancelBlock)cancelBlock{
    
    DatePickerView *datePickerView = [[DatePickerView alloc]initWithWithTitle:title minDate:minDate maxDate:maxDate defaultValue:[NSDate date] resultBlock:resultBlock cancelBlock:cancelBlock];
    [datePickerView showPickerViewWithAnimation:YES];
}
+ (void)showDatePickerWithTitle:(NSString *)title
                        minDate:( NSDate * _Nullable )minDate
                        maxDate:( NSDate * _Nullable )maxDate
                   defaultValue:(NSString *)defaultValue
                    resultBlock:(ZJDateResultBlock)resultBlock
                    cancelBlock:(ZJDateCancelBlock)cancelBlock
{
    NSDate *date;
    if (defaultValue && defaultValue.length > 0) {
        
         date = [self getDate:defaultValue format:@"yyyy-MM-dd"];
    }else {
        // 不设置默认日期，就默认选中今天的日期
        date = [NSDate date];
    }
    DatePickerView *datePickerView = [[DatePickerView alloc]initWithWithTitle:title minDate:minDate maxDate:maxDate defaultValue:date resultBlock:resultBlock cancelBlock:cancelBlock];
    [datePickerView showPickerViewWithAnimation:YES];
}

- (instancetype)initWithWithTitle:(NSString *)title
                  minDate:(NSDate *)minDate
                  maxDate:(NSDate *)maxDate
             defaultValue:(NSDate *)defaultValue
              resultBlock:(ZJDateResultBlock)resultBlock
              cancelBlock:(ZJDateCancelBlock)cancelBlock{
    if (self = [super init]) {
        _maxLimitDate = maxDate;
        _minLimitDate = minDate;
        _title = title;
        _resultBlock = resultBlock;
        _cancelBlock = cancelBlock;
        self.selectDate = defaultValue;
        [self initWithAllView];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initWithAllView {
    [super initWithAllView];
    self.titleLab.text = _title;
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
}


#pragma mark - lazy load
- (UIDatePicker *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kZJTopViewHeight + 0.5, self.alertView.frame.size.width, kZJPickerHeight)];
        _pickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        [_pickerView setDate:self.selectDate animated:YES];
    }
    return _pickerView;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

#pragma mark - 背景视图的点击事件
- (void)backViewTapAction:(UITapGestureRecognizer *)sender {
    [self dismissPickerViewWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 右边按钮点击事件
-(void)rightBtnClickAction:(UIButton *)sender{
    // 点击确定按钮后，执行block回调
    [self dismissPickerViewWithAnimation:YES];
    if (self.resultBlock) {
        NSString *str = [self.dateFormatter stringFromDate:_pickerView.date];
        _resultBlock(str);
    }
}

#pragma mark - 左边按钮点击事件
-(void)leftBtnClickAction:(UIButton *)sender{
    [self dismissPickerViewWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 弹出窗口
-(void)showPickerViewWithAnimation:(BOOL)animation{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in keyWindow.subviews) {
        if ([view isKindOfClass:[DatePickerView class]]) {
            [view removeFromSuperview];
        }
    }
    [keyWindow addSubview:self];

    if (animation) {
        CGRect rect = self.alertView.frame;
        rect.origin.y = ScreenHeight;
        self.alertView.frame = rect;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kZJPickerHeight + kZJTopViewHeight +ZJ_BOTTOM_MARGIN;
            self.alertView.frame = rect;
        }];
    }
}
#pragma mark - 关闭视图方法
- (void)dismissPickerViewWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kZJPickerHeight + kZJTopViewHeight + ZJ_BOTTOM_MARGIN;
        self.alertView.frame = rect;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 日期和字符串之间的转换：NSString --> NSDate
+ (NSDate *)getDate:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = format;
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}


@end
