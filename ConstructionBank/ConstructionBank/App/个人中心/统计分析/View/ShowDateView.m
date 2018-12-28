//
//  ShowDateView.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "ShowDateView.h"

@implementation ShowDateView
{
    UIImageView *backImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSDate *date =[NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.endDayStr = [formatter stringFromDate:date];
        
        NSString *string = [NSString stringWithFormat:@"%@",[self.endDayStr substringWithRange:NSMakeRange(0,8)]] ;
        
        self.startDayStr = [NSString stringWithFormat:@"%@01",string] ;;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        
        // 加载图片
        UIImage *image = [UIImage imageNamed:@"日期选择"];
        
        // 设置左边端盖宽度
        NSInteger leftCapWidth = image.size.width * 0.5;
        // 设置上边端盖高度
        NSInteger topCapHeight = image.size.height * 0.5;
        
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];

        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:KFrame(15, 0, frame.size.width-30, 175)];
        imageView.userInteractionEnabled = YES;
        imageView.image = newImage;
        [self addSubview:imageView];
        backImageView = imageView;
        
        CGFloat lineWidth = (imageView.width - 20*2- 50)/2;
        
        _startField = [[UITextField alloc]initWithFrame:KFrame(20, 45, lineWidth - 21, 18)];
        _startField.placeholder = @"开始时间";
        _startField.font = KFont(16);
        _startField.text = self.startDayStr;
        _startField.delegate = self;
        _startField.tag = BASE_TAG;
        [imageView addSubview:_startField];
        
        UIButton *pickerBtn1 = [[UIButton alloc]initWithFrame:KFrame(_startField.maxX, 42, 21, 23)];
        pickerBtn1.tag = 2344;
        [pickerBtn1 setImage:KImageName(@"riqi") forState:UIControlStateNormal];
        [pickerBtn1 addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:pickerBtn1];
        
        UILabel *midLab = [[UILabel alloc]initWithFrame:KFrame(pickerBtn1.maxX+18, pickerBtn1.y, 20, 20)];
        midLab.text = @"至";
        midLab.font = KFont(16);
        midLab.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:midLab];
        
        _endField = [[UITextField alloc]initWithFrame:KFrame(midLab.maxX+18, _startField.y, lineWidth - 21, 18)];
        _endField.placeholder = @"结束时间";
        _endField.font = KFont(16);
        _endField.text = self.endDayStr;
        _endField.delegate = self;
        _endField.tag = BASE_TAG+1;
        [imageView addSubview:_endField];
        
        UIButton *pickerBtn2 = [[UIButton alloc]initWithFrame:KFrame(_endField.maxX, pickerBtn1.y, 21, 23)];
        pickerBtn2.tag = 2345;
        [pickerBtn2 setImage:KImageName(@"riqi") forState:UIControlStateNormal];
        [pickerBtn2 addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:pickerBtn2];
        
        UIView *line1 = [[UIView alloc]initWithFrame:KFrame(_startField.x, _startField.maxY+18, lineWidth, 1)];
        line1.backgroundColor = KHexRGB(0xf2f2f2);
        [imageView addSubview:line1];
        
        
        UIView *line2 = [[UIView alloc]initWithFrame:KFrame(_endField.x, _startField.maxY+18, lineWidth, 1)];
        line2.backgroundColor = KHexRGB(0xf2f2f2);
        [imageView addSubview:line2];
        
        
        UIView *line3 = [[UIView alloc]initWithFrame:KFrame(5, imageView.height-55, imageView.width-10, 1)];
        line3.backgroundColor = KHexRGB(0xE7E7E7);
        [imageView addSubview:line3];
        
        UIButton *affirmBtn = [[UIButton alloc]initWithFrame:KFrame(0, line3.maxY, imageView.width, imageView.height-line3.maxY)];
        [affirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [affirmBtn setTitleColor:KHexRGB(0xFC7B2B) forState:UIControlStateNormal];
        [affirmBtn addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:affirmBtn];
        
       
       
        
        
    }
    return self;
}


-(void)showDate:(UIButton*)button
{
    
    if(button.tag == 2344)
    {
        [self textFieldShouldBeginEditing:self.startField];
    }
    else
    {
        [self textFieldShouldBeginEditing:self.endField];
    }
    
}

-(void)chooseDate
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(chooseDateStartDayStr:endDayStr:)])
    {
        [self.delegate chooseDateStartDayStr:self.startDayStr endDayStr:self.endDayStr];
        [self remove];
    }
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.isAskingCanBecomeFirstResponder == NO) {//IQKeyBoard导致此方法多次调用，必须加上这一句来判断
        
        KWeakSelf
        if (textField == _startField) {
            
            [DatePickerView showDatePickerWithTitle:@"请选择日期" minDate:nil maxDate:nil defaultValue:self.startDayStr resultBlock:^(NSString * _Nonnull selectValue) {
                weakSelf.startField.text = selectValue;
                weakSelf.startDayStr = selectValue;
            } cancelBlock:^{
                
            }];
            
        }else{
            
            [DatePickerView showDatePickerWithTitle:@"请选择日期" minDate:nil maxDate:nil defaultValue:self.endDayStr resultBlock:^(NSString * _Nonnull selectValue) {
                weakSelf.endField.text = selectValue;
                weakSelf.endDayStr = selectValue;
            } cancelBlock:^{
                
            }];
            
        }
    }
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(backImageView.frame, point)) {
        return NO;
    }
    return YES;
}



-(void)remove
{
   self.alpha = 0;
}



@end
