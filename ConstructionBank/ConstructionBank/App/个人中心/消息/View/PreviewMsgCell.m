//
//  PreviewMsgCell.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "PreviewMsgCell.h"

@interface PreviewMsgCell ()
@property (nonatomic ,strong) UILabel *contentLab;
@end

@implementation PreviewMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
            }];
            view.numberOfLines = 0;
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
    }
    return self;
}

- (void)setText:(NSString *)text{
    _contentLab.text  = text;
}

@end
