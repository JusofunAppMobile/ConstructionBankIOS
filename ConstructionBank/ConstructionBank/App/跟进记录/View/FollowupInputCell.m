//
//  FollowupInputCell.m
//  ConstructionBank
//
//  Created by wzh on 2018/12/23.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "FollowupInputCell.h"
#import "UITextView+Placeholder.h"
@interface FollowupInputCell ()<UITextViewDelegate>
@property (nonatomic ,strong) UITextView *remarkView;
@property (nonatomic ,strong) NSMutableDictionary *contentDic;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@end
@implementation FollowupInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.remarkView = ({
            UITextView *view = [UITextView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
            }];
            view.font = KFont(14);
            view.delegate = self;
            view;
        });
    }
    return self;
}

- (void)setContent:(NSMutableDictionary *)content atIndexPath:(NSIndexPath *)indexPath{
    _contentDic = content;
    _indexPath = indexPath;
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            _remarkView.placeholder = @"请输入客户需求";//test
            _remarkView.text = _contentDic[@"demand"];
        }else{
            _remarkView.placeholder = @"请输入客户建议";//test
            _remarkView.text = _contentDic[@"suggest"];
        }
    }else{
        _remarkView.placeholder = @"填写需要领导做什么支持，帮助解决什么问题";
        _remarkView.text = _contentDic[@"support"];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_indexPath.section == 2) {
        if (_indexPath.row == 0) {
            _contentDic[@"demand"] = _remarkView.text?:@"" ;
        }else{
            _contentDic[@"suggest"] = _remarkView.text?:@"";
        }
    }else{
        _contentDic[@"support"] = _remarkView.text?:@"";
    }
}
@end
