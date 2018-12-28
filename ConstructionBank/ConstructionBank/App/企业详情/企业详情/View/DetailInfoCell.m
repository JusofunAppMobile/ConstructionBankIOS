//
//  DetailInfoCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DetailInfoCell.h"

//#define KBtnWidth backView.width/3.0-20

@implementation DetailInfoCell
{
    UIView *backView;
    UIView *moveView;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        self.backgroundColor = [UIColor clearColor];
        
        backView = [[UIView alloc]initWithFrame:KFrame(15, 10, KDeviceW-30, 100)];
        backView.backgroundColor = [UIColor whiteColor];
        //[backView jm_setCornerRadius:5 withBackgroundColor:[UIColor whiteColor]];
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        [self.contentView addSubview:backView];
        
        
        [backView addSubview:self.nameLabel];
        
        moveView = [[UIView alloc]initWithFrame:KFrame(0, _nameLabel.maxY, backView.width, 100)];
        
        moveView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:moveView];
        
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = KFrame(moveView.width - 15-120, 5, 120, 15);
        [_attentionBtn setImage:KImageName(@"浏览icon") forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"(--)" forState:UIControlStateNormal];
        _attentionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _attentionBtn.titleLabel.font = KFont(12);
        [_attentionBtn setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
        [moveView addSubview:_attentionBtn];
        
        [moveView addSubview:self.natureLabel];
        
        _dutyLabel = [[UILabel alloc]initWithFrame:KFrame(_natureLabel.x, _natureLabel.maxY+5,backView.width - 2*_natureLabel.x, 15)];
        _dutyLabel.text = @"--";
        _dutyLabel.font = KFont(12);
        _dutyLabel.textColor = KHexRGB(0x999999);
        [moveView addSubview:_dutyLabel];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:KFrame(15, _dutyLabel.maxY + 14.5,backView.width - 30, 0.5)];
        lineView.backgroundColor = KHexRGB(0xebebeb);
        [moveView addSubview:lineView];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(15, lineView.maxY +15, 75, 15)];
        label.text = @"法定代表人:";
        label.textColor = KHexRGB(0x999999);
        label.font = KFont(13);
        [moveView addSubview:label];
        
        
        _pepleLabel = [[UILabel alloc]initWithFrame:KFrame(label.maxX, label.y, backView.width/2 -label.width -15 -15, 15)];
        _pepleLabel.text = @"--";
        _pepleLabel.font = KBlodFont(15);
        _pepleLabel.textColor = KHexRGB(0x1E9EFB);
        [moveView addSubview:_pepleLabel];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:KFrame(backView.width/2.0-5, label.y, 60, 15)];
        label2.text = @"成立日期:";
        label2.textColor = KHexRGB(0x999999);
        label2.font = KFont(13);
        [moveView addSubview:label2];
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:KFrame(label2.maxX, label.y, backView.width/2.0-label2.width -5, 15)];
        _dateLabel.text = @"--";
        _dateLabel.font = KBlodFont(13);
        _dateLabel.textColor = KHexRGB(0x333333);
        [moveView addSubview:_dateLabel];
        
        
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:KFrame(15, label.maxY +15, 60, 15)];
        label3.text = @"注册资金:";
        label3.textColor = KHexRGB(0x999999);
        label3.font = KFont(13);
        [moveView addSubview:label3];
        
        
        _moneyLabel = [[UILabel alloc]initWithFrame:KFrame(label3.maxX, label3.y, backView.width - label3.maxX - 15, 15)];
        _moneyLabel.text = @"--";
        _moneyLabel.font = KBlodFont(13);
        _moneyLabel.textColor = KHexRGB(0x333333);
        [moveView addSubview:_moneyLabel];
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:KFrame(15, label3.maxY +15, 60, 15)];
        label4.text = @"登记状态:";
        label4.textColor = KHexRGB(0x999999);
        label4.font = KFont(13);
        [moveView addSubview:label4];
        
        
        _stateLabel = [[UILabel alloc]initWithFrame:KFrame(label4.maxX, label4.y - 3, backView.width - label4.maxX - 15, 20)];
        _stateLabel.text = @"--";
        _stateLabel.font = KBlodFont(12);
        _stateLabel.textColor = KHexRGB(0x1E9EFB);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [moveView addSubview:_stateLabel];
        
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.frame = KFrame(0, _stateLabel.maxY + 15, moveView.width, 35);
        _refreshBtn.backgroundColor = KRGB(255, 246, 239);
        [_refreshBtn setImage:KImageName(@"更新icon") forState:UIControlStateNormal];
        [_refreshBtn setTitle:@"  --" forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = KFont(12);
        [_refreshBtn setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
        [moveView addSubview:_refreshBtn];
        
        [self reloadFrame];
        
        
    }
    
    return self;
}




-(void)setDetailModel:(CompanyDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    NSString *str = detailModel.companyname;
    
    CGFloat hight = [Tools getHeightWithString:str fontSize:16 maxWidth:backView.width - 30];
    
    CGRect frame = _nameLabel.frame;
    frame.size.height = hight >15?hight :15;
    _nameLabel.frame = frame;
 
    _nameLabel.text = str;

    _stateLabel.text = detailModel.states;
    if(![detailModel.states isEqualToString:@"未公布"] || ![detailModel.states isEqualToString:@"--"])
    {
        
        CGFloat width = [Tools getWidthWithString:detailModel.states fontSize:12 maxHeight:15];
        
        CGRect frame = _stateLabel.frame;
        frame.size.width = width +10 ;
        _stateLabel.frame = frame;
        
        _stateLabel.layer.borderColor = KHexRGB(0x1E9EFB).CGColor;
        _stateLabel.layer.borderWidth = 1;
        _stateLabel.layer.cornerRadius = 5;
        
    }
    else
    {
        
        _stateLabel.layer.borderWidth = 0;
        _stateLabel.layer.cornerRadius = 0;
    }
    
    _natureLabel.text = detailModel.companynature;
    _dutyLabel.text = detailModel.taxid;
    _pepleLabel.text = detailModel.corporate;
    _moneyLabel.text = detailModel.registercapital;
    _dateLabel.text = detailModel.cratedate;
    [_refreshBtn setTitle:[NSString stringWithFormat:@"  %@",detailModel.updatestate]  forState:UIControlStateNormal];
    
    [_attentionBtn setTitle:[NSString stringWithFormat:@"  (%@)",detailModel.browsecount]  forState:UIControlStateNormal];
    
    [self reloadFrame];
}


-(void)reloadFrame
{
//    _pepleLabel.frame = KFrame(10, _natureLabel.maxY+30, KBtnWidth, 15);
//    _moneyLabel.frame = KFrame(_pepleLabel.maxX+20, _pepleLabel.y, KBtnWidth, 15);
//    _dateLabel.frame = KFrame(_moneyLabel.maxX+20, _pepleLabel.y, KBtnWidth, 15);
//    _likeBtn.frame = KFrame(10, _pepleLabel.maxY + 40, KBtnWidth, 50);
//    _attentionBtn.frame = KFrame(_likeBtn.maxX +20, _likeBtn.y, _likeBtn.width, _likeBtn.height);
//    _refreshBtn.frame = KFrame(_attentionBtn.maxX +20, _likeBtn.y, _likeBtn.width, _likeBtn.height);
    
    CGRect frame = moveView.frame;
    frame.origin.y = _nameLabel.maxY;
    frame.size.height = _refreshBtn.maxY ;
    moveView.frame = frame;
    
    
    CGRect frame2 = backView.frame;
    frame2.size.height = moveView.maxY;
    backView.frame = frame2;
    
    CGRect frame3 = self.frame;
    frame3.size.height = backView.maxY + 10;
    self.frame = frame3;
    
    
}

-(UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:KFrame(15, 15,backView.width - 30, 40)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = KFont(16);
        
    }
    
    return _nameLabel;
}


-(UILabel *)natureLabel
{
    if(!_natureLabel)
    {
        _natureLabel = [[UILabel alloc]initWithFrame:KFrame(15, 5,backView.width - 30 - 15 - _attentionBtn.width , 15)];
        _natureLabel.text = @"--";
        _natureLabel.font = KFont(12);
        _natureLabel.textColor = KHexRGB(0x999999);
        
        
    }
    return _natureLabel;
}






@end
