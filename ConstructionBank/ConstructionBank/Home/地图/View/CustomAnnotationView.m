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
            view.backgroundColor = [UIColor yellowColor];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.height.width.mas_equalTo(20);
            }];
            view.textAlignment = NSTextAlignmentCenter;
            view;
        });
        
        [self addSubview:_numLab];
        
//        _numLab.text = @"2";
//        _iconView.image = KImageName(@"anno.jpeg");
    }
    return self;
}



@end
