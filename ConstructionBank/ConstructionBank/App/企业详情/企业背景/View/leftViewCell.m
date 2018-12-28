//
//  leftViewCell.m
//  jusfounData
//
//  Created by clj on 15/10/22.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "leftViewCell.h"

@implementation leftViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
     
//        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
//        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:_nameLabel];
//        
//        _valueLabel = [[UILabel alloc] init];
//        _valueLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
//        _valueLabel.textAlignment = NSTextAlignmentLeft;
//        _valueLabel.textColor = [UIColor whiteColor];
//        _valueLabel.numberOfLines = 0;
//        [self.contentView addSubview:_valueLabel];
        
        CGRect rect = self.textLabel.frame;
        rect.origin.y = 5;
        self.textLabel.frame = rect;
        
        CGRect detaRect = self.detailTextLabel.frame;
        detaRect.origin.y = rect.origin.y;
        detaRect.origin.x = CGRectGetMaxX(rect) + 5;
        self.detailTextLabel.frame = detaRect;
        
    }
    return self;
}


-(void)updataFrameWithName:(NSString *)name andValue:(NSString *)value
{
    _nameLabel.text = name;
    _nameLabel.frame = CGRectMake(10, 5, 20, 20);
    [_nameLabel sizeToFit];
    
    _valueLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame), 5,  self.contentView.frame.size.width -5 , 20);
    _valueLabel.text = value;
    CGSize requiredSize = [self labelAutoCalculateRectWith:value FontSize:18 MaxSize:CGSizeMake(_valueLabel.frame.size.width, CGFLOAT_MAX)];
    
    CGRect textFrame = self.valueLabel.frame;
    textFrame.size = requiredSize;
    self.valueLabel.frame = textFrame;
    
    CGRect frameCell = self.frame;
    frameCell.size.height = requiredSize.height + 20;
    self.frame = frameCell;
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
  //  NSString * str = valueArray[indexPath.row];
    //    leftViewCell *cell = (leftViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGSize nameSize = [self labelAutoCalculateRectWith:self.textLabel.text FontSize:16 MaxSize:CGSizeMake(CGFLOAT_MAX, 20)];
    //    NSLog(@"nameSize   %f,%f",nameSize.width,nameSize.height);
    
    CGSize requiredSize = [self labelAutoCalculateRectWith:self.detailTextLabel.text FontSize:18 MaxSize:CGSizeMake(self.frame.size.width -  20, CGFLOAT_MAX)];
    
    CGRect rect = self.textLabel.frame;
    rect.origin.y = 5;
    rect.origin.x = 10;
    rect.size = nameSize;
    self.textLabel.frame = rect;
    
    
    CGRect detaRect = self.detailTextLabel.frame;
    if (requiredSize.width > (self.frame.size.width - rect.size.width - 20))
    {
        detaRect.origin.y = rect.origin.y + rect.size.height ;
        detaRect.origin.x = 10 ;
    }else
    {
        detaRect.origin.y = rect.origin.y;
        detaRect.origin.x = CGRectGetMaxX(rect) + 5;
    }
    detaRect.size = requiredSize;
    self.detailTextLabel.frame = detaRect;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
