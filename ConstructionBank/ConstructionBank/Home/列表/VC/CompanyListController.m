//
//  CompanyListController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/24.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CompanyListController.h"
#import "CompanyListCell.h"
#import "CompanyListModel.h"
#import "CustomSegmentView.h"


static NSString * CompanyListCellID = @"CompanyListCell";

@interface CompanyListController ()<UITableViewDelegate,UITableViewDataSource,CustomSegmentDelegate>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) CustomSegmentView *segmentView;
@property (nonatomic ,strong) NSMutableArray *datalist;
@end

@implementation CompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    [self loadData];
    // Do any additional setup after loading the view.
}

#pragma mark - loadData
- (void)loadData{
    for (int i = 0; i<5; i++) {
        CompanyListModel *model = [CompanyListModel new];
        model.companyName = @"北京天气制药股份有限公司";
        model.industry = @"房屋建筑工程、市政公用工程、化学生物工程、建筑设计、矿物采集生物设计、市政公用工程、化学生物工程";
        model.city = @"云南";
        model.money = @"6000万人民币";
        model.legalPerson = @"龙海科";
        model.date = @"2018-08-26";
        model.distance = @"350米";
        model.address = @"北京市海淀区清河永泰庄黑泉路九次方大数据";
        
        [self.datalist addObject:model];
    }
    [self.tableview reloadData];
}

#pragma mark - initView
- (void)initView{
    
    self.segmentView = ({
        CustomSegmentView *view = [[CustomSegmentView alloc]initWithFrame:KFrame(0, 20, KDeviceW, 44) titleArray:@[@"新增企业",@"目标客户",@"正式客户"]];
        view.delegate = self;
        [self.view addSubview:view];
        view;
    });
    
    self.tableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(_segmentView.mas_bottom);
        }];
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 300;
        view;
    });
    
}

#pragma mark - delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
//去除navi与table之间的空白
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 这是对应 尾视图
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datalist.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:CompanyListCellID];
    if (!cell) {
        cell = [[CompanyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CompanyListCellID];
    }
    [cell setModel:_datalist[indexPath.section]];
    return cell;
}

#pragma mark - 切换用户类型CustomSegmentDelegate
- (void)segmentDidSelectIndex:(NSInteger)index{
    NSLog(@"点击%d",(int)index);
}

#pragma mark - lazyLoad
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
