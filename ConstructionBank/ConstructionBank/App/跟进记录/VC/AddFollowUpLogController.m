//
//  AddFollowUpLogController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/31.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AddFollowUpLogController.h"
#import "AddFollowUpLogCell.h"
#import "AddFollowUpLogRemarkCell.h"
#import "AddFollowUpLogInfoCell.h"
#import "AddFollowUPLogHeader.h"
#import "MapSelectController.h"
#import "ZJDatePickerView.h"
#import "CustomPickerView.h"
#import "ClientModel.h"
//#import "FollowupCheckCell.h"
#import "FollowupInputCell.h"
#import "AddFollowFooter.h"

static NSString *NormalCellID = @"AddFollowUpLogCell";
static NSString *InfoCellID = @"AddFollowUpLogInfoCell";
static NSString *RemarkCellID = @"AddFollowUpLogRemarkCell";
static NSString *HeaderID= @"AddFollowUpLogRemarkCell";
//static NSString *CheckID= @"FollowupCheckCell";
static NSString *InputID= @"FollowupInputCell";


@interface AddFollowUpLogController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) CustomPickerView *statePicker;
@property (nonatomic ,strong) ClientModel *clientModel;
@property (nonatomic ,strong) NSMutableDictionary *contentDic;

@end

@implementation AddFollowUpLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTitle:@"添加跟进记录"];
    [self setBackBtn:@"back"];
    [self initView];
    [self addAddressObserver];
}

- (void)setRecordModel:(FollowRecordModel *)recordModel{
    _recordModel = recordModel;
    if (_recordModel.time) {
        [self.contentDic setObject:_recordModel.time forKey:@"time"];
    }
    if (_recordModel.address) {
        [self.contentDic setObject:_recordModel.address forKey:@"address"];
    }
    if (_recordModel.detailAddress) {
        [self.contentDic setObject:_recordModel.detailAddress forKey:@"detailAddress"];
    }
    if (_recordModel.demand) {
        [self.contentDic setObject:_recordModel.demand forKey:@"demand"];
    }
    if (_recordModel.suggest) {
        [self.contentDic setObject:_recordModel.suggest forKey:@"suggest"];
    }
    if (_recordModel.support) {
        [self.contentDic setObject:_recordModel.support forKey:@"support"];
    }
    if (_recordModel.isSupportSolved) {
        [self.contentDic setObject:_recordModel.isSupportSolved forKey:@"isSupportSolved"];
    }
    if (_recordModel.isDemandSolved) {
        [self.contentDic setObject:_recordModel.isDemandSolved forKey:@"isDemandSolved"];
    }
    
    if (_recordModel.followState) {
        [self.contentDic setObject:_recordModel.followState forKey:@"followState"];
        if ((_recordModel.followState.intValue - 1) >= 0&&(_recordModel.followState.intValue - 1)<FOLLOWSTATES.count) {
            [self.contentDic setObject:FOLLOWSTATES[_recordModel.followState.intValue - 1] forKey:@"followStateText"];
        }
    }
    
    self.clientModel.name = recordModel.name;
    self.clientModel.job = recordModel.job;
    self.clientModel.phone = recordModel.phone;
    self.clientModel.remark = recordModel.remark;
    self.clientModel.linkPhone = recordModel.linePhone;
}

#pragma mark - initView
- (void)initView{
    self.tableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style: UITableViewStyleGrouped];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 80, 0));
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view.dataSource = self;
        view;
    });
    
    [_tableview registerClass:[AddFollowUpLogCell class] forCellReuseIdentifier:NormalCellID];
    [_tableview registerClass:[AddFollowUpLogInfoCell class] forCellReuseIdentifier:InfoCellID];
    [_tableview registerClass:[AddFollowUpLogRemarkCell class] forCellReuseIdentifier:RemarkCellID];
    [_tableview registerClass:[FollowupInputCell class] forCellReuseIdentifier:InputID];
    
    UIButton *saveBtn = [UIButton new];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    saveBtn.titleLabel.font = KFont(15);
    [saveBtn setTitle:@"保存" forState: UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:KImageName(@"按钮背景") forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 46;
    }else if (indexPath.section == 1){
        return 130;
    }else if (indexPath.section == 2){
        return 120;
    }else if (indexPath.section == 3){
        return 120;
    }else{
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AddFollowUpLogCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellID forIndexPath:indexPath];
        [cell setContent:self.contentDic atRow:indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        AddFollowUpLogInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellID forIndexPath:indexPath];
        [cell setModel:self.clientModel];
        return cell;
    }else if (indexPath.section == 2 ||indexPath.section == 3){
        FollowupInputCell *cell = [tableView dequeueReusableCellWithIdentifier:InputID forIndexPath:indexPath];
        [cell setContent:self.contentDic atIndexPath:indexPath];
        return cell;
    }else{
        AddFollowUpLogRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:RemarkCellID forIndexPath:indexPath];
        [cell setModel:self.clientModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [ZJDatePickerView zj_showDatePickerWithTitle:@"请选择日期" dateModel:ZJDatePickerModelTime defaultSelValue:nil minDate:nil maxDate:nil isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                if (selectValue) {
                    [self.contentDic setObject:selectValue forKey:@"time"];
                    [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } cancelBlock:^{
                
            }];
            
        }else if (indexPath.row == 1){
            MapSelectController *vc = [MapSelectController new];
            vc.resultBlock = ^(NSDictionary *addrInfo){
                if (addrInfo) {
                    [self.contentDic addEntriesFromDictionary:addrInfo];
                    [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else  if (indexPath.row == 3){
            [self.statePicker show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?CGFLOAT_MIN:58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2||section == 3) {
        return 45;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 2||section == 3) {
        AddFollowFooter *view = [[AddFollowFooter alloc]initWithFrame:KFrame(0, 0, KDeviceW, 45)];
        [view setContent:self.contentDic section:section];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    AddFollowUPLogHeader *view = [[AddFollowUPLogHeader alloc]initWithFrame:KFrame(0, 0, KDeviceW, 58)];
    view.section = section;
    return view;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 保存
- (void)saveAction{
    if ([self checkParamsEmpty]) {
        return;
    }
    
    NSDictionary *dic = [_clientModel mj_keyValues];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_recordModel.followId) {//id不为空表示修改记录
        [params setObject:_recordModel.followId forKey:@"followId"];
    }
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:_companyid forKey:@"companyId"];
    [params setObject:@[dic] forKey:@"customer"];
    [params addEntriesFromDictionary:_contentDic];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KAddFollowLog parameters:params isJSONRequest:YES success:^(id responseObject) {
        if ([responseObject[@"result"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"已添加！" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];//返回并 回调刷新
            [KNotificationCenter postNotificationName:KAddFollowUpRecordNoti object:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

- (BOOL)checkParamsEmpty{
    if (!_clientModel.name.length) {
        [MBProgressHUD showHint:@"请输入客户姓名！" toView:self.view];
        return YES;
    }
    if (!_clientModel.job.length) {
        [MBProgressHUD showHint:@"请输入职位！" toView:self.view];
        return YES;
    }
    if (!_clientModel.phone.length) {
        [MBProgressHUD showHint:@"请输入电话！" toView:self.view];
        return YES;
    }
    if (!_contentDic[@"time"]) {
        [MBProgressHUD showHint:@"请选择跟进时间！" toView:self.view];
        return YES;
    }
    if (!_contentDic[@"address"]) {
        [MBProgressHUD showHint:@"请选择跟进地点！" toView:self.view];
        return YES;
    }
    if (!_contentDic[@"followStateText"]) {
        [MBProgressHUD showHint:@"请选择跟进状态！" toView:self.view];
        return YES;
    }
    
    return NO;
}

#pragma mark - 通知
- (void)addAddressObserver{
    [KNotificationCenter addObserver:self selector:@selector(didSelectAddress:) name:KSelectAddressNoti object:nil];
}

- (void)didSelectAddress:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    [self.contentDic addEntriesFromDictionary:dic];
    [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - lazy load
-(CustomPickerView *)statePicker{
    if (!_statePicker) {
        _statePicker = [[CustomPickerView alloc]initWithTitles:FOLLOWSTATES resultBlock:^(NSDictionary *result) {
            if (result) {
                [self.contentDic addEntriesFromDictionary:result];
                NSIndexPath *indexPath= [NSIndexPath indexPathForRow:3 inSection:0];
                [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    return _statePicker;
}

- (NSMutableDictionary *)contentDic{
    if (!_contentDic) {
        _contentDic = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _contentDic;
}

- (ClientModel *)clientModel{
    if (!_clientModel) {
        _clientModel = [ClientModel new];
    }
    return _clientModel;
}

- (void)dealloc{
    [KNotificationCenter removeObserver:self];
}

@end

