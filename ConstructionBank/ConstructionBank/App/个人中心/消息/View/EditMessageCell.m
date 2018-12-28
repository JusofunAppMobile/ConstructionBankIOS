//
//  EditMessageCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/5.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "EditMessageCell.h"
#import "UITextView+Placeholder.h"

@interface EditMessageCell ()

@end

@implementation EditMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.msgView = ({
            UITextView *view = [UITextView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.height.mas_equalTo(114);
            }];
            view.font = KFont(14);
            view.placeholder = @"请点击编辑您的消息";
            view;
        });
    }
    return self;
}

@end
