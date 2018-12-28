//
//  BranchOrInvesmentCell.m
//  EnterpriseInquiry
//
//  Created by clj on 15/11/23.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "BranchOrInvesmentCell.h"

@implementation BranchOrInvesmentCell
{
    //UIImageView *legalImageView;
    UIImageView *comStateImageView;
    UIView *startView;
}
@synthesize legalImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _companyNameLabel = [[UILabel alloc] init];
        _companyNameLabel.textColor = KHexRGB(0x333333);
        _companyNameLabel.font = KNormalFont;
        [self.contentView addSubview:_companyNameLabel];
        
        legalImageView = [[UIImageView alloc] init];
        legalImageView.image = [UIImage imageNamed:@"legal"];
        [self.contentView addSubview:legalImageView];
        
        _legalName = [[UILabel alloc] init];
        _legalName.textColor =  KHexRGB(0x666666);
        _legalName.font = KSmallFont;
        [self.contentView addSubview:_legalName];
        
        comStateImageView = [[UIImageView alloc] init];
        comStateImageView.image = [UIImage imageNamed:@"comState"];
        [self.contentView addSubview:comStateImageView];
        
        _companyState = [[UILabel alloc] init];
        _companyState.textColor = KHexRGB(0x98999b);
        _companyState.font = KSmallFont;
        [self.contentView addSubview:_companyState];
        
        
        startView = [[UIView alloc] init];
        startView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:startView];
        
    }
    return self;
}


-(CGFloat)heightForCellWithText:(CompanyDetailModel *)comModel
{
    _companyNameLabel.text = comModel.companyname;
    _companyNameLabel.frame = CGRectMake(10, 15, KDeviceW - 20, 10);
    _companyNameLabel.numberOfLines = 2;
    [_companyNameLabel sizeToFit];
    
    
    legalImageView.frame = CGRectMake(10, CGRectGetMaxY(_companyNameLabel.frame) + 10, 10, 10);
    _legalName .frame = CGRectMake(CGRectGetMaxX(legalImageView.frame) + 5, legalImageView.frame.origin.y -5,100, 20);
    _legalName.text = [NSString stringWithFormat:@"法人: %@",comModel.legal];
    _legalName.textColor = KHexRGB(0x666666);
    _legalName.font = KSmallFont;
    
    
    comStateImageView.hidden = YES;
    _companyState.frame = CGRectMake(KDeviceW - 200,_legalName.frame.origin.y, KDeviceW - 10 - (KDeviceW - 200), 20);
    _companyState.font = KSmallFont;
    _companyState.textAlignment = NSTextAlignmentRight;
    _companyState.textColor = KHexRGB(0x666666);
    _companyState.text = [NSString stringWithFormat:@"%@",comModel.companystate];
    return CGRectGetMaxY(_companyState.frame) + 15;
    
}

-(void)setHotCompanyCellFrame{
    _legalName.hidden = YES;
     startView.frame = CGRectMake(10 ,_legalName.frame.origin.y  , 15 * 5 + 10, 15);
}





- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
