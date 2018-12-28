//
//  SendReportAlert.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/12/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "SendReportAlert.h"
#import "Tools.h"
#import <IQKeyboardManager/IQUIView+Hierarchy.h>

@interface SendReportAlert ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic ,strong) UIButton *cancelBtn;
@property (nonatomic ,strong) UIButton *assureBtn;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UITextField *emailField;
@end

@implementation SendReportAlert

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, KDeviceW, KDeviceH);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        self.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackGroundHide:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark - initView
- (void)didMoveToSuperview{
    if (self.superview) {
        [self initViews];
        [self initContentView];
    }
}

- (void)initViews{
    [self initBgView];
    [self initButtons];
}

- (void)initBgView{
    self.bgView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 190, KDeviceW-15*2, 286)];
        [self addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 8.0*(KDeviceW/375);
        view.clipsToBounds = YES;
        view.layer.masksToBounds = YES;
        view;
    });
}

- (void)initContentView{
    
    UIView *icon1 = [[UIView alloc]initWithFrame:KFrame(22, 30, 3.5, 16)];
    icon1.backgroundColor = KHexRGB(0xfa6949);
    [_bgView addSubview:icon1];
    
    UILabel *titleLab1 = [[UILabel alloc] initWithFrame:KFrame(icon1.maxX+10, 30, 85, 16)];
    titleLab1.text = @"汇报时间段";
    titleLab1.textColor = KHexRGB(0x666666);
    titleLab1.font = KFont(16);
    [_bgView addSubview:titleLab1];
    
    
    CGFloat lineWidth = (_bgView.width - 20*2- 50)/2;
    
    _startField = [[UITextField alloc]initWithFrame:KFrame(20, titleLab1.maxY+24, lineWidth - 21, 18)];
    _startField.placeholder = @"开始时间";
    _startField.font = KFont(16);
    _startField.delegate = self;
    _startField.tag = BASE_TAG;
    [_bgView addSubview:_startField];
    
    UIButton *pickerBtn1 = [[UIButton alloc]initWithFrame:KFrame(_startField.maxX, titleLab1.maxY+21.5, 21, 23)];
    [pickerBtn1 setImage:KImageName(@"riqi") forState:UIControlStateNormal];
    pickerBtn1.tag = 4745;
    [pickerBtn1 addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:pickerBtn1];
    
    UILabel *midLab = [[UILabel alloc]initWithFrame:KFrame(pickerBtn1.maxX+18, pickerBtn1.y, 20, 20)];
    midLab.text = @"至";
    midLab.font = KFont(16);
    midLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:midLab];
    
    _endField = [[UITextField alloc]initWithFrame:KFrame(midLab.maxX+18, titleLab1.maxY+24, lineWidth - 21, 18)];
    _endField.placeholder = @"结束时间";
    _endField.font = KFont(16);
    _endField.delegate = self;
    _endField.tag = BASE_TAG+1;
    [_bgView addSubview:_endField];
    
    UIButton *pickerBtn2 = [[UIButton alloc]initWithFrame:KFrame(_endField.maxX, titleLab1.maxY+21.5, 21, 23)];
    pickerBtn2.tag = 4746;
    [pickerBtn2 setImage:KImageName(@"riqi") forState:UIControlStateNormal];
    [pickerBtn2 addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:pickerBtn2];
    
    UIView *line1 = [[UIView alloc]initWithFrame:KFrame(_startField.x, _startField.maxY+18, lineWidth, 1)];
    line1.backgroundColor = KHexRGB(0xf2f2f2);
    [_bgView addSubview:line1];
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:KFrame(_endField.x, _startField.maxY+18, lineWidth, 1)];
    line2.backgroundColor = KHexRGB(0xf2f2f2);
    [_bgView addSubview:line2];
    
    //----
    UIView *icon2 = [[UIView alloc]initWithFrame:KFrame(20, line1.maxY+30, 3.5, 16)];
    icon2.backgroundColor = KHexRGB(0xfa6949);
    [_bgView addSubview:icon2];
    
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:KFrame(icon1.maxX+10, line1.maxY+30, 85, 16)];
    titleLab2.text = @"邮箱地址";
    titleLab2.textColor = KHexRGB(0x666666);
    titleLab2.font = KFont(16);
    [_bgView addSubview:titleLab2];
    
    _emailField = [[UITextField alloc]initWithFrame:KFrame(icon2.x, icon2.maxY+22, _bgView.width-20*2, 18)];
    _emailField.placeholder = @"请输入收件人的邮箱地址";
    _emailField.font = KFont(16);
    _emailField.delegate = self;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.tag = BASE_TAG+2;
    [_bgView addSubview:_emailField];
    
    UIView *line3 = [[UIView alloc]initWithFrame:KFrame(20, _emailField.maxY+18, _bgView.width-20*2, 1)];
    line3.backgroundColor = KHexRGB(0xf2f2f2);
    [_bgView addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:KFrame(0, _bgView.height-50, _bgView.width, 1)];
    line4.backgroundColor = KHexRGB(0xf2f2f2);
    [_bgView addSubview:line4];
    
}

- (void)initButtons{
    self.cancelBtn = ({
        UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame)-50, (CGRectGetWidth(_bgView.frame)-1)/2, 50)];
        [_bgView addSubview:view];
        [view setTitle:@"取消" forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
        [view addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont systemFontOfSize:18];
        view;
    });


    self.assureBtn = ({
        UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame)+1, CGRectGetHeight(_bgView.frame)-50, (CGRectGetWidth(_bgView.frame)-1)/2, 50)];
        [_bgView addSubview:view];
        [view setTitle:@"发送报告" forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0xfc7b2b) forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0x666666) forState:UIControlStateDisabled];
        view.titleLabel.font = [UIFont systemFontOfSize:18];
        [view addTarget:self action:@selector(assureAction) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
//
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame), CGRectGetHeight(_bgView.frame)-50, 1, 50)];
    lineView.backgroundColor = KHexRGB(0xe7e7e7);
    [_bgView addSubview:lineView];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([textField isEqual:_emailField]) {
        return YES;
    }else{
        if (textField.isAskingCanBecomeFirstResponder == NO) {//IQKeyBoard导致此方法多次调用，必须加上这一句来判断
            if ([self.delegate respondsToSelector:@selector(textFieldDidSelectAtIndex:)]) {
                [self.delegate textFieldDidSelectAtIndex:textField.tag-BASE_TAG];
            }
        }
        return NO;
    }
    return YES;
}

-(void)showDate:(UIButton*)button
{
    
    if(button.tag == 4745)
    {
        [self textFieldShouldBeginEditing:self.startField];
    }
    else
    {
        [self textFieldShouldBeginEditing:self.endField];
    }
    
}


#pragma mark - action
- (void)assureAction{
    [self hide];
    if (!_startField.text.length) {
        [MBProgressHUD showHint:@"请选择开始时间！" toView:nil];
        return;
    }
    if (!_endField.text.length) {
        [MBProgressHUD showHint:@"请选择结束时间！" toView:nil];
        return;
    }
    if (!_emailField.text.length) {
        [MBProgressHUD showHint:@"请输入收件人邮箱地址！" toView:nil];
        return;
    }
    if (![Tools isEmailAddress:_emailField.text]) {
        [MBProgressHUD showHint:@"请输入正确的邮箱地址！" toView:nil];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(sendReportAction:)]) {
        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
        [parmas setObject:_startField.text forKey:@"startDate"];
        [parmas setObject:_endField.text forKey:@"endDate"];
        [parmas setObject:_emailField.text forKey:@"email"];
        [parmas setObject:KUSER.userID forKey:@"userId"];
        [self.delegate sendReportAction:parmas];
    }
}

- (void)cancelAction{
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_bgView.frame, point)) {
        return NO;
    }
    return YES;
}

#pragma mark - 显示隐藏
- (void)showInView:(UIView *)view{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
    [self showAlertAnimation];
}

- (void)hide{
    
    [self dismissAlertAnimation];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)showAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [_bgView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [_bgView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (void)clickBackGroundHide:(UITapGestureRecognizer *)tap{
    [self hide];
}

@end
