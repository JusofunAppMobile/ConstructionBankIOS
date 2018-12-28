//
//  MoreCompanyController.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MoreCompanyController.h"

@interface MoreCompanyController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView*backTableView;
   
}

@end

@implementation MoreCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self setNavigationBarTitle:@"浏览记录"];
    [self setBackBtn:@"back"];
    
    [self drawView];
    
    
}
#pragma mark - 加载数据
-(void)loadData
{
    
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [backTableView reloadData];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellString = @"BrowseCell";
    BrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[BrowseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    cell.dataDic = dic;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
    
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
     return nil;
}




#pragma mark - 绘制页面
-(void)drawView
{
    backTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KDeviceW, KDeviceH -KNavigationBarHeight) style:UITableViewStyleGrouped];
    backTableView.delegate = self;
    backTableView.dataSource = self;
    backTableView.tableFooterView = [[UIView alloc]init];
    backTableView.rowHeight = 45;
    backTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    backTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backTableView];
    
    
}



@end
