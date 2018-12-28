//
//  SelectClientController.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "SelectClientController.h"
#import "SelectClientCell.h"
#import "SelectClientHeader.h"
#import "SearchView.h"
#import "MessagePreviewController.h"
#import "SearchClientModel.h"
#import "MessagePreviewController.h"
#import "NoDataView.h"
#import "PushMessageController.h"

static NSString *CellID = @"SelectClientCell";


@interface SelectClientController ()<UITableViewDelegate,UITableViewDataSource,SearchViewDelegate,SelectClientHeaderDelegate>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) SelectClientHeader *header;
@property (nonatomic ,strong) SearchView *searchView;
@property (nonatomic ,strong) NSArray *datalist;
@property (nonatomic ,strong) NSMutableDictionary *addlist;
@property (nonatomic ,strong) NoDataView *noDataView;
@end

@implementation SelectClientController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"接收对象"];
    [self setBackBtn:@"back"];
    [self initView];
    [self didClickSearchButton:@""];
}

- (void)initView{
    
    self.searchView = ({
        SearchView *view = [SearchView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(60);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view;
    });
    
    self.tableview = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(60);
            make.bottom.mas_equalTo(self.view).offset(-80);
            make.left.right.mas_equalTo(self.view);
        }];
        view.tableFooterView = [UIView new];
        view.delegate = self;
        view.dataSource = self;
        view;
    });
    
    UIButton *previewBtn = [UIButton new];
    [previewBtn.titleLabel setFont:KFont(15)];
    [previewBtn setTitle:@"预览" forState: UIControlStateNormal];
    [previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [previewBtn setBackgroundImage:KImageName(@"预览") forState:UIControlStateNormal];
    [previewBtn addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewBtn];
    [previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(-20);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    
    UIButton *commitBtn = [UIButton new];
    [commitBtn.titleLabel setFont:KFont(15)];
    [commitBtn setTitle:@"提交" forState: UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:KImageName(@"提交按钮") forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(20);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return _datalist.count?self.header:nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  _datalist.count ? 33:CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectClientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[SelectClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellID];
    }
    cell.model = _datalist[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchClientModel *model = _datalist[indexPath.row];
    model.selected = !model.selected;
    [_tableview reloadData];
    if (model.selected) {
        [self.addlist setObject:model forKey:model.entid];
    }else{
        [self.addlist removeObjectForKey:model.entid];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchView endEditing:YES];
}

#pragma mark - 提交 预览
- (void)previewAction{
    MessagePreviewController *vc = [MessagePreviewController new];
    vc.clientlist = [_addlist allValues];
    vc.message = _message;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commitAction{
    if (!_addlist.allKeys.count) {
        [MBProgressHUD showHint:@"接收对象不能为空!" toView:nil];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:[self serializeModelKeys:[_addlist allKeys]] forKey:@"companyId"];
    [params setObject:_message forKey:@"message"];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KPushMessage parameters:params isJSONRequest:YES success:^(id responseObject) {
        if ([responseObject[@"result"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"已发送" toView:nil];
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
- (NSString *)serializeModelKeys:(NSArray *)entIds{
    NSMutableString *str = [NSMutableString string];
    for (NSString *eid in entIds) {
        [str appendString:eid];
        if (eid!=[entIds lastObject]) {
            [str appendString:@","];
        }
    }
    return str;
}

#pragma mark - SearchViewDelegate
- (void)didClickSearchButton:(NSString *)searchText{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KUSER.userID forKey:@"userId"];
    [params setObject:searchText forKey:@"name"];

    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KSearchMessageClient parameters:params isJSONRequest:NO success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];

        if ([responseObject[@"result"] intValue] == 0) {
            self.datalist = [SearchClientModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            [_tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
        self.noDataView.hidden = _datalist.count;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"哎呀，服务器开小差啦，请您稍等，马上回来~" toView:self.view];
    }];
}

#pragma mark - SelectClientHeaderDelegate
- (void)didClickSelectAllButton:(BOOL)selected{
    if (selected) {
        for (int i = 0; i < self.datalist.count; i++) {
            SearchClientModel *model = _datalist[i];
            model.selected = YES;
            [self.addlist setObject:model forKey:model.entid];
        }
    }else{
        [self.datalist enumerateObjectsUsingBlock:^(SearchClientModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.selected = NO;
        }];
        [self.addlist removeAllObjects];
    }
    [_tableview reloadData];

}

#pragma mark - lazy load
- (SelectClientHeader *)header{
    if (!_header) {
        _header = [[SelectClientHeader alloc]initWithFrame:KFrame(0, 0, KDeviceW, 33)];
        _header.delegate = self;
    }
    return _header;
}

- (NoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[NoDataView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH-KNavigationBarHeight-60-60)];
        [_tableview addSubview:_noDataView];
    }
    return _noDataView;
}


- (NSMutableDictionary *)addlist{
    if (!_addlist) {
        _addlist = [NSMutableDictionary dictionary];
    }
    return _addlist;
}


@end
