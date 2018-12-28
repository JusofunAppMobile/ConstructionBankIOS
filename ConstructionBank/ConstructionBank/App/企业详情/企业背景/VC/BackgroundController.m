//
//  BackgroundController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BackgroundController.h"

@interface BackgroundController ()

@property(nonatomic,strong)DetailWebBasicController *basicInfoController;

@property(nonatomic,strong)DetailWebBasicController *shareholderController;

@property(nonatomic,strong)DetailWebBasicController *memberController;

@property(nonatomic,strong)OrganizationController*organizationController;

@property(nonatomic,strong)InvestController*investController ;


@property(nonatomic,strong)NSMutableArray *vcArrray;




@end

@implementation BackgroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self drawView];
    
    [self changeViewController:self.itemModel];
    
    
}


-(void)drawView
{
    
    
    _vcArrray = [NSMutableArray arrayWithCapacity:1];
    for(int i = 0;i<self.itemArray.count;i++)
    {
        NSDictionary *dic = [self.itemArray objectAtIndex:i];
        ItemModel *model = [ItemModel mj_objectWithKeyValues:dic];
        if([[dic objectForKey:@"type"] intValue] == 1)//web页面
        {
            DetailWebBasicController *vc = [[DetailWebBasicController alloc]init];
            
            vc.detailWebBasicDelegate = self;
            vc.itemModel  = model;
            [_vcArrray addObject:vc];
        }
        if ([[dic objectForKey:@"type"] intValue] == 2)//2企业图谱
        {
            DetailMapController *vc = [DetailMapController new];
            vc.companyId = self.companyId;
            vc.companyName = self.companyName;
            
            vc.itemModel  = model;
            [_vcArrray addObject:vc];
        }
        if ([[dic objectForKey:@"type"] intValue] == 3)//3 对外投资
        {
            InvestController *vc = [InvestController new];
            vc.companyId = self.companyId;
            vc.companyName = self.companyName;
            
            vc.itemModel  = model;
            [_vcArrray addObject:vc];
        }
        if ([[dic objectForKey:@"type"] intValue] == 4)//4 分支机构
        {
            OrganizationController *vc = [OrganizationController new];
            vc.companyId = self.companyId;
            vc.companyName = self.companyName;
            
            vc.itemModel  = model;
            [_vcArrray addObject:vc];
        }
    }
    
}


-(void)changeViewController:(ItemModel*)model
{
    [self hideViewController:self.currentVc];
    
    
    for(int i = 0;i<self.vcArrray.count;i++)
    {
        BasicViewController *vc = self.vcArrray[i];
        ItemModel *tmpMode = vc.itemModel;
        if([model.menuid isEqualToString:tmpMode.menuid])
        {
            
            self.currentVc = vc;
            break;
        }
    }
    
    [self displayViewController:self.currentVc];
}



-(void)pullItemButtonClick:(ItemButton *)button
{
    ItemModel *model = button.squareModel;
    button.selected = YES;
    self.saveTitleStr = model.menuname;
    self.itemModel = model;
    
    [self setDetailNavigationBarTitle:self.saveTitleStr];
    [self showItemView];
  
    [self changeViewController:model];
}

-(void)detailWebPush:(NSString *)title
{
    self.isWebViewPush = YES;
    [self setDetailNavigationBarTitle:title];
    self.titleImageView.hidden = YES;
    self.titleButton.enabled = NO;
}

-(void)detailWebPop
{
    self.isWebViewPush = NO;
    [self setDetailNavigationBarTitle:self.saveTitleStr];
    self.titleImageView.hidden = NO;
    self.titleButton.enabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
