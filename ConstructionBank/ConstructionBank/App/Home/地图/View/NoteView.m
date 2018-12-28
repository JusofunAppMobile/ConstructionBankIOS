//
//  NoteView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/29.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//10  10+(hei+spa)+

#import "NoteView.h"

@implementation NoteView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
        
        CGFloat top = 10.f;
        CGFloat space = 6.f;
        CGFloat height = 17.f;
        NSArray *titleArr = @[@"新增企业",@"推荐客户",@"正式客户"];
        NSArray *iconArr = @[@"图例黄",@"图例绿",@"图例蓝"];

        for (int i = 0; i<3; i++) {
            UIImageView *icon = [[UIImageView alloc]initWithFrame:KFrame(12, top+(space+height)*i, 11, height)];;
            icon.image = KImageName(iconArr[i]);
            [self addSubview:icon];
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:KFrame(icon.maxX+7.5, icon.y+3, 55, 13)];
            titleLab.text = titleArr[i];
            titleLab.font = KFont(13);
            titleLab.textColor = KHexRGB(0x666666);
            [self addSubview:titleLab];
        }
    }
    return self;
}

@end
