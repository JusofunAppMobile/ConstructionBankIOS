//
//  AddFollowUpLogRemarkCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/3.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AddFollowUpLogRemarkCell.h"
#import "UITextView+Placeholder.h"

@interface AddFollowUpLogRemarkCell ()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *remarkView;
@end

@implementation AddFollowUpLogRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.remarkView = ({
            UITextView *view = [UITextView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
            }];
            view.font = KFont(14);
            view.placeholder = @"请输入备注";
            view.delegate = self;
            view;
        });

    }
    return self;
}

- (void)setModel:(ClientModel *)model{
    _model = model;
    _remarkView.text = model.remark;
}

- (void)textViewDidChange:(UITextView *)textView{
    _model.remark = textView.text?:@"";
}



@end
