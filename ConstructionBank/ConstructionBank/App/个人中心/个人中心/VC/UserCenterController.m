//
//  UserCenterController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "UserCenterController.h"
#import "UserCenterCell.h"
#import "UserCenterFooterView.h"
#import "UserHeaderView.h"
#import "MyClientViewController.h"
#import "PushMessageController.h"
#import "FollowupLogController.h"

@interface UserCenterController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSArray *imageArray;
}
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) UserHeaderView *header;
@property (nonatomic ,strong) UserCenterFooterView *footer;

@end

@implementation UserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = @[@[@"客户管理",@"我的客户",@"客户跟进日程表"],@[@"产品营销"],@[@"工作汇报"],@[@"关于"]];
    imageArray = @[@[@"kehuguanli",@"",@""],@[@"chanpinyingxiao"],@[@"gongzuohuibao"],@[@"guanyu"]];
    
    [self initView];
    [self setNavigationBarTitle:@"个人中心"];
     [_header reloadInfo];
}

#pragma mark - initView
- (void)initView{
    self.tableview = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        [view layoutIfNeeded];//防止header约束width为0导致约束冲突
        view.delegate = self;
        view.dataSource = self;
        view.tableFooterView = self.footer;
        view.tableHeaderView = self.header;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view;
    });
}

#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [titleArray objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"UserCenterCell";
    UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UserCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 0&&indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSArray *array = [titleArray objectAtIndex:indexPath.section];
    cell.titleLab.text = [array objectAtIndex:indexPath.row];;
    NSArray *array2 = [imageArray objectAtIndex:indexPath.section];
    cell.iconView.image = KImageName([array2 objectAtIndex:indexPath.row]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 1)
        {
            MyClientViewController *vc = [[MyClientViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2)
        {
            FollowupLogController *vc = [FollowupLogController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        PushMessageController *vc = [[PushMessageController alloc]init];
        vc.pushMessageType = PushMessagemoreType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2)
    {
        AnalysisController*vc = [[AnalysisController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *kongView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 10)];
    kongView.backgroundColor = KRGB(240, 240, 246);
    return kongView;
}

#pragma mark - lazy load
- (UserHeaderView *)header{
    if (!_header) {
        _header = [[UserHeaderView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 95)];
    }
    return _header;
}

- (UserCenterFooterView *)footer{
    if (!_footer) {
        _footer = [[UserCenterFooterView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 90)];
    }
    return _footer;
}




@end
