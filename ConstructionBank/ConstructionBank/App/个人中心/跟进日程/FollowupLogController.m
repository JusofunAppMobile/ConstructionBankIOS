//
//  FollowupLogController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/12/10.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowupLogController.h"
#import "GFCalendar.h"
#import "GFCalendarView.h"
#import "FollowupLogCell.h"
#import "FollowupLogNormalCell.h"
#import "AddFollowUpLogController.h"
#import "CalendarMonthModel.h"
#import "FollowupNoDataView.h"
#import "FollowRecordModel.h"
#import "SendReportAlert.h"
#import "DatePickerView.h"
#import <IQKeyboardManager.h>

@interface FollowupLogController ()<UITableViewDelegate,UITableViewDataSource,FollowupLogCellDelegate,SendReportDelegate>
@property (nonatomic ,strong) GFCalendarView *calendarView;
@property (nonatomic, copy) NSString *date;
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) NSMutableArray *expandArr;
@property (nonatomic ,strong) NSArray *datalist;
@property (nonatomic ,strong) NSArray *datelist;
@property (nonatomic ,strong) FollowupNoDataView *noDataView;
@property (nonatomic ,assign) BOOL isLoad;
@property (nonatomic ,strong) SendReportAlert *sendAlert;

@end

@implementation FollowupLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    [KNotificationCenter addObserver:self selector:@selector(reloadAction) name:KAddFollowUpRecordNoti object:nil];

    [self setNavigationBarTitle:@"跟进日程表"];
    [self setBackBtn:@"back"];
    [self setRightNaviBtn];
    [self initView];
    [self loadData];
}

#pragma mark - initView
- (void)initView{
    [[IQKeyboardManager sharedManager]setKeyboardDistanceFromTextField:60];

    KWeakSelf
    _calendarView = [[GFCalendarView alloc] initWithFrameOrigin:CGPointMake(0, 0) width:KDeviceW];
    [self.view addSubview:_calendarView];
    _calendarView.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day ,CalendarDayModel *model) {
        if (model.day) {
            [weakSelf loadFollowListForDate:model.day];
        }else{
            weakSelf.noDataView.hidden = NO;
        }
    };
    
    self.tableview = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_calendarView.mas_bottom);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
        view.delegate = self;
        view.dataSource = self;
        view.tableFooterView = [UIView new];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view;
    });
    
    [self loadFollowListForDate:_calendarView.calendarScrollView.selectedDay ];
}

- (void)setRightNaviBtn{
    NSMutableArray *items = [NSMutableArray array];
    if (KIosVersion<11.0) {
        UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                          target:nil action:nil];
        negativeSpace.width = -13;
        [items addObject:negativeSpace];
    }
    UIButton *msgBtn = [[UIButton alloc]initWithFrame:KFrame(0, 0, 44, 44)];
    [msgBtn setImage:KImageName(@"fasong") forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc]initWithCustomView:msgBtn];
    [items addObject:msgItem];
    self.navigationItem.rightBarButtonItems = items;
}


#pragma mark - load data
- (void)loadData{
    [MBProgressHUD showMessag:@"" toView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [RequestManager requestWithURLString:KGetFollowRecordByCalendar parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] intValue] == 0) {
            self.datelist = [CalendarMonthModel mj_objectArrayWithKeyValuesArray:responseObject[@"datelist"]];
            self.calendarView.datelist = self.datelist;
        } else {
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

//选中日历
- (void)loadFollowListForDate:(NSString *)day{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:day forKey:@"date"];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager requestWithURLString:KGetFollowRecordForDay parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] intValue] == 0) {
            self.datalist = [FollowRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.noDataView.hidden = self.datalist.count;
            [self setupCellExpandSate];
            [self.tableview reloadData];
        } else {
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}
//初始化cell展开 收起状态
- (void)setupCellExpandSate{
    [self.expandArr removeAllObjects];
    for (int i = 0; i<_datalist.count; i++) {
        if (i == 0) {
            [self.expandArr addObject:@1];
        }else{
            [self.expandArr addObject:@0];
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL expand = [_expandArr[indexPath.row] boolValue];
    if(expand){
        return 209+10;
    }
    return 56+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL expand = [_expandArr[indexPath.row] boolValue];
    if (expand) {
        static NSString *CellID = @"FollowupLogCell";
        FollowupLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[FollowupLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        [cell setModel:_datalist[indexPath.row] atIndex:indexPath];
        return cell;
    }else{
        static NSString *CellID = @"FollowupLogNormalCell";
        FollowupLogNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[FollowupLogNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _datalist[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL expand = [_expandArr[indexPath.row] boolValue];
    if (!expand) {
        [self setupExpandArr:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        FollowRecordModel *model = _datalist[indexPath.row];
        AddFollowUpLogController *vc = [AddFollowUpLogController new];
        vc.companyid = model.companyid;
        vc.recordModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupExpandArr:(NSIndexPath *)indexPath{
    BOOL expand = [_expandArr[indexPath.row] boolValue];
    if (expand) {
        [self.expandArr replaceObjectAtIndex:indexPath.row withObject:@0];
    }else{
        [self.expandArr replaceObjectAtIndex:indexPath.row withObject:@1];
    }
}

#pragma mark - delegate
- (void)didClickClose:(NSIndexPath *)indexPath{
    [self setupExpandArr:indexPath];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)jumpToEditVc:(FollowRecordModel *)model{
    AddFollowUpLogController *vc = [AddFollowUpLogController new];
    vc.companyid = model.companyid;
    vc.recordModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 发生报告
- (void)sendAction{
    [self.sendAlert showInView:self.navigationController.view];
}

#pragma mark - SendReportDelegate 报告弹窗
- (void)textFieldDidSelectAtIndex:(NSInteger)index{
    KWeakSelf
    [DatePickerView showDatePickerWithTitle:@"请选择日期" minDate:nil maxDate:nil resultBlock:^(NSString * _Nonnull selectValue) {
        if (index == 0) {
            weakSelf.sendAlert.startField.text = selectValue;
        }else{
            weakSelf.sendAlert.endField.text = selectValue;
        }
    } cancelBlock:^{
    }];
}

//发送报告
- (void)sendReportAction:(NSDictionary *)params{
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager requestWithURLString:KSendReport parameters:params type:HttpRequestTypePost isJSONRequest:NO success:^(id responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

#pragma mark - 通知
- (void)reloadAction{
    [self loadFollowListForDate:_calendarView.calendarScrollView.selectedDay];
}

#pragma mark - lazy load
- (SendReportAlert *)sendAlert{
    if (!_sendAlert) {
        _sendAlert = [[SendReportAlert alloc]initWithFrame:KeyWindow.bounds];
        _sendAlert.delegate = self;
    }
    return _sendAlert;
}

- (FollowupNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[FollowupNoDataView alloc]initWithFrame:self.tableview.bounds];
        _noDataView.hidden = YES;
        [self.tableview addSubview:_noDataView];
    }
    return _noDataView;
}

- (NSMutableArray *)expandArr{
    if (!_expandArr) {
        _expandArr = [NSMutableArray array];
    }
    return _expandArr;
}

- (void)dealloc{
    [KNotificationCenter removeObserver:self name:KAddFollowUpRecordNoti object:nil];
}
@end
