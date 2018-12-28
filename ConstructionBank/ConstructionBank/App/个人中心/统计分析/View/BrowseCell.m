//
//  BrowseCell.m
//  ConstructionBank
//
//  Created by WangZhipeng on 2018/12/11.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "BrowseCell.h"

@implementation BrowseCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[UILabel alloc]initWithFrame:KFrame(15, 0, KDeviceW-30-65, self.height)];
        self.nameLabel.textColor = KHexRGB(0x666666);
        self.nameLabel.font = KFont(13);
        [self.contentView addSubview:self.nameLabel];
        
        self.numLabel = [[UILabel alloc]initWithFrame:KFrame(KDeviceW-15-60, 0, 60, self.height)];
        self.numLabel.textColor = KHexRGB(0x666666);
        self.numLabel.font = KFont(13);
        self.numLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.numLabel];
        
        
        
    }
    return self;
}


-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    self.nameLabel.text = [dataDic objectForKey:@"companyname"];
    NSString *string = [NSString stringWithFormat:@"%@次",[dataDic objectForKey:@"count"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KHexRGB(0xF5A623) range:NSMakeRange(0, string.length-1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KRGB(111, 111, 111) range:NSMakeRange(string.length-1, 1)];
    self.numLabel.attributedText = attributedString;
    
    
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
