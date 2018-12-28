//
//  DetailView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/30.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "DetailView.h"
#import <UIButton+WebCache.h>
#import "CompanyDetailInfoCell.h"

#define KFoldBtnTag 89463

@interface DetailView()
{
    UIButton *phoneBtn;

    BOOL isShowPhone;//联系信息
}
@property (nonatomic ,assign) NSInteger companyType;

@end

@implementation DetailView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _companyType = type;
        isShowPhone = NO;
        [self addSubview:self.backTableView];
    }
    return self;
}

#pragma mark - 点击

-(void)gridButtonClick:(GridButton *)button cellSection:(int)section
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridButtonClick: cellSection:)])
    {
        ItemModel *sqModel = [ItemModel mj_objectWithKeyValues:button.buttonDic];
        [self.delegate gridButtonClick:sqModel cellSection:section];
    }
}


- (void)setDetailModel:(CompanyDetailModel *)detailModel
{
    _detailModel = detailModel;
    [self.backTableView reloadData];
}


#pragma mark - 展开联系方式

-(void)showPhone
{
    isShowPhone = !isShowPhone;
    
    [self.backTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            if(self.detailModel.latitude.length == 0||[self.detailModel.latitude isEqualToString:@"-"]||self.detailModel.longitude.length == 0||[self.detailModel.longitude isEqualToString:@"-"]){
                return ;
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(companyAdress)]){
                [self.delegate companyAdress];
            }
        }else {
            if (self.detailModel.neturl.count > 0) {
                NSString *addressURL = [NSString stringWithFormat:@"%@",[[self.detailModel.neturl objectAtIndex:0] objectForKey:@"url"]];
                if (addressURL.length > 0) {//地址不为空才跳转
                    if(self.delegate && [self.delegate respondsToSelector:@selector(CompanyUrl:)]){
                        [self.delegate CompanyUrl:addressURL];
                    }
                }
            }
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return isShowPhone ? 2:0;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%d%did",(int)indexPath.section,(int)indexPath.row];
    if(indexPath.section == 0)//header信息
    {  CompanyDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[CompanyDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell.recordBtn addTarget:self action:@selector(recordBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell setModel:_detailModel type:_detailModel.type.intValue];
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row == 1){
                UIView *lineView = [[UIView alloc]initWithFrame:KFrame(0, 1, KDeviceW, 1)];
                lineView.tag = 34751;
                lineView.backgroundColor =KHexRGB(0xebebeb);
                [cell.contentView addSubview:lineView];
                
                UIView *lineView2 = [[UIView alloc]initWithFrame:KFrame(0, 44, KDeviceW, 1)];
                lineView.tag = 34752;
                lineView2.backgroundColor =KHexRGB(0xebebeb);
                [cell.contentView addSubview:lineView2];
            }
        }
        cell.textLabel.font = KFont(13);
        cell.textLabel.textColor = KHexRGB(0x666666);
        cell.textLabel.numberOfLines = 0;
        if(indexPath.row == 0){
            cell.imageView.image = KImageName(@"地址icon");
            cell.textLabel.text = self.detailModel.address;
        }else{
            cell.imageView.image = KImageName(@"网址icon");
            cell.textLabel.text = self.detailModel.neturl.count>0?[[self.detailModel.neturl objectAtIndex:0] objectForKey:@"url"]:@"--";
        }
        return cell;
    }else{
        DetailGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[DetailGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailGridDelegate = self;
        }
        cell.section = (int)indexPath.section;
        [cell setCellData:self.detailModel.subclassMenu];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){//359*170
        return _detailModel.type.intValue == 1?(140+6):(170+6);//背景图片有10的圆角阴影,距离顶部还有10的间隔,4为阴影
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            NSString *adress = self.detailModel.address;
            CGFloat hight = [Tools getHeightWithString:adress fontSize:13 maxWidth:KDeviceW - 50 - 15]+ 20;
            return hight >45 ? hight:45;
        }else{
            return 45;
        }
    }else{
        NSArray *array = self.detailModel.subclassMenu;
        if(array.count >0){
            return KDetailGridWidth* (array.count%4>0?(array.count/4+1):array.count/4);
        }else{
            return KDetailGridWidth *3;
        }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *phoneView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 45)];
        phoneView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        
        phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *str = [ NSString stringWithFormat:@"  %@",self.detailModel.companyphonelist.count >0?[[self.detailModel.companyphonelist objectAtIndex:0] objectForKey:@"number"]:@"--"];
        if([str isEqualToString:@"  --"]||[str isEqualToString:@"  "])
        {
            phoneBtn.enabled = NO;
        }
        CGFloat phoneWidth = [Tools getWidthWithString:str fontSize:13 maxHeight:45]+30;
        phoneBtn.frame = KFrame(15, 0, phoneWidth, 45);
        [phoneBtn setImage:KImageName(@"电话icon") forState:UIControlStateNormal];
        [phoneBtn setTitle:str forState:UIControlStateNormal];
        [phoneBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = KFont(13);
        phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        [phoneView addSubview:phoneBtn];
        
        
        UILabel*label = [[UILabel alloc]initWithFrame:KFrame(KDeviceW - 100, 0, 100, 45)];
        label.text = @"联系信息";
        label.textColor = KHexRGB(0x666666);
        label.font = KFont(13);
        [phoneView addSubview:label];
        
        UIImageView * phoneImageView = [[UIImageView alloc]initWithFrame:KFrame(KDeviceW -15-15, 15, 15, 15)];
        phoneImageView.image = KImageName(@"灰色三角下拉");
        phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
        [phoneView addSubview:phoneImageView];
        
        if(isShowPhone)
        {
            phoneImageView.image = KImageName(@"上拉小三角");
        }
        else
        {
            phoneImageView.image = KImageName(@"灰色三角下拉");
        }
        
        
        
        UIButton *phoneFoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneFoldBtn.frame = label.frame;
        [phoneFoldBtn addTarget:self action:@selector(showPhone) forControlEvents:UIControlEventTouchUpInside];
        [phoneView addSubview:phoneFoldBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:KFrame(0, 44, KDeviceW, 1)];
        lineView.backgroundColor =KHexRGB(0xebebeb);
        [phoneView addSubview:lineView];
        
        
        return phoneView;
    }
    if (section == 2) {
        return [self addHeadView];

    }
    return nil;
}


-(UIView*)addHeadView
{
    UIView *view = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 45)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    UIView *kuanView = [[UIView alloc]initWithFrame:KFrame(15, 15, 5, 15)];
    kuanView.backgroundColor = KRGB(253, 155, 48);
    kuanView.layer.cornerRadius = 2;
    kuanView.clipsToBounds = YES;
    [view addSubview:kuanView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:KFrame(kuanView.maxX + 10, 0, KDeviceW - 100, view.height)];
    label.text = @"企业背景";
    label.textColor = KHexRGB(0x333333);
    label.font = KBlodFont(14);
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:KFrame(0, 44, KDeviceW, 1)];
    lineView.backgroundColor =KHexRGB(0xebebeb);
    [view addSubview:lineView];
    
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return  CGFLOAT_MIN;
    }else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UITableView *)backTableView
{
    if(!_backTableView)
    {
        _backTableView = [[UITableView alloc]initWithFrame:KFrame(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
        _backTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _backTableView.delegate = self;
        _backTableView.dataSource = self;
        _backTableView.estimatedRowHeight = 0;//禁用self-sizing 计算完整contentsize
        _backTableView.estimatedSectionHeaderHeight = 0;
        _backTableView.estimatedSectionFooterHeight = 0;
    }
    
    return _backTableView;
}

#pragma mark - 跟进记录按钮
- (void)recordBtnAction{
    if ([self.delegate respondsToSelector:@selector(recordBtnClick)]) {
        [self.delegate recordBtnClick];
    }
}

- (void)call{
    NSLog(@"打电话");
}


@end
