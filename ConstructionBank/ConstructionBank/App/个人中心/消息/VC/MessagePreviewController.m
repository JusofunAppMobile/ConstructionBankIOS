//
//  MessagePreviewController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MessagePreviewController.h"
#import "PreviewMsgCell.h"
#import "PreviewHeader.h"
#import "SearchClientModel.h"
#import "NSDate+ZJPickerView.h"
#import "PushMessageController.h"

static NSString *CellID1 = @"PreviewMsgCell";
static NSString *CellID2 = @"PreviewNormalCell";


@interface MessagePreviewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableview;
@end

@implementation MessagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"预览"];
    [self setBackBtn:@"back"];
    [self initView];
}

- (void)initView{
    self.tableview = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 80, 0));
        }];
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = UITableViewAutomaticDimension;
        view.estimatedRowHeight = 90;
        view.tableFooterView = [UIView new];
        view;
    });
    
    
    UIButton *commitBtn = [UIButton new];
    [commitBtn.titleLabel setFont:KFont(15)];
    [commitBtn setTitle:@"提交" forState: UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:KImageName(@"按钮背景") forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PreviewHeader *header = [[PreviewHeader alloc]initWithFrame:KFrame(0, 0, KDeviceW, 33)];
    header.section = section;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section == 0? 1:_clientlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        PreviewMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID1];
        if (!cell) {
            cell = [[PreviewMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellID1];
        }
        cell.text = _message;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID2];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID2];
            cell.textLabel.font = KFont(16);
            cell.textLabel.textColor = KHexRGB(0x333333);
        }
        SearchClientModel *model = _clientlist[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
   
}

#pragma mark - 提交
- (void)commitAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    if (_clientlist.count) {
        [params setObject:[self serializeModels:_clientlist] forKey:@"companyId"];
    }
    [params setObject:_message forKey:@"message"];
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

//添加逗号字符串
- (NSString *)serializeModels:(NSArray *)models{
    NSMutableString *str = [NSMutableString string];
    for (SearchClientModel *model in models) {
        [str appendString:model.entid];
        if (model != [_clientlist lastObject]) {
            [str appendString:@","];
        }
    }
    return str;
}


@end
