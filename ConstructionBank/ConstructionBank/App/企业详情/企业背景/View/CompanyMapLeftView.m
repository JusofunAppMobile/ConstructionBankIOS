//
//  CompanyMapLeftView.m
//  jusfounData
//
//  Created by clj on 15/10/22.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "CompanyMapLeftView.h"

#import "leftViewCell.h"
#import "RedButton.h"
#import <YYLabel.h>
#import <NSAttributedString+YYText.h>

#define HEIGHT  ([UIScreen mainScreen].bounds.size.height / 568.0)
#define WIDTH  ([UIScreen mainScreen].bounds.size.width / 320.0)
@implementation CompanyMapLeftView
{
    NSMutableArray *nameArray;
    NSMutableArray *valueArray;
    int distance ;
    float font;
    
    NSDictionary *saveDic;
    
}

/**
 *   isChrild  是否是二级公司
 *
 *   isFold    是否被展开  展开:YES   折叠:NO
 *    
 *   isShareHold 是否是股东 是：YES    否：NO
 */
- (instancetype)initWithFrame:(CGRect)frame withIschild:(BOOL)isChrild andIsFold:(BOOL)isFold andIsShareHold:(BOOL)isShareHold andDicInfo:(NSDictionary *)dicInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        saveDic = [NSDictionary dictionaryWithDictionary:dicInfo];
       // self.backgroundColor  = RGBA(250, 250, 250, 0.8);
        
        self.backgroundColor = [UIColor whiteColor];//[UIColor magentaColor];
        
        distance = 8;
        font = 16;
        if (KScreen47)
        {
            distance = 15;
        }
        else if (KScreen55)
        {
            distance = 19;
        }else if (KScreen35)
        {
            distance = 23;
            font = 17;
        }
        

        
        NSString *entId = [NSString stringWithFormat:@"%@",dicInfo[@"entId"]];
        if ([entId isEqualToString:@""] || [entId isEqualToString:@"null"] || [entId isEqualToString:@"(null)"]||entId.length == 0 ){
            
            if (!isShareHold) {
                [self createNoFindViewWithName:dicInfo[@"companyName"] andIsShareHold:isShareHold];
            }else
                {
                    if ([dicInfo[@"type"] integerValue] == 1) {
                         [self createNoFindViewWithName:dicInfo[@"companyName"] andIsShareHold:isShareHold];
                    }else
                    {
                        [self createInfoWithDataInfo:dicInfo withIschild:isChrild andIsFold:isFold andIsShareHold:isShareHold];
                    }
                }
        }else
        {
            [self createInfoWithDataInfo:dicInfo withIschild:isChrild andIsFold:isFold andIsShareHold:isShareHold];
        }
        
      
        UIButton *closeBtn = [[UIButton alloc] init];
        closeBtn.frame = CGRectMake(10,0, 20, 38);
        [closeBtn setImage:[Tools scaleImage:KImageName(@"close") size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:closeBtn];
    }
    return self;
}


//当企业Id为空时的显示的页面
-(void)createNoFindViewWithName:(NSString *)companyName andIsShareHold:(BOOL)isShareHold
{
    
    if(companyName.length == 0||[companyName isEqualToString:@"null"]||[companyName isEqualToString:@"NULL"]||[companyName isEqualToString:@"<null>"]||[companyName isEqualToString:@"-"]||[companyName isEqualToString:@"(null)"])
    {
        companyName = @"";
    }
    
    UIView *headView = [self headViewWithCompany:companyName andIsShareHold:isShareHold withIsPersonShareHold:NO];
    CGRect frameH = headView.frame;
    frameH.origin.y = 38;
    headView.frame = frameH;
    [self addSubview:headView];
    
    
    UIImageView *findNoImageView = [[UIImageView alloc] init];
    findNoImageView.frame = CGRectMake(0, CGRectGetMaxY(headView.frame) + 10, 71, 86);
    findNoImageView.image = [UIImage imageNamed:@"find"];
    findNoImageView.center = CGPointMake(self.frame.size.width/2,  CGRectGetMaxY(headView.frame) + (self.frame.size.height - CGRectGetMaxY(headView.frame))/2 - 43  );
    [self addSubview:findNoImageView];
    
    UILabel *hasNoLabel = [[UILabel alloc] init];
    hasNoLabel.frame = CGRectMake(10, CGRectGetMaxY(findNoImageView.frame) + 5, self.frame.size.width - 20, 40);
    hasNoLabel.text = @"该企业暂无相关信息，已安排更新";
    hasNoLabel.textColor = [UIColor blackColor];
    hasNoLabel.numberOfLines = 2;
    hasNoLabel.font =[UIFont fontWithName:@"Helvetica" size:12];
    hasNoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hasNoLabel];
}



//当企业Id不为空时显示的页面
-(void)createInfoWithDataInfo:(NSDictionary *)dicInfo withIschild:(BOOL)isChrild andIsFold:(BOOL)isFold andIsShareHold:(BOOL)isShareHold
{
    
    [self createToolButtonWithImageIsChirld:isChrild andIsFold:isFold andIsShareHold:isShareHold andDataDic:dicInfo];
}


-(void)setTableViewWithHight:(CGFloat)height
{
    if (_tableView == nil) {
        
        
        if (KIsIOS8) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 38,self.frame.size.width,height) style:UITableViewStylePlain];
        }else
        {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 38,self.frame.size.width,height - 30) style:UITableViewStylePlain];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        [self addSubview:_tableView];
    }
}

-(UIView *)headViewWithCompany:(NSString *)companyName andIsShareHold:(BOOL)isShareHold withIsPersonShareHold:(BOOL)isPersonShareHold
{
    
    if(companyName.length == 0||[companyName isEqualToString:@"null"]||[companyName isEqualToString:@"NULL"]||[companyName isEqualToString:@"<null>"]||[companyName isEqualToString:@"-"]||[companyName isEqualToString:@"(null)"])
    {
        companyName = @"";
    }

    UIView *headView = [[UIView alloc] init];
    
    
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:14];
    NSString *title = [NSString stringWithFormat:@"%@  ",companyName];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
    
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    button.frame = KFrame(0, 0, 35, 20);
    button.layer.cornerRadius = button.frame.size.height/6;
    button.layer.borderWidth = 1;
    button.layer.borderColor = KRGB(254, 109, 9).CGColor;
    //button.titleLabel.textColor = RGB(254, 109, 9);
    
    [button setTitleColor:KRGB(254, 109, 9) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showShareHolds:) forControlEvents:UIControlEventTouchUpInside];
    if (isShareHold) {
        [button setTitle:@"股东" forState:UIControlStateNormal];
        [button setTitleColor:KInClolor forState:UIControlStateNormal];
        button.layer.borderColor = KInClolor.CGColor;
    }else
    {
        [button setTitle:@"投资" forState:UIControlStateNormal];
        [button setTitleColor:KOutClolor forState:UIControlStateNormal];
        button.layer.borderColor = KOutClolor.CGColor;
        
    }
     NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:button contentMode:UIViewContentModeCenter attachmentSize:button.size alignToFont:font1 alignment:YYTextVerticalAlignmentCenter];
    attachText.yy_lineSpacing = 5;
    [text appendAttributedString:attachText];
    text.yy_font = font1;
    
    CGSize size = CGSizeMake(self.frame.size.width - 20, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
   
  

    
    YYLabel *_label = [[YYLabel alloc]initWithFrame:KFrame(10, 10, layout.textBoundingSize.width, layout.textBoundingSize.height)];
    _label.userInteractionEnabled = YES;
    _label.numberOfLines = 0;
   // _label.backgroundColor = [UIColor blueColor];
    _label.attributedText = text;
    [headView addSubview:_label];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(_label.frame) +10 , self.frame.size.width , 0.5);
    lineView.backgroundColor = KRGB(217, 217, 217);
    
    [headView addSubview:lineView];
    
    headView.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(_label.frame) + 10);
    return  headView;
}


#pragma mark - 显示股东信息
-(void)showShareHolds:(UIButton *)button
{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *Identity = [NSString stringWithFormat:@"%ldMyCell",(long)indexPath.row];
    leftViewCell *cell = (leftViewCell *)[tableView dequeueReusableCellWithIdentifier:Identity];
    if (!cell)
    {
        cell = [[leftViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identity];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor clearColor];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = nameArray[indexPath.row];
        NSString *str = valueArray[indexPath.row];
//        if (str.length==0) {
//            str = @"无";
//        }
        cell.detailTextLabel.text = str;
        cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    leftViewCell *cell = (leftViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGSize nameSize = [self labelAutoCalculateRectWith:nameArray[indexPath.row] FontSize:font MaxSize:CGSizeMake(CGFLOAT_MAX, 20)];
//    NSLog(@"nameSize   %f,%f",nameSize.width,nameSize.height);
    
    CGSize requiredSize = [self labelAutoCalculateRectWith:cell.detailTextLabel.text FontSize:18 MaxSize:CGSizeMake(self.frame.size.width -  20, CGFLOAT_MAX)];
    
    if (requiredSize.width > (self.frame.size.width - nameSize.width - 20))
    {
        return requiredSize.height + 25 ;
    }
    else
    {
        return requiredSize.height+ 10 ;
    }
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



-(void)createToolButtonWithImageIsChirld:(BOOL)isChrild andIsFold:(BOOL)isFold andIsShareHold:(BOOL)isShareHold andDataDic:(NSDictionary *)dicInfo
{
    

/*
       //1.首先判断是显示股东信息，还是公司信息 -》 显示公司信息 -》 没有按钮  end
      //
     //
//开始
    \\                                                                                    //如果有-》 显示企业详情，展开图谱按钮
     \\                                                 //图谱未被展开 -》 判断有没有股东，投资 -》
      \\                                               //                                   \\如果没有 -》 只显示企业详情按钮
       \\                                              //
        \\2.如果是公司信息， 是二级公司？-》判断图谱是否被展开\\
                                    \\                 \\
                                   是\\                 \\图谱被展开 -》 显示企业详情，完整图谱，收起图谱
                                      \\ 
                                        \\
                                          \\
                                            \\                       //如果有-》 显示企业详情，完整图谱按钮
 \\                                           \\ 判断有没有股东，投资 -》
 \\                                                                  \\如果没有 -》 只显示企业详情按钮
*/
    
    
    
    
    
    NSMutableArray *imageArray;// = [[NSMutableArray alloc] init];
    NSMutableArray *titleArray;// = [[NSMutableArray alloc] init];
    
    //判断是否是公司信息
    if (!isShareHold) {
        
        [self showStyleAndButtonWithInfoDic:dicInfo andIsChrild:isChrild andIsFold:isFold andImageArray:imageArray andTitleArray:titleArray andIsShareHold:NO];
        
    }else
    {
        NSInteger type = [dicInfo[@"type"] integerValue];
        if (type == 1) {
            [self showStyleAndButtonWithInfoDic:dicInfo andIsChrild:isChrild andIsFold:isFold andImageArray:imageArray andTitleArray:titleArray andIsShareHold:YES];
            
        }else
        {
            [self setTableViewWithHight:self.frame.size.height-38];
            //显示自然人法人，没有按钮
            imageArray = [[NSMutableArray alloc] init];
            titleArray = [[NSMutableArray alloc] init];
            
            nameArray = [[NSMutableArray alloc] init];
            valueArray = [[NSMutableArray alloc] init];
            
            [nameArray addObject:@"股东类型:"];
            [valueArray addObject:@"自然人股东"];
            NSString *investmentAmount = [NSString stringWithFormat:@"%@",dicInfo[@"investmentAmount"]];
            if(investmentAmount.length == 0||[investmentAmount isEqualToString:@"null"]||[investmentAmount isEqualToString:@"NULL"]||[investmentAmount isEqualToString:@"<null>"]||[investmentAmount isEqualToString:@"-"]||[investmentAmount isEqualToString:@"(null)"])
            {
                investmentAmount = @"";
            }
            if (investmentAmount.length != 0) {
                [nameArray addObject:@"出资金额:"];
                [valueArray addObject:investmentAmount];
            }
            
            NSString *stock = [NSString stringWithFormat:@"%@",dicInfo[@"stock"]];
            if(stock.length == 0||[stock isEqualToString:@"null"]||[stock isEqualToString:@"NULL"]||[stock isEqualToString:@"<null>"]||[stock isEqualToString:@"-"]||[stock isEqualToString:@"(null)"])
            {
                stock = @"";
            }
            if (stock.length != 0) {
                [nameArray addObject:@"股份比例:"];
                [valueArray addObject:stock];
            }

            NSString *papers = [NSString stringWithFormat:@"%@",dicInfo[@"papers"]];
            if(papers.length == 0||[papers isEqualToString:@"null"]||[papers isEqualToString:@"NULL"]||[papers isEqualToString:@"<null>"]||[papers isEqualToString:@"-"]||[papers isEqualToString:@"(null)"])
            {
                papers = @"";
            }
            if (papers.length != 0) {
                [nameArray addObject:@"证照/证件类型:"];
                [valueArray addObject:papers];
            }

            
            _tableView.tableHeaderView = [self headViewWithCompany:dicInfo[@"name"] andIsShareHold:YES withIsPersonShareHold:YES];
            
            //创建左边视图的按钮
            [self createButtonWithImageArray:imageArray andTitleArray:titleArray];
        }
    }
}


-(void)createButtonWithImageArray:(NSMutableArray *)imageArray andTitleArray:(NSMutableArray *)titleArray
{
    CGFloat fromBottomHeight;
    if (KIsIOS8) {
        fromBottomHeight = 40;
    }else
    {
        fromBottomHeight = 60;
    }
    
    
    NSLog(@"%f,%f",self.frame.size.width,self.frame.size.height);
    if (titleArray.count > 0) {
        float buttonWidth = 42;//self.frame.size.width/titleArray.count;
        float space = (self.frame.size.width - 40*titleArray.count)/(titleArray.count +1);
        
        if (titleArray.count == 1) {
            RedButton *button = [self createbuttonWithImage:[imageArray objectAtIndex:0] andTitle:[titleArray objectAtIndex:0] andspace:0 andIndex:0 andbuttonWidth:buttonWidth];
            button.frame = CGRectMake(15, self.frame.size.height - fromBottomHeight *WIDTH, buttonWidth, 40 *WIDTH);
            button.tag = 10;
            [self addSubview:button];
            
        }else
        {
            for (int i =0; i<titleArray.count; i++) {
                RedButton *button = [self createbuttonWithImage:[imageArray objectAtIndex:i] andTitle:[titleArray objectAtIndex:i] andspace:space andIndex:i andbuttonWidth:buttonWidth];
                button.tag = 10 + i;
                [self addSubview:button];
            }
        }
    }
}


-(RedButton *)createbuttonWithImage:(NSString *)imageName andTitle:(NSString *)titleName andspace:(CGFloat)space andIndex:(int) index andbuttonWidth:(CGFloat)buttonWidth
{
    CGFloat fromBottomHeight;
    if (KIsIOS8) {
        fromBottomHeight = 40;
    }else
    {
        fromBottomHeight = 60;
    }
    
    RedButton *button = [[RedButton alloc] init];
    button.frame = CGRectMake(space * (index+1)+  index * buttonWidth, self.frame.size.height - fromBottomHeight *WIDTH, buttonWidth, 40 *WIDTH);
    [button setImage:[Tools scaleImage:KImageName(imageName) size:CGSizeMake(34, 34)] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button centerImageAndTitle];
    return button;
}



//在判断条件是公司的情况下进行公司的一些判断
-(void)showStyleAndButtonWithInfoDic:(NSDictionary *)dicInfo andIsChrild:(BOOL)isChrild andIsFold:(BOOL)isFold andImageArray:(NSMutableArray *)imageArray andTitleArray:(NSMutableArray *)titleArray andIsShareHold:(BOOL)isShareHold
{
    //判断是否有公司id
    NSString *str = [NSString stringWithFormat:@"%@",dicInfo[@"entId"]];
    if (str.length>0) {
        BOOL isHasChrild =YES;
        NSInteger toOut = [dicInfo[@"investmentToOut"] integerValue];
        NSInteger shareHolds = [dicInfo[@"shareHolders"] integerValue];
        if (toOut>0 || shareHolds >0) {
            isHasChrild = YES;
        }else
        {
            isHasChrild = NO;
        }

        //判断是否是二级公司
        if(!isChrild){
            //判断图谱是否被展开
            if(!isFold ){
                //判断是否有股东数或者投资数
                if (isHasChrild) {
                    //如果有-》 显示企业详情，展开图谱按钮
                    if (toOut + shareHolds > 1) {
                        imageArray = [[NSMutableArray alloc] initWithObjects:@"企业图谱001",@"企业图谱002", nil];
                        titleArray = [[NSMutableArray alloc] initWithObjects:@"企业详情",@"展开图谱", nil];
                    }else
                    {
                        imageArray = [[NSMutableArray alloc] initWithObjects:@"企业图谱001", nil];
                        titleArray = [[NSMutableArray alloc] initWithObjects:@"企业详情", nil];
                    }
                    
                }else
                {
                    //如果没有 -》 只显示企业详情按钮
                    imageArray = [[NSMutableArray alloc] initWithObjects:@"企业图谱001", nil];
                    titleArray = [[NSMutableArray alloc] initWithObjects:@"企业详情", nil];
                }
                
            }else
            {
                //图谱被展开 -》 显示企业详情，完整图谱，收起图谱
                imageArray = [[NSMutableArray alloc] initWithObjects:@"企业图谱001",@"完整图谱",@"收起图谱", nil];
                titleArray = [[NSMutableArray alloc] initWithObjects:@"企业详情",@"完整图谱",@"收起图谱", nil];
            }
            
        }else{
            
            //判断是否有股东数或者投资数
            if (isHasChrild) {
                //如果有-》 显示企业详情，展开图谱按钮 蓝色光标
                imageArray = [[NSMutableArray alloc] initWithObjects:@"企业图谱001",@"完整图谱", nil];
                titleArray = [[NSMutableArray alloc] initWithObjects:@"企业详情",@"完整图谱", nil];
            }else
            {
                //如果没有 -》 只显示企业详情按钮
                imageArray = [[NSMutableArray alloc] initWithObjects:@"企业图谱001", nil];
                titleArray = [[NSMutableArray alloc] initWithObjects:@"企业详情", nil];
            }
            
        }
         [self setTableViewWithHight:self.frame.size.height- 40 *[UIScreen mainScreen].bounds.size.width / 320.0 -38];
    }else
    {
        [self setTableViewWithHight:self.frame.size.height-38];
        imageArray = [[NSMutableArray alloc] init];
        titleArray = [[NSMutableArray alloc] init];
    }
    
    
    
    
    nameArray = [[NSMutableArray alloc] init];
    valueArray = [[NSMutableArray alloc] init];
    
    NSString *legal = [NSString stringWithFormat:@"%@",dicInfo[@"legal"]];
    if (legal.length != 0) {
        [nameArray addObject:@"法人:"];
        [valueArray addObject:legal];
    }
    
    NSString *industry = [NSString stringWithFormat:@"%@",dicInfo[@"industry"]];
    if (industry.length != 0) {
        [nameArray addObject:@"行业:"];
        [valueArray addObject:industry];
    }

    NSString *investmentAmount = [NSString stringWithFormat:@"%@",dicInfo[@"investmentAmount"]];
    if (investmentAmount.length != 0) {
        [nameArray addObject:@"出资金额:"];
        [valueArray addObject:investmentAmount];
    }

    NSString *stock = [NSString stringWithFormat:@"%@",dicInfo[@"stock"]];
    if (stock.length != 0) {
        [nameArray addObject:@"股份比例:"];
        [valueArray addObject:stock];
    }

    NSString *createDate = [NSString stringWithFormat:@"%@",dicInfo[@"createDate"]];
    if (createDate.length != 0) {
        [nameArray addObject:@"成立日期:"];
        [valueArray addObject:createDate];
    }

    NSString *shareHolders = [NSString stringWithFormat:@"%@",dicInfo[@"shareHolders"]];
    if (shareHolders.length != 0) {
        [nameArray addObject:@"公司股东数:"];
        [valueArray addObject:shareHolders];
    }
    
    NSString *investmentToOut = [NSString stringWithFormat:@"%@",dicInfo[@"investmentToOut"]];
    if (investmentToOut.length != 0) {
        [nameArray addObject:@"对外投资数:"];
        [valueArray addObject:investmentToOut];
    }

    _tableView.tableHeaderView = [self headViewWithCompany:dicInfo[@"companyName"] andIsShareHold:isShareHold withIsPersonShareHold:NO];
    
    //创建左边弹出视图的按钮
    [self createButtonWithImageArray:imageArray andTitleArray:titleArray];
}


-(void)buttonClick:(UIButton *)button
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClick: withCompanyDic:)]) {
        [_delegate buttonClick:button.titleLabel.text withCompanyDic:saveDic];
    }
}



#pragma mark - 关闭视图
-(void)closeBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(close)]) {
        [_delegate close];
    }
}


@end
