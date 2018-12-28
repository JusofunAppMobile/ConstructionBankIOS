//
//  TimePickerView.m
//  PollsCloud
//
//  Created by WangZhipeng on 16/11/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "TimePickerView.h"

#define affimeHight 49
#define pickHight 180
@interface TimePickerView()<UUDatePickerDelegate>
{
    UIView *backView;
    UUDatePicker *datePicker;
    UIView *dateBackView;
    
    NSString *dateStr;
}

@end


@implementation TimePickerView



- (instancetype)init
{
    self = [super initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH)];
    if (self) {
        
        [KeyWindow addSubview:self];
        [self showPick];
        [self animationWithDismiss:YES];
    }
    return self;
}


-(void)showPick
{
   
    if(backView)
    {
        [backView removeFromSuperview];
        backView = nil;
    }
    

    backView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH)];
    backView.backgroundColor = KRGBA(153, 153, 153, 0.5);
    backView.alpha = 0;
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [backView addGestureRecognizer:tap];
    
    
    dateBackView = [[UIView alloc]initWithFrame:KFrame(0, KDeviceH, KDeviceW, pickHight+affimeHight)];
    dateBackView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:dateBackView];

    self.datePickerStyle = UUDateStyle_YearMonthDay;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    dateStr = [dateFormatter stringFromDate:date];
    

    datePicker = [[UUDatePicker alloc]initWithframe: CGRectMake(0, 0, KDeviceW, pickHight) Delegate:self PickerStyle:UUDateStyle_YearMonthDay];
    dateBackView.backgroundColor = [UIColor whiteColor];
   // datePicker.frame = CGRectMake(0, 0, KDeviceW, pickHight); // 设置
   // datePicker.ScrollToDate = date;
    [dateBackView addSubview:datePicker]; // 添加到View上
    
    
    UIButton *affimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [affimeBtn setTitle:@"确定" forState:UIControlStateNormal];
    affimeBtn.titleLabel.font = KFont(18);
    affimeBtn.tag = 2456;
    [affimeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [affimeBtn setTitleColor:KHexRGB(0xFC7B2B) forState:UIControlStateNormal];
    affimeBtn.frame = KFrame(KDeviceW/2, datePicker.maxY, KDeviceW/2, affimeHight);
    [dateBackView addSubview:affimeBtn];
    
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = KFont(18);
    cancleBtn.tag = 5673;
    [cancleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
    cancleBtn.frame = KFrame(0, datePicker.maxY, KDeviceW/2, affimeHight);
    [dateBackView addSubview:cancleBtn];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, datePicker.maxY , KDeviceW , 1);
    lineView.backgroundColor = KRGB(241, 241, 241);
    [dateBackView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(KDeviceW/2, datePicker.maxY, 1 , affimeHight);
    lineView2.backgroundColor = KRGB(241, 241, 241);
    [dateBackView addSubview:lineView2];
    
    
}


-(void)buttonClick:(UIButton *)sender
{
    [self animationWithDismiss:NO];
    
    if(sender.tag == 2456)
    {
        
        // NSLog(@"%@",dateAndTime);
        
        if(self.delegate&&[self.delegate respondsToSelector:@selector(chooseDate:)])
        {
            [self.delegate chooseDate:dateStr];
        }

    }
    
    
}


-(void)setDatePickerStyle:(DateStyle)datePickerStyle
{
    _datePickerStyle = datePickerStyle;
    
    datePicker.datePickerStyle = datePickerStyle;
    
}

-(void)setGetDayDate:(NSDate *)getDayDate
{
    _getDayDate = getDayDate;
    datePicker.getDayDate = getDayDate;
}

#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    if(self.datePickerStyle == UUDateStyle_YearMonthDay)
    {
        dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }
    else if(self.datePickerStyle == UUDateStyle_YearMonth)
    {
        dateStr = [NSString stringWithFormat:@"%@%@",year,month];
    }
    else if (self.datePickerStyle == UUDateStyle_Month)
    {
        dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }
    else if (self.datePickerStyle == UUDateStyle_Day)
    {
        dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }
    
}


-(void)tap
{
    [self animationWithDismiss:NO];
}


-(void)animationWithDismiss:(BOOL)isShow
{
    if(isShow)
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = dateBackView.frame;
            frame.origin.y = KDeviceH - pickHight - affimeHight;
            dateBackView.frame = frame;
            backView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];

    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = dateBackView.frame;
            frame.origin.y = KDeviceH;
            dateBackView.frame = frame;
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];

    }
    
}

-(void)setStartDateStr:(NSString *)startDateStr
{
    _startDateStr = startDateStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date;
    if(startDateStr.length>0)
    {
        date = [dateFormatter dateFromString:self.startDateStr];
        dateStr = [dateFormatter stringFromDate:date];
    }
    else
    {
        date = [NSDate date];
        dateStr = [dateFormatter stringFromDate:date];
    }

    datePicker.ScrollToDate = date;
}

-(void)setStartMonth:(NSString *)startMonth
{
    _startDateStr = startMonth;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMM"];
    NSDate *date;
    if(startMonth.length>0)
    {
        date = [dateFormatter dateFromString:self.startDateStr];
        dateStr = [dateFormatter stringFromDate:date];
    }
    else
    {
        date = [NSDate date];
        dateStr = [dateFormatter stringFromDate:date];
    }
    
    datePicker.ScrollToDate = date;
}


@end
