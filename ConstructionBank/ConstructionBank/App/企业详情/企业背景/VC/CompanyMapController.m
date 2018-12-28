//
//  CompanyMapController.m
//  EnterpriseInquiry
//
//  Created by jusfoun on 15/11/20.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "CompanyMapController.h"



#define numTag 2378
#define centerWidth 50
#define centerCicle 66
#define BUTTONLENGTH  135

#define buttonWidth 18

@interface CompanyMapController ()
{
    UIScrollView *backScrollView ;
    UIView *relationView;
    
    
    NSMutableArray *btnArray;//运动点的存贮
    
    NSMutableArray *selectBtnArray;//点击的btn的存贮
    
    UIButton *selectBtn;//选择的按钮
    NSDictionary *selectDic;//选择的按钮的数据
    
    
    UIImageView *centerImageView;
    UILabel *centerLabel;
    
    
    
    UIImageView *centerImageView2;
    UILabel *centerLabel2;
    UIButton *centerBtn2;
    
    CompanyMapLeftView *leftCompanyMapView;//左边视图
    UIView *mengBanView;
    
    
    UIView *detailView;
    
    UIButton *guDongBtn;
    UIButton *touZiBtn;
    UIButton *changeBtn;
    
    UIView *changeStretchView;
    
    UIButton *firstChangeBtn;
    UIButton *secondChangeBtn;
    
    UIImageView *changedownImageView;
    
    NSMutableDictionary *allCompDic;
    NSMutableArray *touZiArray;
    NSMutableArray *guDongArray;
    
    
    NSMutableDictionary *allCompDic2;
    NSMutableArray *touZiArray2;
    NSMutableArray *guDongArray2;
    
    
    //计数，用于显示第几批了
    int guDongCount;
    int touZiCount;
    
    
    NSMutableArray *storeGuDongArray;
    NSMutableArray *storeTouziArray;
    
    int secondCompCunt;//记录二级显示几个企业
    
    
    CGFloat radius;
    
    //第二个中心点的model
    ButtonModel *centeBtnModel2;
    
    BOOL isFirstBtnActivity;
   // AFHTTPRequestOperation *operation;
    
    
    NSString *centerId;//第一个中心点id
    
    
    CGFloat WholeWidth;
    CGFloat WholeHeight;//为了解决iOS 7强制横屏，frame却没改变的情况

}

@end

@implementation CompanyMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    centerId = self.entid;
    self.navigationController.navigationBarHidden = YES;
    
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive)    name:UIApplicationDidBecomeActiveNotification object:nil];
    [self hengshuping:true];
    
    
    if(KDeviceW > KDeviceH)
    {
        WholeWidth = KDeviceW;
        WholeHeight = KDeviceH;
    }
    else
    {
        WholeWidth = KDeviceH;
        WholeHeight = KDeviceW;
    }
    
    
    radius = (WholeHeight - 48)/2 - 15;
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 38, WholeWidth, WholeHeight -38)];
    //backScrollView.frame = CGRectMake(0, 20, KDeviceW, KDeviceH -20);
    backScrollView.contentSize = CGSizeMake(WholeHeight*4, (WholeHeight )*3 );
    backScrollView.delegate = self;
    // backScrollView.pagingEnabled = YES;
    backScrollView.scrollsToTop = NO;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.contentOffset = CGPointMake(WholeHeight +20, WholeHeight  );
    backScrollView.minimumZoomScale = 1;
    backScrollView.maximumZoomScale = 3.0;
    backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backScrollView];
    
    //初始化第一批
    guDongCount = 1;
    touZiCount = 1;
    btnArray = [NSMutableArray arrayWithCapacity:1];
    selectBtnArray = [NSMutableArray arrayWithCapacity:1];
    storeTouziArray = [NSMutableArray arrayWithCapacity:1];
    storeGuDongArray = [NSMutableArray arrayWithCapacity:1];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [relationView addGestureRecognizer:pinchGesture];
   
    [self setNavView];
    
    
    // self.entid = @"890528";
    //self.entid = @"88987";
    
    // [self reloadData:self.entid];
    
    [self beginDealWithCompanyInfo:[[NSMutableDictionary alloc] initWithDictionary:self.companyDic]];

}


-(void)viewDidAppear:(BOOL)animated{
    }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
//    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.navigationController.navigationBarHidden = YES;
   // [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive)    name:UIApplicationDidBecomeActiveNotification object:nil];
    [self hengshuping:true];

    
   
}



-(void)beginDealWithCompanyInfo:(NSMutableDictionary *)companyInfoDic
{
    allCompDic = companyInfoDic;
    touZiArray = [allCompDic objectForKey:@"investments"];
    guDongArray = [allCompDic objectForKey:@"shareholders"];
    
    guDongCount = 1;
    touZiCount = 1;
    
    int num = 8;
    int num2 = 8;
    if(touZiArray.count > 0 )
    {
        
        if(touZiArray.count <=8)
        {
            num = (int)touZiArray.count;
        }
        NSString *str = [NSString stringWithFormat:@"投资(%d/%d)",num,(int)touZiArray.count];
        [touZiBtn setTitle:str forState:UIControlStateNormal];
        touZiBtn.enabled = YES;
        touZiBtn.selected = YES;
    }
    
    
    
    
    if(guDongArray.count > 0 )
    {
        
        if(guDongArray.count <=8)
        {
            num2 = (int)guDongArray.count;
        }
        
        NSString *str2 = [NSString stringWithFormat:@"股东(%d/%d)",num2,(int)guDongArray.count];
        [guDongBtn setTitle:str2 forState:UIControlStateNormal];
        guDongBtn.enabled = YES;
        guDongBtn.selected = YES;
        
    }
    
    
    
    if(touZiArray.count + guDongArray.count <= 16)
    {
        changeBtn.enabled = NO;
    }
    
    [self reloadRelationView];
}




#pragma mark - 加载企业数据
-(void)reloadData:(NSString *)compID companyName:(NSString*)companyName
{
 
    centerId = compID;
    [MBProgressHUD showMessag:@"" toView:self.view];
    //[self showHUDOnView:self.view];

   NSString *url = [NSString stringWithFormat:@"%@?entid=%@&entname=%@&userid=%@",KGetEntAtlasData,self.entid,companyName,KUSER.userID];

    NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",requestURL);

    [RequestManager getWithURLString:requestURL parameters:nil isJSONRequest:NO success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHudToView:self.view animated:YES];
       // CompanyMapModel *mapModel;
        //NSLog(@"%@",model);

        if([[responseObject objectForKey:@"result"] intValue]==0)
        {
            guDongCount = 1;
            touZiCount = 1;
            btnArray = [NSMutableArray arrayWithCapacity:1];
            selectBtnArray = [NSMutableArray arrayWithCapacity:1];
            storeTouziArray = [NSMutableArray arrayWithCapacity:1];
            storeGuDongArray = [NSMutableArray arrayWithCapacity:1];
            changedownImageView.hidden = YES;


            [self beginDealWithCompanyInfo:[NSMutableDictionary dictionaryWithDictionary: [responseObject objectForKey:@"data"]]];
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];

}


#pragma mark - 展开右滑视图
-(void)showLeftViewWithFrame:(CGRect)frame andIsChild:(BOOL)isChild andIsFild:(BOOL)isFold andIsShareHold:(BOOL)isShareHold andDicInfo:(NSDictionary *)dataInfo
{
    if(leftCompanyMapView)
    {
        [leftCompanyMapView removeFromSuperview];
        leftCompanyMapView = nil;
    }
    
    if (mengBanView) {
        [mengBanView removeFromSuperview];
        mengBanView = nil;
    }
    
    
    leftCompanyMapView = [[CompanyMapLeftView alloc]initWithFrame:frame withIschild:isChild andIsFold:isFold andIsShareHold:isShareHold andDicInfo:dataInfo];
    UISwipeGestureRecognizer *SwipeGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeftCompanyView:)];
    [leftCompanyMapView addGestureRecognizer:SwipeGesture];
    leftCompanyMapView.delegate = self;
    [self.view addSubview:leftCompanyMapView];
    
    mengBanView = [[UIView alloc] init];
    mengBanView.frame = CGRectMake(0, 0, WholeWidth ,WholeHeight);
    UIColor *color = [UIColor blackColor];
    mengBanView.backgroundColor = [color colorWithAlphaComponent:0.3];
    [self.view insertSubview:mengBanView belowSubview:leftCompanyMapView];
    
    mengBanView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [mengBanView addGestureRecognizer:tapGestture];
    
    
    
    
    mengBanView.frame = KFrame(0, 0, WholeWidth, WholeHeight);
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         leftCompanyMapView.frame = KFrame (WholeWidth - 180, 0 ,180 , WholeHeight);
                         
                         
                     } completion:^(BOOL finished) {
                         
                     }];

}


#pragma mark - 移除右滑视图
-(void)removeLeftView
{
    if(leftCompanyMapView)
    {
        mengBanView.frame = KFrame(WholeWidth, 0, WholeWidth - 180, WholeHeight);
        [UIView animateWithDuration:0.3 animations:^{
            leftCompanyMapView.frame = KFrame (WholeWidth , 0 ,180 , WholeHeight);
            
        } completion:^(BOOL finished) {
            
            [leftCompanyMapView removeFromSuperview];
            leftCompanyMapView = nil;
            [mengBanView removeFromSuperview];
            mengBanView = nil;
        }];
    }
}



#pragma  mark - 创建界面
-(void)reloadRelationView
{

    [self removeLeftView];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1];
    
    if(guDongArray.count >0 && touZiArray.count>0)
    {
        if(guDongArray.count > 8*guDongCount)
        {
            for(int i = 8 *(guDongCount-1);i<8*guDongCount;i++)
            {
                [array1 addObject:guDongArray[i]];
            }
            changeBtn.enabled = YES;
            guDongCount++;
        }
        else if (guDongArray.count <= 8*guDongCount && guDongArray.count > 0)
        {
            for(int i = 8 *(guDongCount-1);i<guDongArray.count;i++)
            {
                [array1 addObject:guDongArray[i]];
            }
            guDongCount = 1;
            
        }
        NSString *str = [NSString stringWithFormat:@"股东(%d/%d)",(int)array1.count,(int)guDongArray.count];
        [guDongBtn setTitle:str forState:UIControlStateNormal];
        
        
        if(touZiArray.count > 8*touZiCount)
        {
            for(int i = 8 *(touZiCount-1);i<8*touZiCount;i++)
            {
                [array2 addObject:touZiArray[i]];
            }
            changeBtn.enabled = YES;
            touZiCount ++;
            
        }
        else if (touZiArray.count <= 8*touZiCount && touZiArray.count > 0)
        {
            for(int i = 8 *(touZiCount-1);i<touZiArray.count;i++)
            {
                [array2 addObject:touZiArray[i]];
            }
            touZiCount =1;
        }
        
        NSString *str2 = [NSString stringWithFormat:@"投资(%d/%d)",(int)array2.count,(int)touZiArray.count];
        [touZiBtn setTitle:str2 forState:UIControlStateNormal];
        
        [self initRelationViewWithGuDongArray:array1 withIsInside1:YES withTouZiArray:array2 withIsInside2:NO];
        
    }
    else if (guDongArray.count ==0 && touZiArray.count>0)
    {
        if(storeGuDongArray.count !=0)
        {
            NSString *str = [NSString stringWithFormat:@"股东(0/%d)",(int)storeGuDongArray.count];
            [guDongBtn setTitle:str forState:UIControlStateNormal];
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"股东(0/0)"];
            [guDongBtn setTitle:str forState:UIControlStateNormal];
            guDongBtn.enabled = NO;
            guDongBtn.selected = NO;
        }
        
        
        if(touZiArray.count > touZiCount*16)
        {
            for (int i=16 *(touZiCount-1);i< (touZiCount )*16; i++)
            {
                if (i%2 == 0) {
                    [array2 addObject:touZiArray[i]];
                }else
                {
                    [array1 addObject:touZiArray[i]];
                }
            }
            touZiCount ++;
        }
        else
        {
            for (int i = 16 *(touZiCount-1); i<touZiArray.count; i++) {
                if (i%2 == 0) {
                    [array2 addObject:touZiArray[i]];
                }else
                {
                    [array1 addObject:touZiArray[i]];
                }
                
            }
            
            if(touZiCount == 1)
            {
                changeBtn.enabled = NO;
            }
            else
            {
                touZiCount = 1;
            }
            
            
        }
        
        NSString *str2 = [NSString stringWithFormat:@"投资(%d/%d)",(int)array2.count+(int)array1.count,(int)touZiArray.count];
        [touZiBtn setTitle:str2 forState:UIControlStateNormal];
        
        [self initRelationViewWithGuDongArray:array1 withIsInside1:NO withTouZiArray:array2 withIsInside2:NO];
    }
    else if (guDongArray.count >0 && touZiArray.count==0)
    {
        
        if(storeTouziArray.count !=0)
        {
            NSString *str = [NSString stringWithFormat:@"投资(0/%d)",(int)storeTouziArray.count];
            [touZiBtn setTitle:str forState:UIControlStateNormal];
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"投资(0/0)"];
            [touZiBtn setTitle:str forState:UIControlStateNormal];
            touZiBtn.enabled = NO;
            touZiBtn.selected = NO;
        }
        
        
        if(guDongArray.count > guDongCount*16)
        {
            for (int i = 16 *(guDongCount-1); i< (guDongCount )*16; i++) {
                if (i%2 == 0) {
                    [array1 addObject:guDongArray[i]];
                }else
                {
                    [array2 addObject:guDongArray[i]];
                }
            }
            
            guDongCount ++;
        }
        else
        {
            for (int  i = 16 *(guDongCount-1); i< guDongArray.count; i++) {
                if (i%2 == 0) {
                    [array1 addObject:guDongArray[i]];
                }else
                {
                    [array2 addObject:guDongArray[i]];
                }
                
            }
            
            
            if(guDongCount == 1)
            {
                changeBtn.enabled = NO;
            }
            else
            {
                guDongCount = 1;
            }
            
        }
        
        
        NSString *str = [NSString stringWithFormat:@"股东(%d/%d)",(int)array1.count+(int)array2.count,(int)guDongArray.count];
        [guDongBtn setTitle:str forState:UIControlStateNormal];
        [self initRelationViewWithGuDongArray:array1 withIsInside1:YES withTouZiArray:array2 withIsInside2:YES];
    }
    else //if (guDongArray.count ==0 && touZiArray.count==0)
    {
        [self initRelationViewWithGuDongArray:array1 withIsInside1:YES withTouZiArray:array2 withIsInside2:YES];
    }
}




#pragma  mark - 设置上面栏
-(void)setNavView
{
    
    UIView *navBackView = [[UIView alloc]init];
    navBackView.frame = KFrame(0, 0, WholeWidth, 38);
    navBackView.backgroundColor = KRGB(242, 243, 245);
    [self.view addSubview:navBackView];
    
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(WholeWidth - 60, 0, 38, 38);
    //[closeBtn setTitle:@"X" forState:UIControlStateNormal];
    closeBtn.imageView.contentMode =  UIViewContentModeCenter;
    [closeBtn setImage: [Tools scaleImage:KImageName(@"终端关闭") size:CGSizeMake(15, 15) ] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    guDongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guDongBtn.frame = KFrame(0, 0, BUTTONLENGTH, 36);
    guDongBtn.enabled = NO;
    [guDongBtn setTitle:@"股东(0/0)" forState:UIControlStateNormal];
    
    [guDongBtn setImage:[Tools scaleImage:KImageName(@"notChoose") size:CGSizeMake(17, 17) ] forState:UIControlStateNormal];
    [guDongBtn setImage:[Tools scaleImage:KImageName(@"redchoose") size:CGSizeMake(17, 17) ]  forState:UIControlStateSelected];
    
    
    [guDongBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -10)];
    guDongBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [guDongBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [guDongBtn setTitleColor:KRGB(128, 128, 128) forState:UIControlStateDisabled];
    [guDongBtn addTarget:self action:@selector(stretchViewShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guDongBtn];

    
    changeStretchView = [[UIView alloc]initWithFrame:KFrame(BUTTONLENGTH*3-BUTTONLENGTH, -39, BUTTONLENGTH, 77)];
    changeStretchView.backgroundColor = KRGB(242, 243, 245);
    [self.view addSubview:changeStretchView];
    
    changedownImageView = [[UIImageView alloc]initWithFrame:KFrame(0, 70, BUTTONLENGTH, 7)];
    changedownImageView.hidden = YES;
    changedownImageView.image = [[UIImage imageNamed:@"orangeDropdown"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 1 ,2,6) ];
    [changeStretchView addSubview:changedownImageView];
    
    UIView *changeLineView1 =[[ UIView alloc]initWithFrame:KFrame(0, 0, changeStretchView.frame.size.width, 1)];
    changeLineView1.backgroundColor = KHexRGB(0xd9d9d9);
    [changeStretchView addSubview:changeLineView1];
    
    firstChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstChangeBtn.frame = KFrame(0, 1, BUTTONLENGTH-5, 38);
    firstChangeBtn.tag = 2312;
   // firstChangeBtn.backgroundColor = [UIColor redColor];
    [firstChangeBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [changeStretchView addSubview:firstChangeBtn];
    
    UIView *changeLineView =[[ UIView alloc]initWithFrame:KFrame(0, 38, changeStretchView.frame.size.width, 1)];
    changeLineView.backgroundColor = KHexRGB(0xd9d9d9);
    [changeStretchView addSubview:changeLineView];
    
    secondChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondChangeBtn.frame = KFrame(0, 38, BUTTONLENGTH-5, 38);
    secondChangeBtn.tag = 2313;
    //[secondChangeBtn setAttributedTitle:AttributedStr forState:UIControlStateNormal];
    [secondChangeBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [changeStretchView addSubview:secondChangeBtn];
    
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = KRGB(242, 243, 245);//RGB(41, 43, 53);
    backView.frame =KFrame(BUTTONLENGTH*2, 0, BUTTONLENGTH-5, 36);
    [self.view addSubview:backView];

    changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = KFrame(BUTTONLENGTH*2, 0, BUTTONLENGTH-5, 36);
   // changeBtn.backgroundColor = RGB(41, 43, 53);
    [changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [changeBtn setImage: [Tools scaleImage:KImageName(@"刷新红") size:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [changeBtn addTarget:self action:@selector(stretchViewShow:) forControlEvents:UIControlEventTouchUpInside];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn setTitleColor:KRGB(128, 128, 128) forState:UIControlStateDisabled];
    [self.view addSubview:changeBtn];
    
    
    //    UIView *backView1 = [[UIView alloc] init];
    //    backView1.backgroundColor = [UIColor redColor]; //RGB(41, 43, 53);
    //    backView1.frame = KFrame(BUTTONLENGTH*3-BUTTONLENGTH, 0, BUTTONLENGTH, 36);
    //    [self.view addSubview:backView1];
    
    
    
    
    
    touZiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touZiBtn.frame = KFrame(BUTTONLENGTH, 0, BUTTONLENGTH, 36);
    //touZiBtn.backgroundColor = RGB(41, 43, 53);
    [touZiBtn setTitle:@"投资(0/0)" forState:UIControlStateNormal];
    [touZiBtn setImage:[Tools scaleImage:KImageName(@"notChoose") size:CGSizeMake(17, 17) ]  forState:UIControlStateNormal];
    [touZiBtn setImage:[Tools scaleImage:KImageName(@"选中蓝") size:CGSizeMake(17, 17) ] forState:UIControlStateSelected];
    
    touZiBtn.enabled = NO;
    [touZiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -10)];
    touZiBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [touZiBtn addTarget:self action:@selector(stretchViewShow:) forControlEvents:UIControlEventTouchUpInside];
    [touZiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [touZiBtn setTitleColor:KRGB(128, 128, 128) forState:UIControlStateDisabled];
    [self.view addSubview:touZiBtn];
    
    
    
    
    UIView *lineView = [[UIView alloc ]initWithFrame:KFrame(BUTTONLENGTH -1, 0, 1, 38)];
    lineView.backgroundColor = KRGB(217,217,217);
    [self.view addSubview:lineView];
    
    
    UIView *lineView2 = [[UIView alloc ]initWithFrame:KFrame(BUTTONLENGTH+BUTTONLENGTH -1, 0, 1, 38)];
    lineView2.backgroundColor = KRGB(217,217,217);
    [self.view addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc ]initWithFrame:KFrame(BUTTONLENGTH*2 +BUTTONLENGTH -1, 0, 1, 38)];
    lineView3.backgroundColor = KRGB(217,217,217);
    [self.view addSubview:lineView3];
}


#pragma mark - 换一批
-(void)changeView:(UIButton*)sender
{
    
    if(!changeBtn.enabled)
    {
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        changeStretchView.frame = KFrame(BUTTONLENGTH*3-BUTTONLENGTH, -39, BUTTONLENGTH, 77);
        // changedownImageView.frame = KFrame(25, 70, BUTTONLENGTH, 7);
    }];
    
    
    
    if(sender.tag == 2312)//换一批
    {
        if (isFirstBtnActivity == NO) {
            return;
        }else
        {
            changedownImageView.hidden = YES;
            [self reloadRelationView];
        }
    }
    else //完成图
    {
        guDongCount = 1;
        touZiCount = 1;
        btnArray = [NSMutableArray arrayWithCapacity:1];
        selectBtnArray = [NSMutableArray arrayWithCapacity:1];
        storeTouziArray = [NSMutableArray arrayWithCapacity:1];
        storeGuDongArray = [NSMutableArray arrayWithCapacity:1];
        changedownImageView.hidden = YES;
        NSDictionary * dic  = centeBtnModel2.dataDic;
        
        [self reloadData:[dic objectForKey:@"entId"] companyName:[dic objectForKey:@"companyName"]];
    }
    
    
}

#pragma mark - 点击按钮
-(void)stretchViewShow:(UIButton *)sender
{
    //   if(selectBtnArray .count == 0)
    //   {
    //       return;
    //   }
    
    if (sender == changeBtn)
    {
        if(changedownImageView.hidden)//
        {
            [self reloadRelationView];
        }
        else
        {
            if(changeStretchView.frame.origin.y == -39)
            {
                ButtonModel *model = [selectBtnArray objectAtIndex:0];
                NSDictionary * tmpDic1 = model.dataDic;
                
                NSString *str ;
                if(model.isInSide)//股东
                {
                    
                    if([[tmpDic1 objectForKey:@"type"] intValue] == 1)//公司
                    {
                        str = [tmpDic1 objectForKey:@"shortName"];
                    }
                    else //人
                    {
                        str = [tmpDic1 objectForKey:@"name"];
                    }
                }
                else
                {
                    str = [tmpDic1 objectForKey:@"shortName"];
                }
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    changeStretchView.frame = KFrame(BUTTONLENGTH*3-BUTTONLENGTH, 36, BUTTONLENGTH, 77);
                    // changedownImageView.frame = KFrame(0, 70, 140, 7);
                }];
                
                
                NSString *comStr = [NSString stringWithFormat:@"“%@”",str];
                NSString *otherStr = @" 完整图";
                
                NSString *allStr = [NSString stringWithFormat:@"%@%@",comStr,otherStr];
                
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:allStr];
                
                [AttributedStr addAttribute:NSFontAttributeName
                 
                                      value:[UIFont systemFontOfSize:15.0]
                 
                                      range:NSMakeRange(0, allStr.length)];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:KRGB(254, 114, 14)
                 
                                      range:NSMakeRange(0, comStr.length)];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:[UIColor blackColor]
                 
                                      range:NSMakeRange(comStr.length,allStr.length-comStr.length)];
                
                [secondChangeBtn setAttributedTitle:AttributedStr forState:UIControlStateNormal];
                
                
                NSString *comStr2 = [NSString stringWithFormat:@"“%@”",[allCompDic objectForKey:@"cEntShortName"]];
                NSString *otherStr2 = @" 换一批";
                
                NSString *allStr2 = [NSString stringWithFormat:@"%@%@",comStr2,otherStr2];
                
                NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc]initWithString:allStr2];
                
                [AttributedStr2 addAttribute:NSFontAttributeName
                 
                                       value:[UIFont systemFontOfSize:15.0]
                 
                                       range:NSMakeRange(0, allStr2.length)];
                
                [AttributedStr2 addAttribute:NSForegroundColorAttributeName
                 
                                       value:KRGB(254, 114, 14)
                 
                                       range:NSMakeRange(0, comStr2.length)];
                
                if((touZiArray.count <= 8 && guDongArray.count <= 8) ||(touZiArray.count == 0 && guDongArray.count <=16) || (touZiArray.count <= 16 && guDongArray.count == 0))
                {
                    [AttributedStr2 addAttribute:NSForegroundColorAttributeName
                     
                                           value:[UIColor lightGrayColor]
                     
                                           range:NSMakeRange(comStr2.length,allStr2.length-comStr2.length)];
                    isFirstBtnActivity = NO;
                    
                }
                else
                {
                    [AttributedStr2 addAttribute:NSForegroundColorAttributeName
                     
                                           value:[UIColor blackColor]
                     
                                           range:NSMakeRange(comStr2.length,allStr2.length-comStr2.length)];
                    isFirstBtnActivity = YES;
                }
                
                
                
                [firstChangeBtn setAttributedTitle:AttributedStr2 forState:UIControlStateNormal];
                
                
                
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    changeStretchView.frame = KFrame(BUTTONLENGTH*3-BUTTONLENGTH, -39, BUTTONLENGTH, 77);
                    // changedownImageView.frame = KFrame(25, 70, BUTTONLENGTH, 7);
                }];
            }
            
            
        }
        
    }
    else
    {
        
        if (sender == guDongBtn && touZiBtn.selected == NO ) {
          
            [MBProgressHUD showHint:@"不可全部隐藏" toView:self.view];
            return;
        }else if(sender == touZiBtn && guDongBtn.selected == NO )
            
        {
           
            [MBProgressHUD showHint:@"不可全部隐藏" toView:self.view];
            return;
        }else
        {
            changedownImageView.hidden = YES;
            sender.selected = ! sender.selected;
            
            if(guDongBtn.selected == YES && touZiBtn.selected == NO)
            {
                guDongCount =1;
                storeTouziArray = [NSMutableArray arrayWithArray:touZiArray];
                
                touZiArray = [NSMutableArray arrayWithCapacity:1];
                
                if(guDongArray.count == 0)
                {
                    guDongArray =  [NSMutableArray arrayWithArray:storeGuDongArray];
                }
                
                
            }
            else if (guDongBtn.selected == NO && touZiBtn.selected == YES)
            {
                
                touZiCount =1;
                storeGuDongArray = [NSMutableArray arrayWithArray:guDongArray];
                
                guDongArray = [NSMutableArray arrayWithCapacity:1];
                
                if(touZiArray.count == 0)
                {
                    touZiArray =  [NSMutableArray arrayWithArray:storeTouziArray];
                }
                
            }
            else //换一批
            {
                touZiCount =1;
                guDongCount =1;
                if(touZiArray.count == 0)
                {
                    touZiArray =  [NSMutableArray arrayWithArray:storeTouziArray];
                }
                if(guDongArray.count == 0)
                {
                    guDongArray =  [NSMutableArray arrayWithArray:storeGuDongArray];
                }
            }
        }
        
        [self reloadRelationView];
    }
    
    
}



-(void)refreNav
{
    changeStretchView.backgroundColor = KRGB(41, 43, 53);
    changedownImageView.hidden = YES;
    changedownImageView.image = [[UIImage imageNamed:@"orangeDropdown"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 1 ,2,6) ];
    
    changeBtn.frame = KFrame(BUTTONLENGTH*2, 0, BUTTONLENGTH-7, 36);
    [changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [changeBtn setImage:KImageName(@"刷新红.pdf") forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn setTitleColor:KRGB(128, 128, 128) forState:UIControlStateDisabled];
}




-(void)becomeActive
{
    //    guDongCount = 1;
    //    touZiCount = 1;
    //    [self reloadRelationView];
    //    [self refreNav];
    
    
    for( ButtonModel *model in btnArray)
    {
        UIImageView *pointImageView = model.pointImageView;
        
        if(pointImageView != nil)
        {
            
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            
            if(model.isInSide)
            {
                
                CGPathMoveToPoint(curvedPath, NULL, model.selfBtn.center.x, model.selfBtn.center.y);
                CGPathAddLineToPoint(curvedPath, NULL, [model.centerCompX floatValue], [model.centerCompY floatValue]);
                
            }
            else
            {
                
                CGPathMoveToPoint(curvedPath, NULL, [model.centerCompX floatValue], [model.centerCompY floatValue]);
                CGPathAddLineToPoint(curvedPath, NULL, model.selfBtn.center.x, model.selfBtn.center.y);
                
            }
            
            
            [pointImageView.layer removeAllAnimations];
            //线的动画
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.duration = 1.0;
            animation.repeatCount = MAXFLOAT;
            animation.autoreverses = NO;
            animation.path = curvedPath;
            
            
            [pointImageView.layer addAnimation:animation forKey:@"position"];
            
            CGPathRelease(curvedPath);
        }
        
    }
    
    
    if(selectBtnArray.count != 0)
    {
        ButtonModel *model = [selectBtnArray objectAtIndex:0];
        
        UIImageView *pointImageView = model.pointImageView;
        
        if(pointImageView != nil)
        {
            
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            
            if(model.isInSide)
            {
                
                CGPathMoveToPoint(curvedPath, NULL, [model.otherCenterCompX floatValue], [model.otherCenterCompY floatValue]);
                CGPathAddLineToPoint(curvedPath, NULL, [model.centerCompX floatValue], [model.centerCompY floatValue]);
                
            }
            else
            {
                
                CGPathMoveToPoint(curvedPath, NULL, [model.centerCompX floatValue], [model.centerCompY floatValue]);
                CGPathAddLineToPoint(curvedPath, NULL, [model.otherCenterCompX floatValue], [model.otherCenterCompY floatValue]);
                
            }
            
            
            [pointImageView.layer removeAllAnimations];
            //线的动画
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.duration = 1.0;
            animation.repeatCount = MAXFLOAT;
            animation.autoreverses = NO;
            animation.path = curvedPath;
            
            
            [pointImageView.layer addAnimation:animation forKey:@"position"];
            
            CGPathRelease(curvedPath);
        }
        
        
    }
    
}



-(void)close
{
    [self removeLeftView];
}


#pragma mark - CompanyMapViewDelegate  按钮点击事件
-(void)buttonClick:(NSString *)text  withCompanyDic:(NSDictionary *)compDic
{
    
    [backScrollView setZoomScale:1 animated:YES];
    
    if ([text isEqualToString:@"企业详情"])
    {
        CompanyDetailController *CompanyDetatilVc =[[CompanyDetailController alloc]init];
        CompanyDetatilVc.companyId = [compDic objectForKey:@"entId"];
        CompanyDetatilVc.companyName = [compDic objectForKey:@"companyName"];
        [self hengshuping:NO];
        [self.navigationController pushViewController:CompanyDetatilVc animated:YES];
        

        
        NSLog(@"企业详情");
    }
    else if([text isEqualToString:@"完整图谱"])
    {
        
        [self reloadData:[compDic objectForKey:@"entId"] companyName:[compDic objectForKey:@"companyName"]];
        
        //[self becomeActive];
        
    }
    else if([text isEqualToString:@"展开图谱"])
    {
       
        [MBProgressHUD showMessag:@"" toView:self.view];

        NSString *url = [NSString stringWithFormat:@"%@?entid=%@&entname=%@&userid=%@",KGetEntAtlasData,[compDic objectForKey:@"entId"],[compDic objectForKey:@"companyName"],KUSER.userID];

        NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [RequestManager getWithURLString:requestURL parameters:nil isJSONRequest:NO  success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            [MBProgressHUD hideHudToView:self.view animated:YES];
            //CompanyMapModel *compModel ;
            
            if([[responseObject objectForKey:@"result"] intValue]==0)
            {
                
                changeBtn.enabled = YES;
                
                touZiArray2 = [NSMutableArray arrayWithCapacity:1];
                guDongArray2 = [NSMutableArray arrayWithCapacity:1];
                
                allCompDic2 = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                NSArray *array1 = [allCompDic2 objectForKey:@"investments"];
                for(NSDictionary *tmpdic in array1)
                {
                    NSString *entid = [NSString stringWithFormat:@"%@",[tmpdic objectForKey:@"entId"]];
                    if(![entid isEqualToString:centerId])
                    {
                        [touZiArray2 addObject:tmpdic];
                    }
                }
                
                NSArray *array2 = [allCompDic2 objectForKey:@"shareholders"];
                for(NSDictionary *tmpdic in array2)
                {
                    NSString *entid = [NSString stringWithFormat:@"%@",[tmpdic objectForKey:@"entId"]];
                    if(![entid isEqualToString:centerId])
                    {
                        [guDongArray2 addObject:tmpdic];
                    }
                }
                
                if(selectBtnArray.count != 0)
                {
                    [self removeSecondView:selectBtn];
                }
                
                else
                {
                    [self makeExtendView:selectBtn];
                }
                
                
            }
            else
            {
                [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            }

            
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
        }];
        

        
        
        
    }
    else if([text isEqualToString:@"收起图谱"])
    {
        NSLog(@"收起图谱");
        
        [self removeSecondView:centerBtn2];
        
    }
    
    [self removeLeftView];

}





#pragma  mark - 公司button点击
- (void)clickButtonWithButtonModel:(ButtonModel *)model
{
    BOOL isChild  = NO;
    BOOL isFold = NO;
    
    NSString * addURLStr ;
    
    if([model.centerCompX isEqualToString: [NSString stringWithFormat:@"%.3f",centerLabel2.frame.origin.x + centerWidth/2] ] && [model.centerCompY isEqualToString:[NSString stringWithFormat:@"%.3f",centerLabel2.frame.origin.y + centerWidth/2] ]  ) //二级菜单的公司点击
    {
        isChild = YES;
        isFold = YES;
        
        addURLStr = [NSString stringWithFormat:@"entid=%@",[centeBtnModel2.dataDic objectForKey:@"entId"]];
        
    }
    else if ([model.centerCompX isEqualToString: [NSString stringWithFormat:@"%.3f",centerLabel.frame.origin.x +centerWidth/2] ] && [model.centerCompY isEqualToString:[NSString stringWithFormat:@"%.3f",centerLabel.frame.origin.y +centerWidth/2] ]) //一级菜单的公司点击
    {
       addURLStr = [NSString stringWithFormat:@"entid=%@",centerId];
    }
    else // 二级菜单的中心点击
    {
        isFold = YES;
        isChild = YES;
    }
    
    NSString *choosId = [model.dataDic objectForKey:@"entId"];
    if(choosId.length == 0 &&[[model.dataDic objectForKey:@"type"] intValue] == 1)
    {
        
        [self showLeftViewWithFrame:CGRectMake(WholeWidth , 0 ,180 , WholeHeight) andIsChild:isChild andIsFild:isFold andIsShareHold:model.isInSide  andDicInfo:model.dataDic];

    }
    else
    {
        if(model.isInSide)//股东
        {
            addURLStr = [NSString stringWithFormat:@"entid=%@&type=%@",centerId,@"1"];
            
            if([[model.dataDic objectForKey:@"type"] intValue] == 1)//公司
            {
                addURLStr = [NSString stringWithFormat:@"%@&entName=%@&companyid=%@",addURLStr,[model.dataDic objectForKey:@"companyName"],[model.dataDic objectForKey:@"entId"]];
            }
            else //人
            {
                addURLStr = [NSString stringWithFormat:@"%@&shareholdername=%@",addURLStr,[model.dataDic objectForKey:@"name"]];
            }
            
        }
        else //投资
        {
            addURLStr = [NSString stringWithFormat:@"entid=%@&type=%@&entName=%@&companyid=%@",centerId,@"2",[model.dataDic objectForKey:@"companyName"],[model.dataDic objectForKey:@"entId"]];
            
        }
        
        
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSString *url = [NSString stringWithFormat:@"%@?%@",GetEntAtlasEntDetail,addURLStr];
        NSLog(@"%@",url);
        NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [RequestManager getWithURLString:requestURL parameters:nil isJSONRequest:NO  success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            [MBProgressHUD hideHudToView:self.view animated:YES];
            //CompanyMapModel *mapModel ;
            NSLog(@"%@",model);
            
            if([[responseObject objectForKey:@"result"] intValue]==0)
            {
                selectDic = [responseObject objectForKey:@"data"];
                [self showLeftViewWithFrame:CGRectMake(WholeWidth , 0 ,180 , WholeHeight) andIsChild:isChild andIsFild:isFold andIsShareHold:model.isInSide andDicInfo:selectDic];
                
            }
            else
            {
               [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            }

        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
        }];
        

     
    }
    
  
    
    
   
    
   
}



-(void)SwipeLeftCompanyView:(id)gesture{
    if(leftCompanyMapView)
    {
        [self removeLeftView];
    }
}

//三种情况点击：一级菜单的公司点击，二级菜单的公司点击，二级菜单的中心点击
-(void)bossChoose:(UIButton *)sender
{
    
    [self scrollViewDidScroll:backScrollView];
    
    selectBtn = sender;
    
    
    for( ButtonModel *model in btnArray)
    {
        
        if(model.selfBtn.frame.origin.x == sender.frame.origin.x &&model.selfBtn.frame.origin.y == sender.frame.origin.y )
        {
            
            [self clickButtonWithButtonModel:model];
            
            break;
        }
        
    }
    
}

#pragma mark - 点击点延伸
-(void)makeExtendView:(UIButton *)sender
{
    changedownImageView.hidden = NO;
    
    changeBtn.enabled = YES;
    
    for( ButtonModel *model in btnArray)
    {
        
        if(model.selfBtn.frame.origin.x == sender.frame.origin.x &&model.selfBtn.frame.origin.y == sender.frame.origin.y )
        {
            
            
            centeBtnModel2 = model;
            centeBtnModel2.dataDic = selectDic;
            CGFloat x,y;
            
            if(model.isLeft)
            {
                x = [model.centerCompX floatValue]- ( radius  +150) *cos( model.angle -  M_PI_4- M_PI_4/2);
                y = [model.centerCompY floatValue]- ( radius  +150) *sin( model.angle -  M_PI_4- M_PI_4/2);
                
            }
            else
            {
                
                x = [model.centerCompX floatValue]- ( radius  +150) *cos( model.angle +  M_PI_2+ M_PI_4/2);
                y = [model.centerCompY floatValue]- ( radius  +150) *sin( model.angle +  M_PI_2+ M_PI_4/2);
                
            }
            
            
            
            UIImageView *pointImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-MyCollection"]];
            if(model.isInSide)
            {
                pointImageView.image = KImageName(@"企业图谱亮光红");
            }
            else
            {
                pointImageView.image = KImageName(@"企业图谱亮光蓝");
                
            }
            pointImageView.frame = CGRectMake([model.centerCompX floatValue]-19/2, [model.centerCompY floatValue]-6/2, 19, 6);
            pointImageView.transform = CGAffineTransformMakeRotation(model.angle - M_PI_4- M_PI_4/2);
            
            [relationView insertSubview:pointImageView belowSubview:centerLabel];
            
            
            CGMutablePathRef curvedPath2 = CGPathCreateMutable();
            
            if(model.isInSide)
            {
                CGPathMoveToPoint(curvedPath2, NULL, x,y );
                
                CGPathAddLineToPoint(curvedPath2, NULL, [model.centerCompX floatValue] , [model.centerCompY floatValue]);
                
            }
            else
            {
                
                CGPathMoveToPoint(curvedPath2, NULL, [model.centerCompX floatValue], [model.centerCompY floatValue]);
                
                CGPathAddLineToPoint(curvedPath2, NULL, x , y);
            }
            
            
            
            
            //线的动画
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.duration = 1.0;
            animation.repeatCount = MAXFLOAT;
            animation.autoreverses = NO;
            animation.path = curvedPath2;
            
            
            
            
            
            
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            
            
            CGPathMoveToPoint(curvedPath, NULL, sender.frame.origin.x + buttonWidth/2, sender.frame.origin.y + buttonWidth/2);
            
            CGPathAddLineToPoint(curvedPath, NULL, x, y);
            
            
            CAShapeLayer *arcLayer=[CAShapeLayer layer];
            arcLayer.path=curvedPath;//46,169,230
            arcLayer.fillColor=[UIColor clearColor].CGColor;
            if(model.isInSide)
            {
                arcLayer.strokeColor=KInClolor.CGColor;
            }
            else
            {
                arcLayer.strokeColor=KOutClolor.CGColor;
            }
            
            arcLayer.lineWidth=1;
            arcLayer.frame=relationView.frame;
            
            
            CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            bas.duration=1;
            bas.fromValue=[NSNumber numberWithInteger:0];
            //  bas.delegate = self;
            bas.toValue=[NSNumber numberWithInteger:1];
            
            [bas setCompletion:^(BOOL finished) {
                [pointImageView.layer addAnimation:animation forKey:@"position"];
            }];
            [arcLayer addAnimation:bas forKey:@"key"];
            
            [relationView.layer insertSublayer:arcLayer below:centerLabel.layer];
            
            
            
            CGPoint point;
            point.x = x - WholeWidth/2;
            point.y = y - WholeHeight/2;
            
            [UIView animateWithDuration:1 animations:^{
                [backScrollView setContentOffset:point animated:NO];
            } completion:^(BOOL finished) {
                
                BOOL isInside = YES;
                BOOL isInside2= YES;
                
                NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
                NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1];
                

                if(guDongArray2.count >=4 && touZiArray2.count>=4)
                {
                    for(int i = 0;i<4;i++)
                    {
                        [array1 addObject:guDongArray2[i]];
                    }
                    
                    
                    for(int i =0;i<4;i++)
                    {
                        [array2 addObject:touZiArray2[i]];
                    }
                    
                    isInside = YES;
                    isInside2 = NO;
                    
                }
                else if (guDongArray2.count ==0 && touZiArray2.count>0)
                {
                    if(touZiArray2.count >= 8)
                    {
                        for(int i = 0;i<8;i++)
                        {
                            [array1 addObject:touZiArray2[i]];
                        }
                        
                        
                    }
                    else
                    {
                        for(int i = 0;i<touZiArray2.count;i++)
                        {
                            [array1 addObject:touZiArray2[i]];
                        }
                        
                    }
                    isInside = NO;
                    isInside2 = NO;
                    
                }
                else if (guDongArray2.count >0 && touZiArray2.count==0)
                {
                    if(guDongArray2.count >= 8)
                    {
                        for(int i = 0;i<8;i++)
                        {
                            [array1 addObject:guDongArray2[i]];
                        }
                        
                        
                    }
                    else
                    {
                        for(int i = 0;i<guDongArray2.count;i++)
                        {
                            [array1 addObject:guDongArray2[i]];
                        }
                        
                    }
                    isInside = YES;
                    isInside2 = YES;
                    
                }
                else if (guDongArray2.count <=4 && guDongArray2.count >0 && touZiArray2.count<=4&&touZiArray2.count>0)
                {
                    array1 = guDongArray2;
                    array2 = touZiArray2;
                    isInside = YES;
                    isInside2 = NO;
                }
                else if (guDongArray2.count <=4&& guDongArray2.count >0&& touZiArray2.count>4 )
                {
                    array1 = guDongArray2;
                    isInside = YES;
                    isInside2 = NO;
                    
                    if(touZiArray2.count + guDongArray2.count >=8)
                    {
                        for(int i = 0;i< 8-guDongArray2.count ;i++)
                        {
                            [array2 addObject:touZiArray2[i]];
                        }
                        
                    }
                    else
                    {
                        for(int i = 0;i< touZiArray2.count ;i++)
                        {
                            [array2 addObject:touZiArray2[i]];
                        }
                    }
                    
                    
                }
                else if (guDongArray2.count >4&& touZiArray2.count >0&& touZiArray2.count<=4)
                {
                    array2 = touZiArray2;
                    isInside = YES;
                    isInside2 = NO;
                    if(touZiArray2.count + guDongArray2.count >=8)
                    {
                        for(int i = 0;i<8 - touZiArray2.count ;i++)
                        {
                            [array1 addObject:guDongArray2[i]];
                        }
                        
                    }
                    else
                    {
                        for(int i = 0;i<guDongArray2.count ;i++)
                        {
                            [array1 addObject:guDongArray2[i]];
                        }
                    }
                }
                
                
                double startAngle2 =  (M_PI - M_PI_4)/(array1.count+array2.count+1);
                
                
                for(int i = 0;i<array1.count;i++)
                {
                    
                    NSDictionary *tmpDic = [array1 objectAtIndex:i];
                    
                    [self drawWithDataDic:tmpDic withIsLeft:model.isLeft withCenterX:x withCenterY:y withAngle:startAngle2 withExtendAnimate:YES withIsInSide:isInside];
                    
                    startAngle2 +=  (M_PI - M_PI_4)/(array1.count+array2.count+1);
                    
                }
                for(int i = 0;i<array2.count;i++)
                {
                    
                    NSDictionary *tmpDic = [array2 objectAtIndex:i];
                    
                    [self drawWithDataDic:tmpDic withIsLeft:model.isLeft withCenterX:x withCenterY:y withAngle:startAngle2 withExtendAnimate:YES withIsInSide:isInside2];
                    
                    startAngle2 +=  (M_PI - M_PI_4)/(array1.count+array2.count+1);
                    
                }
                
                secondCompCunt = (int)array1.count + (int)array2.count;
                
                centerImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(x-centerCicle/2, y-centerCicle/2, centerCicle, centerCicle)];
                centerImageView2.image = [UIImage imageNamed:@"Aperture"];
                [relationView addSubview:centerImageView2];
                [centerImageView2.layer addAnimation:[self ScaleAnimation] forKey:@"scale"];
                
                
                centerLabel2 = [[UILabel alloc]initWithFrame:KFrame(x - centerWidth/2, y- centerWidth/2, centerWidth, centerWidth)];
                centerLabel2.text = [allCompDic2 objectForKey:@"cEntShortName"];
                centerLabel2.numberOfLines = 0;
                centerLabel2.textAlignment = NSTextAlignmentCenter;
                centerLabel2.layer.cornerRadius = centerWidth/2;
                centerLabel2.clipsToBounds = YES;
                centerLabel2.backgroundColor = KRGB(254, 114, 14);
                centerLabel2.font = [UIFont fontWithName:@"Helvetica" size:13];
                centerLabel2.textColor = [UIColor whiteColor];
                [relationView addSubview:centerLabel2];
                
                centerBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                centerBtn2.frame = centerLabel2.frame;
                [centerBtn2 addTarget:self action:@selector(otherCenterClick:) forControlEvents:UIControlEventTouchUpInside];
                [relationView addSubview:centerBtn2];
                
                
                
                
                
                
                
                
            }];
            
            ButtonModel *buttonModel = [[ButtonModel alloc]init];
            buttonModel.centerCompId = model.centerCompId ;
            buttonModel.centerCompX = model.centerCompX;
            buttonModel.centerCompY =  model.centerCompY;
            buttonModel.otherCompId = @"";
            buttonModel.firstX =  [NSString stringWithFormat:@"%0.3f",sender.frame.origin.x];
            buttonModel.firstY = [NSString stringWithFormat:@"%0.3f",sender.frame.origin.y];
            buttonModel.otherCenterCompX =[NSString stringWithFormat:@"%0.3f",x];
            buttonModel.otherCenterCompY =[NSString stringWithFormat:@"%0.3f",y ];
            buttonModel.shapeLayer = arcLayer;
            buttonModel.pointImageView = pointImageView;
            buttonModel.angle = model.angle;
            buttonModel.isLeft = model.isLeft;
            buttonModel.nameLabel = model.nameLabel;
            buttonModel.isInSide = model.isInSide;
            buttonModel.dataDic = model.dataDic;
            buttonModel.pointImageViewPath =curvedPath2;
            selectBtnArray  = [NSMutableArray arrayWithObject:buttonModel];
            
            
            [model.pointImageView.layer removeAllAnimations];
            [model.pointImageView removeFromSuperview];
            
            
            [sender removeFromSuperview];
            
            [model.nameLabel removeFromSuperview];
            
            [btnArray removeObject:model];
            
            CGPathRelease(curvedPath2);
            CGPathRelease(curvedPath);
            
            
            break;
            
            
            
        }
        
        
        
    }
    
}



#pragma mark - 移除延伸出去的图谱
-(void)removeSecondView:(UIButton *)sender
{
    
    if(selectBtnArray.count != 0)
    {
        ButtonModel *selectModel = [selectBtnArray objectAtIndex:0];
        
        int num = 0;
        
        for(ButtonModel *btnModel in btnArray)
        {
            if([btnModel.centerCompX isEqualToString: [NSString stringWithFormat:@"%.3f",centerLabel2.frame.origin.x +centerWidth/2] ] && [btnModel.centerCompY isEqualToString:[NSString stringWithFormat:@"%.3f",centerLabel2.frame.origin.y +centerWidth/2] ]  )
            {
                [selectModel.pointImageView removeFromSuperview];
                [selectModel.pointImageView.layer removeAllAnimations];
                
                [btnModel.pointImageView.layer removeAllAnimations];
                [btnModel.pointImageView removeFromSuperview];
                [btnModel.nameLabel removeFromSuperview];
                [btnModel.arrowImageView removeFromSuperview];
                
                CGMutablePathRef curvedPath = CGPathCreateMutable();
                
                CGPathMoveToPoint(curvedPath, NULL, btnModel.selfBtn.frame.origin.x  +buttonWidth/2 , btnModel.selfBtn.frame.origin.y+buttonWidth/2);
                
                CGPathAddLineToPoint(curvedPath, NULL, [btnModel.centerCompX floatValue] , [btnModel.centerCompY floatValue]);
                
                
                
                //线的动画
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                animation.duration = 0.5;
                animation.repeatCount = 1;
                animation.autoreverses = NO;
                animation.path = curvedPath;
                [animation setCompletion:^(BOOL finished) {
                    [btnModel.selfBtn.layer removeAllAnimations];
                    [btnModel.selfBtn removeFromSuperview];
                    
                    
                    if(num == secondCompCunt-1)
                    {
                        CGMutablePathRef backPath = CGPathCreateMutable();
                        
                        
                        CGPathMoveToPoint(backPath, NULL, [selectModel.otherCenterCompX floatValue] , [selectModel.otherCenterCompY floatValue]);
                        
                        CGPathAddLineToPoint(backPath, NULL, [selectModel.firstX floatValue] +21 , [selectModel.firstY floatValue] + 21);
                        
                        
                        //线的动画
                        CAKeyframeAnimation *backAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                        backAnimation.duration = 0.5;
                        backAnimation.repeatCount = 1;
                        backAnimation.autoreverses = NO;
                        backAnimation.path = backPath;
                        
                        [backAnimation setCompletion:^(BOOL finished) {
                            
                            [centerImageView2.layer removeAllAnimations];
                            [centerImageView2 removeFromSuperview];
                            
                            [centerLabel2.layer removeAllAnimations];
                            [centerLabel2 removeFromSuperview];
                            [centerBtn2 removeFromSuperview];
                            
                            
                            
                        }];
                        centerLabel2.layer.position = CGPointMake([selectModel.firstX floatValue]+21, [selectModel.firstY floatValue]+21);
                        centerImageView2.layer.position = CGPointMake([selectModel.firstX floatValue]+21, [selectModel.firstY floatValue]+21);
                        [centerLabel2.layer addAnimation:backAnimation forKey:@"position"];
                        [centerImageView2.layer addAnimation:backAnimation forKey:@"position"];
                        
                        
                        
                        
                        CABasicAnimation *layerBackAnimation =[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                        layerBackAnimation.duration=0.5;
                        layerBackAnimation.autoreverses = NO;
                        layerBackAnimation.fromValue=[NSNumber numberWithInteger:1];
                        layerBackAnimation.toValue=[NSNumber numberWithInteger:0];
                        layerBackAnimation.removedOnCompletion = NO;
                        layerBackAnimation.fillMode = kCAFillModeForwards;
                        [layerBackAnimation setCompletion:^(BOOL finished) {
                            
                            [selectModel.shapeLayer removeFromSuperlayer];
                            [selectModel.shapeLayer removeAllAnimations];
                            
                            
                            
                            
                            UIImageView *pointImageView= [[UIImageView alloc]init];
                            if(selectModel.isInSide)
                            {
                                pointImageView.image = KImageName(@"企业图谱亮光红");
                                
                                
                            }
                            else
                            {
                                pointImageView.image = KImageName(@"企业图谱亮光蓝");
                                
                            }
                            pointImageView.frame = CGRectMake([selectModel.centerCompX floatValue]-19/2, [selectModel.centerCompY floatValue]-6/2, 19, 6);
                            pointImageView.transform = CGAffineTransformMakeRotation(selectModel.angle - M_PI_4- M_PI_4/2);
                            //  [relationView addSubview:pointImageView];
                            
                            [relationView insertSubview:pointImageView belowSubview:centerLabel];
                            
                            
                            CGMutablePathRef curvedPath = CGPathCreateMutable();
                            
                            if(selectModel.isInSide)
                            {
                                CGPathMoveToPoint(curvedPath, NULL, [selectModel.firstX floatValue] + buttonWidth/2 , [selectModel.firstY floatValue] + buttonWidth/2);
                                
                                CGPathAddLineToPoint(curvedPath, NULL, [selectModel.centerCompX floatValue] ,[selectModel.centerCompY floatValue]);
                            }
                            else
                            {
                                CGPathMoveToPoint(curvedPath, NULL, [selectModel.centerCompX floatValue], [selectModel.centerCompY floatValue]);
                                
                                CGPathAddLineToPoint(curvedPath, NULL, [selectModel.firstX floatValue] + buttonWidth/2 , [selectModel.firstY floatValue] + buttonWidth/2);
                            }
                            
                            
                            
                            
                            //线的动画
                            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                            animation.duration = 1.0;
                            animation.repeatCount = MAXFLOAT;
                            animation.autoreverses = NO;
                            animation.path = curvedPath;
                            
                            
                            [pointImageView.layer addAnimation:animation forKey:@"position"];
                            
                            
                            CAShapeLayer *arcLayer=[CAShapeLayer layer];
                            arcLayer.path=curvedPath;//46,169,230
                            arcLayer.fillColor=[UIColor clearColor].CGColor;
                            if(selectModel.isInSide)
                            {
                                arcLayer.strokeColor= KInClolor.CGColor;
                            }
                            else
                            {
                                arcLayer.strokeColor=KOutClolor.CGColor;
                            }
                            arcLayer.lineWidth=1;
                            arcLayer.frame=relationView.frame;
                            
                            [relationView.layer insertSublayer:arcLayer below:centerLabel.layer];
                            
                            CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                            bas.duration=2;
                            bas.fromValue=[NSNumber numberWithInteger:0];
                            bas.toValue=[NSNumber numberWithInteger:1];
                            [arcLayer addAnimation:bas forKey:@"key"];
                            
                            
                            
                            //[self.layer insertSublayer:arcLayer below:centerLayer];
                            
                            UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            nameBtn.frame = CGRectMake([selectModel.firstX floatValue], [selectModel.firstY floatValue], buttonWidth, buttonWidth);
                            
                            nameBtn.layer.cornerRadius = buttonWidth/2;
                            nameBtn.clipsToBounds = YES;
                            
                            if(selectModel.isInSide)
                            {
                                //[nameBtn setImage:[UIImage imageNamed:@"redPoint-1"] forState:UIControlStateNormal];
                                nameBtn.backgroundColor = KInClolor;
                            }
                            else
                            {
                               // [nameBtn setImage:[UIImage imageNamed:@"bluePoint"] forState:UIControlStateNormal];
                                nameBtn.backgroundColor = KOutClolor;
                            }
                            
                            [nameBtn addTarget:self action:@selector(bossChoose:) forControlEvents:UIControlEventTouchUpInside];
                            [relationView addSubview:nameBtn];
                            
                            
                            
                            CGPoint labelCenter;
                            if(selectModel.isLeft)
                            {
                                labelCenter.x = [selectModel.centerCompX  floatValue]-  (radius + 60) *cos(selectModel.angle - M_PI_4- M_PI_4/2);
                                labelCenter.y = [selectModel.centerCompY  floatValue]-  (radius + 60) *sin(selectModel.angle- M_PI_4- M_PI_4/2);
                            }
                            else
                            {
                                labelCenter.x = [selectModel.centerCompX floatValue]-  (radius + 60) *cos(selectModel.angle+M_PI_2+M_PI_4/2);
                                labelCenter.y = [selectModel.centerCompY floatValue] -  (radius + 60) *sin(selectModel.angle+M_PI_2+M_PI_4/2);
                                
                            }
                            
                            UILabel *nameLabel  = [[UILabel alloc]initWithFrame:KFrame(0, 0, 100, 20)];
                            nameLabel.text = selectModel.nameLabel.text;
                            nameLabel.center = labelCenter;
                            nameLabel.textColor = [UIColor blackColor];
                            nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
                            nameLabel.center = labelCenter;
                            nameLabel.userInteractionEnabled = YES;
                            UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NamelabelTap:)];
                            [nameLabel addGestureRecognizer:tapGesture];
                            
                            if(selectModel.isLeft)
                            {
                                nameLabel.textAlignment = NSTextAlignmentRight;
                            }
                            else
                            {
                                nameLabel.textAlignment = NSTextAlignmentLeft;
                            }
                            
                            nameLabel.transform = CGAffineTransformMakeRotation(selectModel.angle - M_PI_4- M_PI_4/2 );
                            
                            [relationView addSubview:nameLabel];
                            
                            
                            ButtonModel *buttonModel = [[ButtonModel alloc]init];
                            buttonModel.centerCompId = selectModel.centerCompId ;
                            buttonModel.centerCompX =  [NSString stringWithFormat:@"%0.3f",[selectModel.centerCompX floatValue]];
                            buttonModel.centerCompY = [NSString stringWithFormat:@"%0.3f",[selectModel.centerCompY floatValue]];
                            buttonModel.otherCompId = @"";
                            //  buttonModel.otherCompX = selectModel.firstX;
                            // buttonModel.otherCompY = selectModel.firstY;
                            buttonModel.shapeLayer = arcLayer;
                            buttonModel.pointImageView = pointImageView;
                            buttonModel.pointImageViewPath =curvedPath;
                            buttonModel.angle = selectModel.angle;
                            buttonModel.isLeft = selectModel.isLeft;
                            buttonModel.selfBtn = nameBtn;
                            buttonModel.nameLabel = nameLabel;
                            buttonModel.isInSide = selectModel.isInSide;
                            buttonModel.dataDic = selectModel.dataDic;
                            [btnArray addObject:buttonModel];
                            
                            changedownImageView.hidden = YES;
                            if(sender.frame.origin.x != centerBtn2.frame.origin.x)
                            {
                                [self makeExtendView:sender];
                            }
                            
                            [selectBtnArray removeObject:selectModel];
                            
                            
                            CGPathRelease(curvedPath);
                            
                            
                            
                            
                            
                        }];
                        [selectModel.shapeLayer addAnimation:layerBackAnimation forKey:@"key"];
                        
                        
                        if(sender.frame.origin.x == centerBtn2.frame.origin.x)
                        {
                            [UIView animateWithDuration:1 animations:^{
                                [backScrollView setContentOffset:CGPointMake([selectModel.centerCompX floatValue] - WholeWidth/2, [selectModel.centerCompY floatValue]-WholeHeight/2) animated:NO];
                            }];
                        }
                        
                        
                        CGPathRelease(backPath);
                        
                    }
                    
                    
                }];
                
                btnModel.selfBtn.layer.position = CGPointMake([btnModel.centerCompX floatValue], [btnModel.centerCompY floatValue]);
                [btnModel.selfBtn.layer addAnimation:animation forKey:@"position"];
                
                
                
                // btnModel.shapeLayer.path =curvedPath;
                
                CABasicAnimation *layerBackAnimation =[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                
                layerBackAnimation.duration=0.5;
                layerBackAnimation.autoreverses = NO;
                layerBackAnimation.fromValue=[NSNumber numberWithInteger:1];
                layerBackAnimation.toValue=[NSNumber numberWithInteger:0];
                layerBackAnimation.removedOnCompletion = NO;
                layerBackAnimation.fillMode = kCAFillModeForwards;
                [layerBackAnimation setCompletion:^(BOOL finished) {
                    
                    
                    [btnModel.shapeLayer removeAllAnimations];
                    [btnModel.shapeLayer removeFromSuperlayer];
                    
                    
                    
                }];
                
                [btnModel.shapeLayer  addAnimation:layerBackAnimation forKey:@"position"];
                
                
                
                
                
                CGPathRelease(curvedPath);
                
                
                
                num ++;
                
            }
            
            
            
            //
            
        }
        
        if((touZiArray.count + guDongArray.count) <= 16)
        {
            changeBtn.enabled = NO;
        }else
        {
            changeBtn.enabled = YES;
        }
    }
    
}

#pragma  mark - 第二中心点击
-(void)otherCenterClick:(UIButton*)sender
{
    
    
    [self removeLeftView];
    if(selectBtnArray.count == 0)
    {
        return;
    }
    
    ButtonModel *model  = centeBtnModel2;
    [self showLeftViewWithFrame:CGRectMake(WholeWidth , 0 ,180 , WholeHeight) andIsChild:NO andIsFild:YES andIsShareHold:model.isInSide andDicInfo:centeBtnModel2.dataDic];
    
}




- (void)initRelationViewWithGuDongArray:(NSMutableArray *)tmpArray1 withIsInside1:(BOOL)isInside1 withTouZiArray:(NSMutableArray *)tmpArray2 withIsInside2:(BOOL)isInside2
{
    
    if(relationView)
    {
        [relationView removeFromSuperview];
        relationView = nil;
    }
    
    relationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WholeHeight *4, (WholeHeight )*3 )];
    //relationView.backgroundColor = darkGrayColor ;
    
    
    [backScrollView addSubview:relationView];
    
    
    
    [btnArray removeAllObjects];
    btnArray = [NSMutableArray arrayWithCapacity:1];
    [selectBtnArray removeAllObjects];
    selectBtnArray = [NSMutableArray arrayWithCapacity:1];
    
    CGFloat centerY = WholeHeight *1.5 - 15;
    CGFloat centerX = WholeHeight *2;
    
    backScrollView.contentOffset = CGPointMake(centerX - WholeWidth/2, centerY - WholeHeight/2  );
    
    double startAngle = (M_PI - M_PI_4)/(tmpArray1.count+1);
    double startAngle2 = (M_PI - M_PI_4)/(tmpArray2.count+1);
    
    for(int i = 0;i<tmpArray1.count;i++)
    {
        NSDictionary *tmpDic = [tmpArray1 objectAtIndex:i];
        [self drawWithDataDic:tmpDic withIsLeft:YES withCenterX:centerX withCenterY:centerY withAngle:startAngle withExtendAnimate:NO withIsInSide:isInside1];
        startAngle += (M_PI - M_PI_4)/(tmpArray1.count+1);
    }
    
    for(int i = 0;i<tmpArray2.count;i++)
    {
        
        NSDictionary *tmpDic = [tmpArray2 objectAtIndex:i];
        [self drawWithDataDic:tmpDic withIsLeft:NO withCenterX:centerX withCenterY:centerY withAngle:startAngle2 withExtendAnimate:NO withIsInSide:isInside2];
        startAngle2 += (M_PI - M_PI_4)/(tmpArray2.count+1);
    }
    
    
    //中心 图片
    centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX-centerCicle/2, centerY-centerCicle/2, centerCicle, centerCicle)];
    centerImageView.image = [UIImage imageNamed:@"Aperture"];
    [relationView addSubview:centerImageView];
    
    [centerImageView.layer addAnimation:[self ScaleAnimation] forKey:@"scale"];
    
    centerLabel = [[UILabel alloc]initWithFrame:KFrame(centerX - centerWidth/2, centerY- centerWidth/2, centerWidth, centerWidth)];
    centerLabel.text = [allCompDic objectForKey:@"cEntShortName"];
    centerLabel.numberOfLines = 0;
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.layer.cornerRadius = centerWidth/2;
    centerLabel.clipsToBounds = YES;
    centerLabel.backgroundColor = KRGB(254, 114, 14);
    centerLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    centerLabel.textColor = [UIColor whiteColor];
    
    [relationView addSubview:centerLabel];
    
    
    UILabel *hasNoLabel = [[UILabel alloc] init];
    hasNoLabel.frame = CGRectMake(10,CGRectGetMaxY(centerLabel.frame) +10 ,0, 20);
    hasNoLabel.text = @"暂无股东,投资数据";
    [hasNoLabel sizeToFit];
    hasNoLabel.textColor = [UIColor lightGrayColor];
    hasNoLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    hasNoLabel.center = CGPointMake(centerLabel.center.x, CGRectGetMaxY(centerLabel.frame) +25);
    hasNoLabel.textAlignment = NSTextAlignmentCenter;
    hasNoLabel.hidden = YES;
    [relationView addSubview:hasNoLabel];
    
    if (tmpArray1.count==0 && tmpArray2.count == 0)
    {
        hasNoLabel.hidden = NO;
    }else
    {
        hasNoLabel.hidden = YES;
    }
    
    
    [self imageViewControllerBigAnimation];
    
}



- (void)imageViewControllerBigAnimation{
    
    CGAffineTransform newTransform1 =
    CGAffineTransformScale(relationView.transform, 0.5, 0.5);
    [relationView setTransform:newTransform1];
    
    
    [UIView animateWithDuration:1 animations:^{
        CGAffineTransform newTransform = CGAffineTransformConcat(relationView.transform,  CGAffineTransformInvert(relationView.transform));
        [relationView setTransform:newTransform];
        relationView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        for(ButtonModel *model in btnArray)
        {
            NSDictionary *tmpDic1 = model.dataDic;
            if(model.isInSide)//股东
            {
                
                if([[tmpDic1 objectForKey:@"type"] intValue] == 1)//公司
                {
                    model.nameLabel.text = [tmpDic1 objectForKey:@"shortName"];
                }
                else //人
                {
                    model.nameLabel.text = [tmpDic1 objectForKey:@"name"];
                }
            }
            else
            {
                model.nameLabel.text = [tmpDic1 objectForKey:@"shortName"];
            }
            
            
        }
    }];
    
}

#pragma mark - 建立图谱
-(void)drawWithDataDic:(NSDictionary *)compDic withIsLeft:(BOOL)isLeft withCenterX:(CGFloat)centerX withCenterY:(CGFloat)centerY withAngle:(double)startAngle withExtendAnimate:(BOOL)animate withIsInSide:(BOOL)isInSide
{
    // NSDictionary *tmpDic = [compArray objectAtIndex:i];
    
    
    
    double x = 0;
    double y = 0;
    
    CGPoint labelCenter;
    CGPoint imageCenter;
    
    double plusAngel;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    UIColor *lineColor;
    
    UIImage *pointImage;
    UIImage *arrowImage;
    //UIImage *compImage;
    
    if(isLeft)
    {
        plusAngel = - M_PI_4- M_PI_4/2;
        
        x = centerX - radius *cos(startAngle + plusAngel );
        y = centerY - radius*sin( startAngle + plusAngel);
    }
    else
    {
        plusAngel = M_PI_2+M_PI_4/2;
        x = centerX - radius *cos(startAngle + plusAngel );
        y = centerY - radius*sin( startAngle + plusAngel);
    }
    
    
    
    if(isInSide)
    {
        lineColor = KInClolor;
        pointImage = KImageName(@"企业图谱亮光红");
        arrowImage = KImageName(@"企业图谱箭头 红");
      //  compImage = KImageName(@"redPoint-1");
        
        
        
        CGPathMoveToPoint(curvedPath, NULL, x, y);
        CGPathAddLineToPoint(curvedPath, NULL, centerX, centerY);
        
        
        imageCenter.x = centerX -  40 *cos(startAngle + plusAngel );
        imageCenter.y = centerY -  40 *sin(startAngle + plusAngel);
        
        
        
    }
    else
    {
        lineColor = KOutClolor;
        pointImage = KImageName(@"企业图谱亮光蓝");
        arrowImage = KImageName(@"企业图谱箭头 蓝");
       // compImage = KImageName(@"bluePoint");
        
        
        
        
        CGPathMoveToPoint(curvedPath, NULL, centerX, centerY);
        CGPathAddLineToPoint(curvedPath, NULL, x, y);
        
        imageCenter.x = centerX -  (radius -20 ) *cos(startAngle + plusAngel);
        imageCenter.y = centerY -  (radius - 20) *sin(startAngle + plusAngel);
        
    }
    
    
    labelCenter.x = centerX - (radius + 60) *cos(startAngle + plusAngel);
    labelCenter.y = centerY - (radius + 60) *sin(startAngle + plusAngel);
    
    
    //公司名字
    UILabel *nameLabel  = [[UILabel alloc]initWithFrame:KFrame(0, 0, 100, 20)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    nameLabel.center = labelCenter;
    if(isLeft)
    {
        nameLabel.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    nameLabel.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2 );
    
    nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NamelabelTap:)];
    [nameLabel addGestureRecognizer:tapGesture];
    
    
    [relationView addSubview:nameLabel];
    
    
    //箭头
    UIImageView* arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 10, 11)];
    arrowImageView.image = arrowImage;
    
    if(isLeft && !isInSide)
    {
        arrowImageView.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2-M_PI);
    }
    else if(!isLeft && isInSide)
    {
        arrowImageView.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2-M_PI);
    }
    else
    {
        arrowImageView.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2);
    }
    
    
    arrowImageView.center = imageCenter;
    [relationView addSubview:arrowImageView];
    
    //运动的点
    UIImageView *pointImageView= [[UIImageView alloc]initWithImage:pointImage];
    pointImageView.frame = CGRectMake(x-19/2, y-6/2, 19, 6);
    pointImageView.transform = CGAffineTransformMakeRotation(startAngle - M_PI_4- M_PI_4/2 );
    [relationView addSubview:pointImageView];
    
    //运动点的动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 1.0;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = NO;
    animation.path = curvedPath;
    
    [pointImageView.layer addAnimation:animation forKey:@"position"];
    
    
    
    //画的线
    CAShapeLayer *arcLayer=[CAShapeLayer layer];
    arcLayer.path=curvedPath;//46,169,230
    arcLayer.fillColor=[UIColor clearColor].CGColor;
    arcLayer.strokeColor= lineColor.CGColor;
    arcLayer.lineWidth=1;
    arcLayer.frame=CGRectMake(0, 0, WholeWidth, WholeHeight  - 38);
    
    if(animate)
    {
        CGMutablePathRef curvedPath2 = CGPathCreateMutable();
        CGPathMoveToPoint(curvedPath2, NULL, centerX, centerY);
        CGPathAddLineToPoint(curvedPath2, NULL, x, y);
        animation.path = curvedPath2;
        arcLayer.path=curvedPath2;//46,169,230
        CGPathRelease(curvedPath2);
    }
    
    
    if(animate)
    {
        arrowImageView.hidden = YES;
        pointImageView.hidden = YES;
        CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        bas.duration=1;
        bas.fromValue=[NSNumber numberWithInteger:0];
        bas.toValue=[NSNumber numberWithInteger:1];
        [bas setCompletion:^(BOOL finished) {
            for(ButtonModel *model in btnArray)
            {
                NSString *x = [NSString stringWithFormat:@"%0.3f",centerImageView2.frame.origin.x  + centerCicle/2] ;
                NSString *y = [NSString stringWithFormat:@"%0.3f",centerImageView2.frame.origin.y  +centerCicle/2] ;
                if([model.centerCompX isEqualToString :x] && [model.centerCompY isEqualToString :y] )
                {
                    model.arrowImageView.hidden = NO;
                    model.pointImageView.hidden = NO;
                    NSDictionary *tmpDic1 = model.dataDic;
                    if(model.isInSide)//股东
                    {
                        
                        if([[tmpDic1 objectForKey:@"type"] intValue] == 1)//公司
                        {
                            model.nameLabel.text = [tmpDic1 objectForKey:@"shortName"];
                        }
                        else //人
                        {
                            model.nameLabel.text = [tmpDic1 objectForKey:@"name"];
                        }
                    }
                    else
                    {
                        model.nameLabel.text = [tmpDic1 objectForKey:@"shortName"];
                    }
                    
                    model.pointImageViewPath =curvedPath;
                    
                }
            }
            
        }];
        
        [arcLayer addAnimation:bas forKey:@"key"];
        
    }
    
    
    
    
    
    
    [relationView.layer addSublayer:arcLayer];
    
    
    //公司的点
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBtn.frame = CGRectMake(x-9, y-9, buttonWidth, buttonWidth);
    nameBtn.tag = [[NSString stringWithFormat:@"%@",[compDic objectForKey:@"compId"]] integerValue];
    //[nameBtn setImage:compImage forState:UIControlStateNormal];
    nameBtn.layer.cornerRadius = 9;
    nameBtn.clipsToBounds = YES;
    nameBtn.backgroundColor = lineColor;
    [nameBtn addTarget:self action:@selector(bossChoose:) forControlEvents:UIControlEventTouchUpInside];
    [relationView addSubview:nameBtn];
    
    if(animate)
    {
        animation.repeatCount = 1;
        [nameBtn.layer addAnimation:animation forKey:@""];
        
    }
    
    
    ButtonModel *buttonModel = [[ButtonModel alloc]init];
    
    buttonModel.centerCompId = [compDic objectForKey:@"centerCompId"] ;
    buttonModel.centerCompX =  [NSString stringWithFormat:@"%.3f",centerX ];
    buttonModel.centerCompY = [NSString stringWithFormat:@"%.3f",centerY];
    buttonModel.otherCompId = [compDic objectForKey:@"compId"];
    buttonModel.shapeLayer = arcLayer;
    buttonModel.pointImageView = pointImageView;
    buttonModel.pointImageViewPath =curvedPath;
    buttonModel.angle = startAngle;
    buttonModel.isLeft = isLeft;
    buttonModel.selfBtn = nameBtn;
    buttonModel.nameLabel = nameLabel;
    buttonModel.arrowImageView = arrowImageView;
    buttonModel.isInSide = isInSide;
    buttonModel.dataDic = compDic;
    
    if([[compDic objectForKey:@"entId"] isEqual:@"396634637379573973586C7A6D4143315642543468673D3D"])
    {
        NSLog(@"=====%@",compDic);
    }
    
    [btnArray addObject:buttonModel];
    
    
    CGPathRelease(curvedPath);
    
}

-(void)NamelabelTap:(id) object{
    
    UILabel *label = (UILabel *)((UITapGestureRecognizer *)object).view;
    for (ButtonModel *model in btnArray) {
        if ([model.nameLabel isEqual:label]) {
            
            selectBtn = model.selfBtn;
            [self clickButtonWithButtonModel:model];
            return;
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        changeStretchView.frame = KFrame(BUTTONLENGTH*3-BUTTONLENGTH, -39, BUTTONLENGTH, 77);
    } ];
    
    
    
}


- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    
    if([pinchGestureRecognizer state] == UIGestureRecognizerStateRecognized) {
        // 如果Pinch 手势结束，重置 previousScale 为 1.0
        //self.previousScale = 1.0;
        CGPoint point;
        
        int touchCount =(int) pinchGestureRecognizer.numberOfTouches;
        
        if (touchCount == 2) {
            
            CGPoint p1 = [pinchGestureRecognizer locationOfTouch: 0 inView:relationView ];
            
            CGPoint p2 = [pinchGestureRecognizer locationOfTouch: 1 inView:relationView ];
            
            
            
            point = CGPointMake( (p1.x+p2.x)/2,(p1.y+p2.y)/2);
            
            if(pinchGestureRecognizer.scale >1)
            {
                
                
                float newScale = [backScrollView zoomScale] * 1.5;
                CGRect zoomRect = [self zoomRectForScale:newScale  inView:backScrollView withCenter:point];
                
                [backScrollView zoomToRect:zoomRect animated:YES];
                
                
                
            }
            else if (pinchGestureRecognizer.scale <1)
            {
                float newScale = [backScrollView zoomScale] * 0.5;
                CGRect zoomRect = [self zoomRectForScale:newScale  inView:backScrollView withCenter:point];
                
                [backScrollView zoomToRect:zoomRect animated:YES];
                
            }
            
        }
    }
}




#pragma  mark - 缩放动画
-(CAAnimationGroup *)ScaleAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @(0.7);
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = 1.5;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 1.5;
    opacityAnimation.values = @[@(0.6), @(0.6), @(1)];
    opacityAnimation.keyTimes = @[@(0), @(0.5), @(1)];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.5;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    animationGroup.animations = animations;
    
    
    return animationGroup;
    
}



#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return relationView;
    
}


-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


-(void)leftBtnAction
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)viewWillDisappear:(BOOL)animated
{
    
//    if (self.isMovingToParentViewController) {
    
        [self hengshuping:NO];
        NSLog(@"push");
//    }else
//    {
//        
//        NSLog(@"pop");
//    }
    
      self.navigationController.navigationBarHidden = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive)    name:UIApplicationDidBecomeActiveNotification object:nil];
   
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
   [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
   
   
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

//横屏
- (void)hengshuping:(BOOL)m_bScreen {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *num = [[NSNumber alloc] initWithInt:(m_bScreen?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];//这行代码是关键
    }
    
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val =m_bScreen?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return ( UIInterfaceOrientationPortrait |UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
}

// 不自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"%f%f",WholeWidth,WholeHeight);
    return ( UIInterfaceOrientationPortrait |UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
//    CGRect frame = [UIScreen mainScreen].applicationFrame;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
