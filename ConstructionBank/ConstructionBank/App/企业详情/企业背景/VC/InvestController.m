//
//  InvestController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "InvestController.h"
#import "CompanyDetailController.h"
@interface InvestController ()
{
    AnimalTableView *_animalTableView;
    int pageIndex;
    NSMutableArray *_investDataArray;//分支机构和对外投资数组
}

@end

@implementation InvestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    pageIndex = 1;
    _investDataArray = [NSMutableArray arrayWithCapacity:1];
    
    [self createTableView];
    
    [self loadData];
}

-(void)abnormalViewReload
{
    [self loadData];
}

-(void)loadData
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@"1" forKey:@"type"];
    [paraDic setObject:self.companyId forKey:@"entid"];
    [paraDic setObject:self.companyName forKey:@"entname"];
    [paraDic setObject:@"20" forKey:@"pagesize"];
    [paraDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
    [paraDic setObject:KUSER.userID forKey:@"userid"];
    NSString* urlstr = [GetEntBranchOrInvesment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [RequestManager getWithURLString:urlstr parameters:paraDic isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            
            BranchOrInvesmentModel *invesmentModel = [BranchOrInvesmentModel mj_objectWithKeyValues:responseObject];
            [_animalTableView.tableView.mj_header endRefreshing];
            [_animalTableView.tableView.mj_footer endRefreshing];
            if(![invesmentModel.ismore isEqualToString:@"true"])
            {
                [_animalTableView.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if ( pageIndex == 1)
            {
                [_investDataArray removeAllObjects];
            }
            [_investDataArray addObjectsFromArray:invesmentModel.list];
            //如果是头部刷新，在头部刷新里会再次将页码重置为1，头部刷新加载的也将会是第一页
            //在此将页码增加是因为在第一次头部刷新之后，再进行尾部刷新是加载的是第二页
            pageIndex ++ ;
            [_animalTableView.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
   

}

#pragma mark - 对外投资和分支机构
-(void)createTableView
{
    _animalTableView = [[AnimalTableView alloc] init];
    _animalTableView.tableView.backgroundColor = [UIColor redColor];
    _animalTableView.dataArray = _investDataArray;
    _animalTableView.tableView.frame = CGRectMake(0, 0, KDeviceW, KDeviceH);
    _animalTableView.view.backgroundColor =  KHexRGB(0xf2f3f5);
    [self.view addSubview:_animalTableView.view];
    _animalTableView.tableView.tableFooterView = [[UIView alloc] init];
    __weak typeof(self) weakSelf = self;
    
    __block AnimalTableView *blockTableView = _animalTableView;
    [_animalTableView setNumberOfRowsInSectionCompletion:^NSInteger(NSInteger section) {
        return  blockTableView.dataArray.count;
    }];
    [_animalTableView setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *Identity = @"InvestCell";
        BranchOrInvesmentCell *cell = [tableView dequeueReusableCellWithIdentifier:Identity];
        if (cell == nil) {
            cell = [[BranchOrInvesmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identity];
        }
        CompanyDetailModel *comModel = [CompanyDetailModel mj_objectWithKeyValues:[blockTableView.dataArray objectAtIndex:indexPath.row]] ;
        cell.companyState.hidden = YES;
        
        
        CGFloat height = [cell heightForCellWithText:comModel];
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = height;
        cell.frame = cellFrame;
        
        return cell;
    }];
    [_animalTableView setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        
        BranchOrInvesmentCell *cell = (BranchOrInvesmentCell *)[blockTableView tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }];
    [_animalTableView setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        CompanyDetailModel *comModel = [CompanyDetailModel mj_objectWithKeyValues:[blockTableView.dataArray objectAtIndex:indexPath.row]] ;
        CompanyDetailController *comView = [[CompanyDetailController alloc] init];
        comView.companyId = comModel.companyid;
        comView.companyName = comModel.companyname;
        [weakSelf.navigationController pushViewController:comView animated:YES];
    }];
    [_animalTableView setViewForFootInSection:^UIView *(NSInteger section) {
        UIView *view = [[UIView alloc] init];
        return view;
    }];
    _animalTableView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [weakSelf loadData];
    }];
    _animalTableView.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
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
