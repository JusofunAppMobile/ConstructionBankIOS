//
//  GFCalendarView.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFCalendarView.h"
#import "NSDate+GFCalendar.h"
#import "NSDate+Tool.h"

@interface GFCalendarView()

//@property (nonatomic, strong) UIButton *calendarHeaderButton;
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *weekHeaderView;
@end

#define kCalendarBasicColor AppHTMLColor(@"4bccbc")

@implementation GFCalendarView


#pragma mark - Initialization

- (instancetype)initWithFrameOrigin:(CGPoint)origin width:(CGFloat)width{
    
    // 根据宽度计算 calender 主体部分的高度
    CGFloat weekLineHight = 0.85 * (width / 7.0);
    CGFloat monthHeight = 6 * MIN(42, weekLineHight);
    
    // 星期头部栏高度
    CGFloat weekHeaderHeight = 0.6 * weekLineHight;
    
    // calendar 头部栏高度
    CGFloat calendarHeaderHeight = 50;
    
    // 最后得到整个 calender 控件的高度
    _calendarHeight = calendarHeaderHeight + weekHeaderHeight + monthHeight;
    
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, _calendarHeight)]) {
        
        _weekHeaderView = [self setupWeekHeadViewWithFrame:CGRectMake(0.0, 50, width, weekHeaderHeight)];
        _calendarScrollView = [self setupCalendarScrollViewWithFrame:CGRectMake(0.0, _weekHeaderView.maxY, width, monthHeight)];
        
        [self addSubview:[self setupHeaderView]];
        [self addSubview:_weekHeaderView];
        [self addSubview:_calendarScrollView];
        
        // 注册 Notification 监听
        [self addNotificationObserver];
        
    }
    
    return self;
    
}


- (UIView *)setupHeaderView{

    UIView *barView = [[UIView alloc]initWithFrame:KFrame(0, 0, self.width, 50)];
    barView.backgroundColor = [UIColor whiteColor];
    
    UIButton *yearBtnL = [UIButton  new];
    [yearBtnL setImage:KImageName(@"日期左") forState:UIControlStateNormal];
    [yearBtnL setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [yearBtnL addTarget:self action:@selector(preYearAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:yearBtnL];
    [yearBtnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(barView);
        make.left.mas_equalTo(barView).offset(20);
    }];
    
    UIButton *yearBtnR = [UIButton  new];
    [yearBtnR setImage:KImageName(@"日期右") forState:UIControlStateNormal];
    [yearBtnR setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [yearBtnR addTarget:self action:@selector(nextYearAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:yearBtnR];
    [yearBtnR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(barView);
        make.right.mas_equalTo(barView).offset(-20);
    }];
    
    self.titleLab = ({
        UILabel *titleLab = [UILabel new];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor darkGrayColor];
        [barView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(barView);
        }];
        titleLab.font = KFont(16);
        titleLab;
    });
    
    UIButton *monthBtnL = [UIButton new];
    [monthBtnL setImage:KImageName(@"left") forState:UIControlStateNormal];
    [monthBtnL setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [monthBtnL addTarget:self action:@selector(preMonthAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:monthBtnL];
    [monthBtnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(barView);
        make.right.mas_equalTo(_titleLab.mas_left).offset(-30);
        make.width.height.mas_equalTo(25);
    }];
   
    UIButton *monthBtnR = [UIButton new];
    [monthBtnR setImage:KImageName(@"right") forState:UIControlStateNormal];
    [monthBtnR setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [monthBtnR addTarget:self action:@selector(nextMonthAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:monthBtnR];
    [monthBtnR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(barView);
        make.left.mas_equalTo(_titleLab.mas_right).offset(30);
        make.width.height.mas_equalTo(25);
    }];
    
    return barView;
}

- (UIView *)setupWeekHeadViewWithFrame:(CGRect)frame {
    
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width / 7.0;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < 7; ++i) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0.0, width, height)];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[i];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:13.5];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    return view;
}

- (GFCalendarScrollView *)setupCalendarScrollViewWithFrame:(CGRect)frame {
    GFCalendarScrollView *scrollView = [[GFCalendarScrollView alloc] initWithFrame:frame];
    return scrollView;
}

- (void)setDidSelectDayHandler:(DidSelectDayHandler)didSelectDayHandler {
    _didSelectDayHandler = didSelectDayHandler;
    if (_calendarScrollView != nil) {
        _calendarScrollView.didSelectDayHandler = _didSelectDayHandler; // 传递 block
    }
}


#pragma mark -
- (void)preYearAction{
    NSDate *date = [_calendarScrollView.currentMonthDate lastYear];
    _calendarScrollView.currentMonthDate = date;
}

- (void)nextYearAction{
    NSDate *date = [_calendarScrollView.currentMonthDate nextYear];
    _calendarScrollView.currentMonthDate = date;
}

- (void)preMonthAction{
    NSDate *date = [_calendarScrollView.currentMonthDate lastMonth];
    _calendarScrollView.currentMonthDate = date;
}

- (void)nextMonthAction{
    NSDate *date = [_calendarScrollView.currentMonthDate nextMonth];
    _calendarScrollView.currentMonthDate = date;
}

#pragma mark - Actions
- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarHeaderAction:) name:@"ChangeCalendarHeaderNotification" object:nil];
}

- (void)changeCalendarHeaderAction:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    int year = [dic[@"year"] intValue];
    int month = [dic[@"month"] intValue];
    
    NSString *title = [NSString stringWithFormat:@"%d月 %d",month,year];
    _titleLab.text = title;
}

#pragma mark - unit
- (void)setDatelist:(NSArray *)datelist{
    _datelist = datelist;
    _calendarScrollView.datelist = datelist;
}


- (void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
