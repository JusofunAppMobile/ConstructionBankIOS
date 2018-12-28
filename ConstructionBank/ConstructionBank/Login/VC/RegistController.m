//
//  RegistController.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "RegistController.h"
#import <IQKeyboardManager.h>
#import "Tools.h"
#define KTextFieldTag 47428

@interface RegistController ()<UIScrollViewDelegate>
{
    UIScrollView *backScrollView;
    CustomPickerView *pickView;
    UIButton *timeBtn;
    NSString *organizationId;
}

@end

@implementation RegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 120;
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavigationBarTitle:@"注册" andTextColor:[UIColor blackColor]];
    [self setBackBtn:@""];
    
    [self drawView];
}

#pragma mark - 注册
-(void)regist
{
    [self.view endEditing:YES];
    UITextField *textFld1 = [self.view viewWithTag:KTextFieldTag+0];
    UITextField *textFld2 = [self.view viewWithTag:KTextFieldTag+1];
    UITextField *textFld3 = [self.view viewWithTag:KTextFieldTag+2];
    UITextField *textFld4 = [self.view viewWithTag:KTextFieldTag+3];
    UITextField *textFld5 = [self.view viewWithTag:KTextFieldTag+4];
    UITextField *textFld6 = [self.view viewWithTag:KTextFieldTag+5];
    UITextField *textFld7 = [self.view viewWithTag:KTextFieldTag+6];
    
    
    if (textFld1.text.length == 0) {
        [MBProgressHUD showError:@"请输入用户名" toView:self.view];
        return;
    }
    if (textFld2.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    if (textFld3.text.length == 0) {
        [MBProgressHUD showError:@"请输入真实姓名" toView:self.view];
        return;
    }
    if (textFld4.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    if (textFld5.text.length == 0) {
        [MBProgressHUD showError:@"请选择所属机构" toView:self.view];
        return;
    }
    if (textFld6.text.length == 0) {
        [MBProgressHUD showError:@"请设置密码" toView:self.view];
        return;
    }
    
    if (![Tools isLegalPassword:textFld6.text]) {
        [MBProgressHUD showError:@"密码为6-16个英文字母或数字，区分大小写" toView:self.view];
        return;
    }
    if (textFld7.text.length == 0) {
        [MBProgressHUD showError:@"请填写确认密码" toView:self.view];
        return;
    }
    if (![textFld7.text isEqualToString:textFld6.text]) {
        [MBProgressHUD showError:@"两次填写密码不一致" toView:self.view];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *username = textFld1.text;
    if (![username containsString:@"@ccb.com"]) {
        username = [NSString stringWithFormat:@"%@@ccb.com",username];
    }
    [params setObject:username forKey:@"username"];
    [params setObject:textFld2.text forKey:@"code"];
    [params setObject:textFld3.text forKey:@"realName"];
    [params setObject:textFld4.text forKey:@"phone"];
    [params setObject:organizationId forKey:@"organizationId"];
    [params setObject:[Tools md5:textFld6.text] forKey:@"password"];
    [params setObject:@"" forKey:@"headIcon"];
    
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KRegiste parameters:params isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] integerValue] == 0) {
            [UserModel clearTable];
            UserModel *model = [UserModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [model save];
            [MBProgressHUD showSuccess:@"注册成功" toView:nil];
            [KNotificationCenter postNotificationName:KLoginSuccess object:nil];
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
    
    
    
    
}
#pragma mark - 请求所属机构
-(void)requestOrganization
{
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KGetOrganization parameters:nil isJSONRequest:YES success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] integerValue] == 0) {
            
            pickView = [[CustomPickerView alloc]initWithDicArray:[responseObject[@"data"]objectForKey:@"list"] keyName:@"cnnameFull" resultBlock:^(NSDictionary* result) {
                UITextField *textFld = [self.view viewWithTag:KTextFieldTag+4];
                textFld.text = [result objectForKey:@"cnnameFull"];
                organizationId = [result objectForKey:@"id"];
            }];
            [pickView show];
            
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
    
   
}

#pragma mark - 邮箱验证码
-(void)requestCode
{
    [self.view endEditing:YES];
    UITextField *textFld3 = [self.view viewWithTag:KTextFieldTag];
    if (textFld3.text.length == 0) {
        [MBProgressHUD showError:@"请输入邮箱" toView:self.view];
        return;
    }
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *email = textFld3.text;
    if (![email containsString:@"@ccb.com"]) {
        email = [NSString stringWithFormat:@"%@@ccb.com",email];
    }
    [paraDic setObject:email forKey:@"email"];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KSendEmailCode parameters:paraDic isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [self startTimer];
            [MBProgressHUD showHint:@"验证码发送成功" toView:self.view];
            
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
    
    
}


-(void)startTimer{
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [timeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                timeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [timeBtn  setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                timeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}



-(void)drawView
{
    backScrollView = [[UIScrollView alloc]initWithFrame:KFrame(0, -KNavigationBarHeight, KDeviceW, KDeviceH+KNavigationBarHeight)];
    backScrollView.delegate = self;
    backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backScrollView];
    
    NSArray *array = @[@"用户名",@"验证码",@"真实姓名",@"手机号",@"所属机构",@"密码（6-16个英文字母或数字，区分大小写）",@"确认密码"];
    for(int i = 0 ;i<array.count;i++)
    {
        [self textFieldWithFrame:KFrame(15, KNavigationBarHeight*2+30+ 40*i + 10*(i-1), KDeviceW - 30, 40) placeHolder:array[i] type:i];
    }
    
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = KFrame(15, KNavigationBarHeight*2+30+ 40*array.count + 10*(array.count-1) +50, KDeviceW - 15*2, 40);
    [registBtn setTitle:@"完成" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = KFont(16);
    [registBtn setBackgroundImage:[[UIImage imageNamed:@"提交按钮"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:registBtn];
    
    
    backScrollView.contentSize = CGSizeMake(KDeviceW, registBtn.maxY+50 >backScrollView.height?registBtn.maxY+50:backScrollView.height);
}


-(void)textFieldWithFrame:(CGRect)frame placeHolder:(NSString*)placeHolder type:(int)type
{
    UIView*view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = CGRectGetHeight(frame)/2;
    view.clipsToBounds = YES;
    view.layer.borderColor = KRGB(244, 243, 242).CGColor;
    view.layer.borderWidth = 1;
    [backScrollView addSubview:view];
    
    UITextField *textFld = [[UITextField alloc]initWithFrame:KFrame(15, 0, view.width -30, view.height)];
    textFld.placeholder = placeHolder;
    textFld.textColor = [UIColor blackColor];
    [textFld setValue:KRGB(162, 162, 162)
                  forKeyPath:@"_placeholderLabel.textColor"];
    textFld.font = KFont(14);
    textFld.tag = KTextFieldTag + type;
    [view addSubview:textFld];
    
    if(type == 0)//用户名
    {
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(view.width -60-20, 0, 60, view.height)];
        label.text = @"@ccb.com";
        label.font = KFont(12);
        label.textColor = KRGB(162, 162, 162);
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        
        textFld.frame = KFrame(15, 0, view.width -30 - label.width -5, view.height);
    }
    else if (type == 1)//验证码
    {
        timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timeBtn.frame = KFrame(view.width - 90 -10, 0, 90, view.height);
        [timeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        timeBtn.titleLabel.font = KFont(14);
        [timeBtn setTitleColor:KRGB(162, 162, 162) forState:UIControlStateNormal];
        [timeBtn addTarget:self action:@selector(requestCode) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:timeBtn];
        
        textFld.frame = KFrame(15, 0, view.width -30 - timeBtn.width -5, view.height);
        
    }
    else if (type == 4)//所属机构
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = KFrame(view.width - view.height-10, 0, view.height, view.height);
        [button setImage:KImageName(@"箭头下") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(requestOrganization) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        textFld.frame = KFrame(15, 0, view.width -30 - button.width -5, view.height);
        textFld.enabled = NO;
        
    }
    else if (type == 6||type == 5)//密码
    {
        textFld.secureTextEntry = YES;
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
