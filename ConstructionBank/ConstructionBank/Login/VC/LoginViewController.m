//
//  LoginViewController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "LoginViewController.h"
#import <IQKeyboardManager.h>
@interface LoginViewController ()<UIScrollViewDelegate>
{
    UITextField *accountTextFld;
    UITextField *pwdTextFld;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 120;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
    
    [self setNavigationBarTitle:@"登录" andTextColor:KRGB(0, 0, 0)];
    
    
    [self drawView];
    
}


#pragma mark - 登录
-(void)login
{
    [self.view endEditing:YES];
    if (accountTextFld.text.length == 0) {
        [MBProgressHUD showError:@"请输入账户名" toView:self.view];
        return;
    }
    if (pwdTextFld.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[Tools md5:pwdTextFld.text]forKey:@"password"];
    NSString *username = accountTextFld.text;
    if (![username containsString:@"@ccb.com"]) {
        username = [NSString stringWithFormat:@"%@@ccb.com",username];
    }
    [params setObject:username forKey:@"username"];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KLogin parameters:params isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] integerValue] == 0) {
            [UserModel clearTable];
            UserModel *model = [UserModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [model save];
            [KNotificationCenter postNotificationName:KLoginSuccess object:nil];
            
            [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
            
            
        }
       
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
    
    
   
    
}

#pragma mark - 忘记密码
-(void)forgetPassword
{
    
}

#pragma mark -注册
-(void)regist
{
    RegistController *vc = [[RegistController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 绘制界面
-(void)drawView
{
    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:KFrame(0, -KNavigationBarHeight, KDeviceW, KDeviceH+KNavigationBarHeight)];
    backScrollView.delegate = self;
    backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backScrollView];
    
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:KFrame(15, KDeviceH/2-50-40*2-10, KDeviceW-30, 50)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = backImageView.height/2;
    backImageView.layer.borderWidth = 1;
    backImageView.layer.borderColor = KRGB(244, 243, 242).CGColor;
    backImageView.userInteractionEnabled = YES;
    [backScrollView addSubview:backImageView];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:KFrame(15, 10, 30, 30)];
    iconImageView.image = KImageName(@"登录用户");
    [backImageView addSubview:iconImageView];
    
    UIView *shuView = [[UIView alloc]initWithFrame:KFrame(iconImageView.maxX +10, 10, 1, 30)];
    shuView.backgroundColor = KRGB(237, 237, 237);
    [backImageView addSubview:shuView];
    
    
    accountTextFld = [[UITextField alloc]initWithFrame:KFrame(shuView.maxX +10, 0, backImageView.width - shuView.maxX - 25 , backImageView.height)];
    accountTextFld.placeholder = @"账号";
    accountTextFld.textColor = KRGB(152, 152, 152);
    [accountTextFld setValue:KRGB(152, 152, 152)
              forKeyPath:@"_placeholderLabel.textColor"];
    accountTextFld.font = KFont(14);
    //accountTextFld.text = @"wzp";
    [backImageView addSubview:accountTextFld];
    
    
    UIImageView *backImageView2 = [[UIImageView alloc]initWithFrame:KFrame(backImageView.x, backImageView.maxY + 15, backImageView.width, backImageView.height)];
    backImageView2.backgroundColor = [UIColor whiteColor];
    backImageView2.layer.cornerRadius = backImageView2.height/2;
    backImageView2.layer.borderWidth = 1;
    backImageView2.layer.borderColor = KRGB(244, 243, 242).CGColor;
    backImageView2.userInteractionEnabled = YES;
    [backScrollView addSubview:backImageView2];
    
    UIImageView *iconImageView2 = [[UIImageView alloc]initWithFrame:KFrame(15, 10, 30, 30)];
    iconImageView2.image = KImageName(@"登录密码");
    [backImageView2 addSubview:iconImageView2];
    
    UIView *shuView2 = [[UIView alloc]initWithFrame:KFrame(iconImageView2.maxX +10, 10, 1, 30)];
    shuView2.backgroundColor = KRGB(237, 237, 237);
    [backImageView2 addSubview:shuView2];
    
    
    pwdTextFld = [[UITextField alloc]initWithFrame:KFrame(shuView2.maxX +10, 0, backImageView2.width - shuView2.maxX - 25 , backImageView2.height)];
    pwdTextFld.placeholder = @"密码";
    pwdTextFld.textColor = KRGB(152, 152, 152);
    pwdTextFld.font = KFont(14);
    pwdTextFld.secureTextEntry = YES;
    [pwdTextFld setValue:KRGB(152, 152, 152)
                  forKeyPath:@"_placeholderLabel.textColor"];
   // pwdTextFld.text = @"123456";
    [backImageView2 addSubview:pwdTextFld];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = KFrame(backImageView.x, backImageView2.maxY +50, KDeviceW - backImageView.x*2, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"提交按钮"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = KFont(16);
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:loginBtn];
    
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = KFrame(KDeviceW -loginBtn.x - 80-20, loginBtn.maxY +15, 80, 20);
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:KRGB(0, 0, 0) forState:UIControlStateNormal];
    registBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    registBtn.titleLabel.font = KFont(13);
    [registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:registBtn];
    
//    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetBtn.frame = KFrame(KDeviceW -loginBtn.x - 80, loginBtn.maxY +10, 80, 20);
//    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [forgetBtn setTitleColor:KRGB(143, 143, 143) forState:UIControlStateNormal];
//    forgetBtn.titleLabel.font = KFont(12);
//    [forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
//    [backScrollView addSubview:forgetBtn];
//
    
    
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
  //  [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
    
    
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
