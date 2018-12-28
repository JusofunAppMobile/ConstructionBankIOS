
//
//  EditMessageController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "EditMessageController.h"
#import "EditMessageHeader.h"
#import "HistoryMsgCell.h"
#import "EditMessageCell.h"
#import "MsgListModel.h"
#import "SelectClientController.h"
#import "PushMessageController.h"

static NSString *EditCellID = @"EditMessageCell";
static NSString *HistoryCellID = @"HistoryMsgCell";

@interface EditMessageController ()<UITableViewDataSource,UITableViewDelegate,HistoryCellDelegate>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) UITextView *editTextView;
@property (nonatomic ,strong) UIButton *commitBtn;

@end

@implementation EditMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"消息编辑"];
    [self setBackBtn:@"back"];

    [self initView];
}

#pragma mark - initView
- (void)initView{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 80, 0));
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
}


#pragma mark - unity
- (void)setHistoryArray:(NSArray *)historyArray{
    _historyArray = historyArray;
    [self.tableview reloadData];
}

- (void)setPushMessageType:(PushMessageType)pushMessageType{
    _pushMessageType = pushMessageType;
    [self.commitBtn setTitle:_pushMessageType == PushMessagemoreType?@"下一步":@"推送" forState: UIControlStateNormal];
}

#pragma mark - UITableivewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EditMessageHeader *view = [[EditMessageHeader alloc]initWithFrame:KFrame(0, 0, KDeviceW, 56)];
    view.section = section;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?56:66;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:_historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        EditMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:EditCellID forIndexPath:indexPath];
        self.editTextView = cell.msgView ;
        return cell;
    }else{
        HistoryMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = _historyArray[indexPath.row];
        return cell;
    }
}

#pragma mark - 复制消息 HistoryCellDelegate
- (void)didClickCopyButton:(NSString *)text{
    _editTextView.text = text;
}

#pragma mark - 推送消息
- (void)pushAction{
    if (!_editTextView.text.length) {
        [MBProgressHUD showHint:@"请输入消息内容！" toView:nil];
        return;
    }
    
    if (_pushMessageType == PushMessagemoreType) {
        SelectClientController *vc = [SelectClientController new];
        vc.message = _editTextView.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self commitAction];
    }
}

- (void)commitAction{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:_companyId forKey:@"companyId"];
    [params setObject:_editTextView.text forKey:@"message"];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KPushMessage parameters:params isJSONRequest:YES success:^(id responseObject) {
        if ([responseObject[@"result"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"已发送" toView:self.view];
            [self backToMessageList];
        }else{
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

- (void)backToMessageList{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PushMessageController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            [KNotificationCenter postNotificationName:KPushMessageSuccessNoti object:nil];
        }
    }
}

#pragma mark - 收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_editTextView resignFirstResponder];
}

#pragma mark - lazy load
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = ({
            UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            [self.view addSubview:view];
            view.delegate = self;
            view.dataSource = self;
            view.backgroundColor = [UIColor whiteColor];
            view.rowHeight = UITableViewAutomaticDimension;
            view.estimatedRowHeight = 130;
            view.separatorStyle = UITableViewCellSeparatorStyleNone;
            [view registerClass:[EditMessageCell class] forCellReuseIdentifier:EditCellID];
            [view registerClass:[HistoryMsgCell class] forCellReuseIdentifier:HistoryCellID];
            view;
        });
    }
    return _tableview;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        [_commitBtn.titleLabel setFont:KFont(15)];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:KImageName(@"按钮背景") forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_commitBtn];
    }
    return _commitBtn;
}


@end
