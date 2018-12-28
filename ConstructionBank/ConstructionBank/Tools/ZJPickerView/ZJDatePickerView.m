//
//  ZJDatePickerView.m
//  ZJKitTool
//
//  Created by 邓志坚 on 2018/7/4.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//
/**
 *  ZJKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下,给个Star。😆
 */

#import "ZJDatePickerView.h"
#import "NSDate+ZJPickerView.h"
#import "ZJPickerViewMacro.h"


@interface ZJDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    // 记录 年、月、日、时、分 当前选择的位置
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _noonIndex;
    NSInteger _hourIndex;
    NSInteger _minIndex;
    
    NSString *_title;
    UIDatePickerMode _datePickerMode;
    BOOL _isAutoSelect;      // 是否开启自动选择
}
/** 时间选择器2 */
@property (nonatomic, strong) UIPickerView *pickerView;
/// 日期存储数组
@property(nonatomic, strong) NSArray *yearArr;
@property(nonatomic, strong) NSArray *monthArr;
@property(nonatomic, strong) NSArray *dayArr;
@property(nonatomic ,strong) NSArray *noonArr;
@property(nonatomic, strong) NSArray *hourArr;
@property(nonatomic, strong) NSArray *minArr;
@property(nonatomic, assign) ZJDatePickerModel dateModel;
@property (nonatomic,strong) UIFont *labelFont;


/** 限制最小日期 */
@property (nonatomic, strong) NSDate *minLimitDate;
/** 限制最大日期 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/** 当前选择的日期 */
@property (nonatomic, strong) NSDate *selectDate;
/** 选择的日期的格式 */
@property (nonatomic, strong) NSString *selectDateFormatter;
// 行高
@property (nonatomic, assign) CGFloat  rowHeight;
/** 选中后的回调 */
@property (nonatomic, copy) ZJDateResultBlock resultBlock;
/** 取消选择的回调 */
@property (nonatomic, copy) ZJDateCancelBlock cancelBlock;
/** 存取选中行 */
@property (nonatomic,strong) NSMutableDictionary *selectedRowCache;
@end

@implementation ZJDatePickerView



#pragma mark - 3.显示时间选择器（支持 设置自动选择、最大值、最小值、取消选择的回调）
+ (void)zj_showDatePickerWithTitle:(NSString *)title
                         dateModel:(ZJDatePickerModel)model
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                       resultBlock:(ZJDateResultBlock)resultBlock
                       cancelBlock:(ZJDateCancelBlock)cancelBlock{
    
    
    ZJDatePickerView *datePickerView = [[ZJDatePickerView alloc] initWithTitle:title
                                                                     dateModel:model
                                                               defaultSelValue:defaultSelValue
                                                                       minDate:minDate
                                                                       maxDate:maxDate
                                                                  isAutoSelect:isAutoSelect
                                                                   resultBlock:resultBlock
                                                                   cancelBlock:cancelBlock];
    [datePickerView showPickerViewWithAnimation:YES];
    
}


#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title
                    dateModel:(ZJDatePickerModel)model
              defaultSelValue:(NSString *)defaultSelValue
                      minDate:(NSDate *)minDate
                      maxDate:(NSDate *)maxDate
                 isAutoSelect:(BOOL)isAutoSelect
                  resultBlock:(ZJDateResultBlock)resultBlock
                  cancelBlock:(ZJDateCancelBlock)cancelBlock{
    
    if (self = [super init]) {
        _dateModel                  = model;
        _title                      = title;
        _isAutoSelect               = isAutoSelect;
        _resultBlock                = resultBlock;
        _cancelBlock                = cancelBlock;
        self.rowHeight              =  35.0f;
        // 配置按钮的文本颜色
       
        [self setupSelectDateFormatter];
        // 设置最小值限制
        if (minDate) {
            self.minLimitDate   = minDate;
        }else{
          self.minLimitDate = [NSDate zj_setYear:1970 ]; // 遥远的过去的一个时间点
        }
        
        // 最大值限制
        if (maxDate) {
            self.maxLimitDate = maxDate;
        }else{
            self.maxLimitDate = [NSDate zj_setYear:[NSDate date].zj_year+1 ]; // 遥远的未来的一个时间点
        }
        
        BOOL minMOreThanMax = [self.minLimitDate zj_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
        
        NSAssert(!minMOreThanMax, @"最小日期不能大于最大日期!");
        
        if (minMOreThanMax) {
            // 如果最小日期大于了最大日期，就忽略两个值
            self.minLimitDate = [NSDate distantPast];
            self.maxLimitDate = [NSDate distantFuture];
        }
        
        
        // 默认选中的日期
        
        if (defaultSelValue && defaultSelValue.length > 0) {
            
            NSDate *defaultSelDate  = [NSDate zj_getDate:defaultSelValue format:self.selectDateFormatter];
            if (!defaultSelDate) {
                NSLog(@"参数格式错误！参数 defaultSelValue 的正确格式是：%@", self.selectDateFormatter);
                NSAssert(defaultSelDate, @"参数格式错误！请检查形参 defaultSelValue 的格式");
                defaultSelDate = [NSDate date]; // 默认值参数格式错误时，重置/忽略默认值，防止在 Release 环境下崩溃！
            }
            self.selectDate = defaultSelDate;
        }else {
            // 不设置默认日期，就默认选中今天的日期
            self.selectDate = [NSDate date];
        }
        
        BOOL selectLessThanMin = [self.selectDate zj_compare:self.minLimitDate format:self.selectDateFormatter] == NSOrderedAscending;
        BOOL selectMoreThanMax = [self.selectDate zj_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
        NSAssert(!selectLessThanMin, @"默认选择的日期不能小于最小日期！");
        NSAssert(!selectMoreThanMax, @"默认选择的日期不能大于最大日期！");
        if (selectLessThanMin) {
            self.selectDate = self.minLimitDate;
        }
        if (selectMoreThanMax) {
            self.selectDate = self.maxLimitDate;
        }
        
#ifdef DEBUG
//        NSLog(@"最小时间date：%@", self.minLimitDate);
//        NSLog(@"默认时间date：%@", self.selectDate);
//        NSLog(@"最大时间date：%@", self.maxLimitDate);
//        
//        NSLog(@"最小时间：%@", [NSDate zj_getDateString:self.minLimitDate format:self.selectDateFormatter]);
//        NSLog(@"默认时间：%@", [NSDate zj_getDateString:self.selectDate format:self.selectDateFormatter]);
//        NSLog(@"最大时间：%@", [NSDate zj_getDateString:self.maxLimitDate format:self.selectDateFormatter]);
#endif
        
        self.labelFont = [UIFont systemFontOfSize:(_dateModel == ZJDatePickerModelTime?18:20)];

        [self initDefaultDateArray];

        [self initWithAllView];
        
        // 默认滚动的行
        [self scrollToSelectDate:self.selectDate animated:NO];
    }
    return self;
}

- (void)setupSelectDateFormatter{
    self.selectDateFormatter = @"yyyy-MM-dd";
}

#pragma mark - 初始化子视图
- (void)initWithAllView {
    [super initWithAllView];
    self.titleLab.text = _title;
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];

}


#pragma mark - 设置日期数据源数组
- (void)initDefaultDateArray {
    // 1. 设置 yearArr 数组
    [self setupYearArr];
    // 2.设置 monthArr 数组
    [self setupMonthArr:self.selectDate.zj_year];
    // 3.设置 dayArr 数组
    [self setupDayArr:self.selectDate.zj_year month:self.selectDate.zj_month];
    //设置上午下午
    if (_dateModel == ZJDatePickerModelNoon) {
        [self setupNoonArr];
    }
    //设置时间
    if (_dateModel == ZJDatePickerModelTime){
        [self setupHourArr];
        [self setupMinArr];
    }
    
    // 根据 默认选择的日期 计算出 对应的索引
    _yearIndex = self.selectDate.zj_year - self.minLimitDate.zj_year;
    _monthIndex = self.selectDate.zj_month - ((_yearIndex == 0) ? self.minLimitDate.zj_month : 1);
    _dayIndex = self.selectDate.zj_day - ((_yearIndex == 0 && _monthIndex == 0) ? self.minLimitDate.zj_day : 1);
    _noonIndex = 0;
    _hourIndex = 0;
    _minIndex = 0;
    
}
#pragma mark - 滚动到指定的时间位置
- (void)scrollToSelectDate:(NSDate *)selectDate animated:(BOOL)animated {//test 滚动设置一下时分
    // 根据 当前选择的日期 计算出 对应的索引
    NSInteger yearIndex = selectDate.zj_year - self.minLimitDate.zj_year;
    NSInteger monthIndex = selectDate.zj_month - ((yearIndex == 0) ? self.minLimitDate.zj_month : 1);
    NSInteger dayIndex = selectDate.zj_day - ((yearIndex == 0 && monthIndex == 0) ? self.minLimitDate.zj_day : 1);
//    NSInteger noonIndex  = selectDate.zj_hour<12?0:1;

    NSMutableArray *indexArr = [NSMutableArray arrayWithObjects:@(yearIndex), @(monthIndex), @(dayIndex), nil];
    if (_dateModel == ZJDatePickerModelNoon) {
        NSInteger noonIndex = 0;
        [indexArr addObject:@(noonIndex)];
    }
    if (_dateModel == ZJDatePickerModelTime) {
        NSInteger hourIndex = 0;
        NSInteger minIndex = 0;
        [indexArr addObject:@(hourIndex)];
        [indexArr addObject:@(minIndex)];
    }
    
    for (NSInteger i = 0; i < indexArr.count; i++) {
        [self.pickerView selectRow:[indexArr[i] integerValue] inComponent:i animated:animated];
        //保存选中的行
        [self.selectedRowCache setObject:@([indexArr[i] integerValue]) forKey:@(i)];
    }
}
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
// pickerView 有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_dateModel == ZJDatePickerModelNoon) {
        return 4;
    }
    if (_dateModel == ZJDatePickerModelTime) {
        return 5;
    }
    return 3;
}

// pickerView 表盘上有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSMutableArray * rowsArr = [NSMutableArray arrayWithObjects:@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), nil];
    if (_dateModel == ZJDatePickerModelNoon) {
        [rowsArr addObject:@(self.noonArr.count)];
    }
    if (_dateModel == ZJDatePickerModelTime){
        [rowsArr addObject:@(self.hourArr.count)];
        [rowsArr addObject:@(self.minArr.count)];
    }
    return [rowsArr[component] integerValue];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.labelFont;
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    
    [self setDateLabelText:label component:component row:row];
    
    return label;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.rowHeight * kScaleFit;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat fontSize = self.labelFont.pointSize;
    
    CGFloat year = 50*fontSize/14;
    CGFloat month = 35*fontSize/14;
    CGFloat hour = 40*fontSize/14;
    CGFloat minute = 40*fontSize/14;
    CGFloat timeType = 30*fontSize/14;
    
    CGFloat day =  80*fontSize/14;
    
    if (_dateModel == ZJDatePickerModelDay) {
        day =  60*fontSize/14;
    }
    if (_dateModel == ZJDatePickerModelNoon) {
        day =  70*fontSize/14;
    }
    if (_dateModel == ZJDatePickerModelTime) {
        day =  80*fontSize/14;
    }
    
    if (_dateModel == ZJDatePickerModelDay) {
        if (component == 0) return year;
        if (component == 1) return month;
        if (component == 2) return day;
    }
    if (_dateModel == ZJDatePickerModelNoon) {
        if (component == 0) return year;
        if (component == 1) return month;
        if (component == 2) return day;
        if (component == 3) return timeType;
    }
    
    if (_dateModel == ZJDatePickerModelTime) {
        if (component == 0) return year;
        if (component == 1) return month;
        if (component == 2) return day;
        if (component == 3) return hour;
        if (component == 3) return minute;
    }
    
    return 45;
}

#pragma mark - 配置背景色
- (void)setUpPickerView:(UIPickerView *)pickerView customSelectedBGRowColor:(UIColor *)color
{
    NSArray *subviews = pickerView.subviews;
    if (!(subviews.count > 0)) {
        return;
    }
    if (!color) {
        return;
    }
    NSArray *coloms = subviews.firstObject;
    if (coloms) {
        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
        if (subviewCache.count > 0) {
            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
            if (middleContainerView) {
                middleContainerView.backgroundColor = color;
            }
        }
    }
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //保存选中的行
    [self.selectedRowCache setObject:@(row) forKey:@(component)];
    
    [self.pickerView reloadComponent:component];
    
    // 获取滚动后选择的日期
    self.selectDate = [self getDidSelectedDate:component row:row];
    
//    NSString * noonStr = _noonArr[_noonIndex];
    // 设置是否开启自动回调
//    if (self.resultBlock) {
//        NSString *selectDateValue = [NSDate zj_getDateString:self.selectDate format:self.selectDateFormatter];
//        if (noonStr.length) {
//            selectDateValue = [NSString stringWithFormat:@"%@  %@",selectDateValue,noonStr];
//        }
//        self.resultBlock(selectDateValue);
//    }
    
}

#pragma mark - 设置pickerView 每一行的文字显示
- (void)setDateLabelText:(UILabel *)label component:(NSInteger)component row:(NSInteger)row {
    if (component == 0) {
        label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
    } else if (component == 1) {
        label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
    } else if (component == 2) {
        label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
    }else{
        if (_dateModel == ZJDatePickerModelNoon) {
            label.text = [NSString stringWithFormat:@"%@", self.noonArr[row]];
        }else{
            if (component == 3) {
                label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
            }else{
                label.text = [NSString stringWithFormat:@"%@分", self.minArr[row]];
            }
        }
    }
}

- (NSDate *)getDidSelectedDate:(NSInteger)component row:(NSInteger)row {
    
    NSString *selectDateValue = nil;
    if (component == 0) {
        _yearIndex = row;
        [self updateDateArray];
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
        if (_dateModel == ZJDatePickerModelNoon) {
            [self.pickerView reloadComponent:3];
        }
        if (_dateModel == ZJDatePickerModelTime){
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        }
    } else if (component == 1) {
        _monthIndex = row;
        [self updateDateArray];
        [self.pickerView reloadComponent:2];
        if (_dateModel == ZJDatePickerModelNoon) {
            [self.pickerView reloadComponent:3];
        }
        if (_dateModel == ZJDatePickerModelTime){
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        }
    } else if (component == 2) {
        _dayIndex = row;
        if (_dateModel == ZJDatePickerModelNoon) {
            [self.pickerView reloadComponent:3];
        }
        if (_dateModel == ZJDatePickerModelTime){
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        }

    }else{
        if (_dateModel == ZJDatePickerModelNoon) {
            _noonIndex = row;
        }else{
            if (component == 3) {
                _hourIndex = row;
            }else{
                _minIndex = row;
            }
        }
    }
    selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue]];
    return [NSDate zj_getDate:selectDateValue format:self.selectDateFormatter];//test修改format
}


#pragma mark - 更新日期数据源数组
- (void)updateDateArray {//test是否需要更新
    NSInteger year = [self.yearArr[_yearIndex] integerValue];
    // 1.设置 monthArr 数组
    [self setupMonthArr:year];
    // 更新索引：防止更新 monthArr 后数组越界
    _monthIndex = (_monthIndex > self.monthArr.count - 1) ? (self.monthArr.count - 1) : _monthIndex;
    
    NSInteger month = [self.monthArr[_monthIndex] integerValue];
    // 2.设置 dayArr 数组
    [self setupDayArr:year month:month];
    // 更新索引：防止更新 dayArr 后数组越界
    _dayIndex = (_dayIndex > self.dayArr.count - 1) ? (self.dayArr.count - 1) : _dayIndex;
    
//    _noonIndex = 0;
}

// 设置 yearArr 数组
- (void)setupYearArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = self.minLimitDate.zj_year; i <= self.maxLimitDate.zj_year; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.yearArr = [tempArr copy];
}


// 设置 monthArr 数组
- (void)setupMonthArr:(NSInteger)year {
    NSInteger startMonth = 1;
    NSInteger endMonth = 12;
    if (year == self.minLimitDate.zj_year) {
        startMonth = self.minLimitDate.zj_month;
    }
    if (year == self.maxLimitDate.zj_year) {
        endMonth = self.maxLimitDate.zj_month;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMonth - startMonth + 1)];
    for (NSInteger i = startMonth; i <= endMonth; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.monthArr = [tempArr copy];
}

// 设置 dayArr 数组
- (void)setupDayArr:(NSInteger)year month:(NSInteger)month {
    NSInteger startDay = 1;
    NSInteger endDay = [NSDate zj_getDaysInYear:year month:month];
    if (year == self.minLimitDate.zj_year && month == self.minLimitDate.zj_month) {
        startDay = self.minLimitDate.zj_day;
    }
    if (year == self.maxLimitDate.zj_year && month == self.maxLimitDate.zj_month) {
        endDay = self.maxLimitDate.zj_day;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = startDay; i <= endDay; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"%zi",i]];
    }
    self.dayArr = [tempArr copy];
}

- (void)setupNoonArr{
    self.noonArr = @[@"上午",@"下午"];
}

- (void)setupHourArr{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i< 24; i++) {
        [tempArr addObject: [NSString stringWithFormat:@"%d",i]];
    }
    self.hourArr = tempArr;
}

- (void)setupMinArr{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i< 60; i++) {
        [tempArr addObject: [NSString stringWithFormat:@"%d",i]];
    }
    self.minArr = tempArr;
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
    
    NSString *noonStr = _noonArr[_noonIndex];
    if (self.resultBlock) {
        NSString *selectDateValue = [NSDate zj_getDateString:self.selectDate format:self.selectDateFormatter];
        if (_dateModel == ZJDatePickerModelNoon&&noonStr.length) {
            selectDateValue = [NSString stringWithFormat:@"%@  %@",selectDateValue,noonStr];
        }
        if (_dateModel == ZJDatePickerModelTime) {
            NSString *hour = _hourArr[_hourIndex];
            NSString *min = _minArr[_minIndex];
            selectDateValue = [NSString stringWithFormat:@"%@ %02d:%02d",selectDateValue,[hour intValue],[min intValue]];
        }
        self.resultBlock(selectDateValue);
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

#pragma mark - Getter && Setter

#pragma mark - 时间选择器  自定义 pickerView
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kZJTopViewHeight + 0.5, self.alertView.frame.size.width, kZJPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

-(NSMutableDictionary *)selectedRowCache{
    if (!_selectedRowCache) {
        _selectedRowCache =[NSMutableDictionary dictionary];
    }
    return _selectedRowCache;
}
- (NSArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSArray array];
    }
    return _yearArr;
}

- (NSArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSArray array];
    }
    return _monthArr;
}

- (NSArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSArray array];
    }
    return _dayArr;
}

- (NSArray *)noonArr{
    if (!_noonArr) {
        _noonArr = @[@"上午",@"下午"];
    }
    return _noonArr;
}

- (NSArray *)hourArr{
    if (!_hourArr) {
        _hourArr = [NSArray array];
    }
    return _hourArr;
}

- (NSArray *)minArr{
    if (!_minArr) {
        _minArr = [NSArray array];
    }
    return _minArr;
}


@end
