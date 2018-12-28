//
//  CustomAnnotationView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/29.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"

@interface CustomAnnotationView ()

@end

@implementation CustomAnnotationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.numLab = ({
            UILabel *view = [UILabel new];
            view.font = KFont(12);
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(5);
                make.centerX.mas_equalTo(self);
            }];
            view.textAlignment = NSTextAlignmentCenter;
            view.textColor = [UIColor whiteColor];
            view;
        });
        
        NSString *imageName = nil;////1：新增企业2：目标客户 3：正式客户
        CustomAnnotation *anno = (CustomAnnotation *)annotation;
        if (anno.clusterNum > 1) {//搜索页聚集点
            imageName = @"多坐标";
            _numLab.text = [NSString stringWithFormat:@"%li",anno.clusterNum];
        }else{//
            if ([anno.model.type intValue] ==1 ) {
                imageName = @"图例黄";
            }else if ([anno.model.type intValue] ==2){
                imageName = @"图例绿";
            }else if ([anno.model.type intValue] ==3){
                imageName = @"图例蓝";
            }else{
                imageName = @"多坐标";
                _numLab.text = anno.model.docCount;
            }
        }
        
        UIImage *image = KImageName(imageName);
        self.canShowCallout = NO;
        self.image = image;
        self.centerOffset = CGPointMake(0, - image.size.height/2);
        //        self.enabled = [anno.model.isEnable boolValue];
        self.enabled = YES;
    }
    return self;
}



@end

