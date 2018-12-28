//
//  AnalysisBaseCell.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/20.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnalysisBaseCell.h"

@implementation AnalysisBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.placeHolderView = [[PlaceHolderView alloc]initWithFrame:KFrame(0, 0, self.width, self.height)];
        self.placeHolderView.hidden = YES;
        [self.contentView addSubview:self.placeHolderView];
        
    }
    return self;
}

-(void)layoutSubviews
{
    self.placeHolderView.frame = KFrame(0, 0, self.width, self.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
