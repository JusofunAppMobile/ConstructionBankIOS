//
//  NoteView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/29.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        
        CGFloat top = 10.f;
        CGFloat height = 18.f;
        NSArray *titleArr = @[@"新增企业",@"目标客户",@"正式客户"];
        
        for (int i = 0; i<3; i++) {
            UIImageView *icon = [[UIImageView alloc]initWithFrame:KFrame(10, 10+(top+height)*i, 14, height)];;
            icon.backgroundColor = [UIColor greenColor];
            [self addSubview:icon];
            
            UILabel *titleLab = [[UILabel alloc]initWithFrame:KFrame(icon.maxX+5, icon.y, 60, height)];
            titleLab.text = titleArr[i];
            [self addSubview:titleLab];
        }
    }
    return self;
}

@end
