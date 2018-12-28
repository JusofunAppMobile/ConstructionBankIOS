//
//  MeterAnnotationView.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/6.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MeterAnnotationView.h"

@implementation MeterAnnotationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.meterLab = ({
            UILabel *view = [UILabel new];
            view.font = KFont(10);
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
            view.textAlignment = NSTextAlignmentCenter;
            view.textColor = KHexRGB(0xf39c31);
            view;
        });
        UIImage *image = KImageName(@"meterImage");
        self.canShowCallout = NO;
        self.image = image;
        self.meterLab.text = @"2000m";
        self.centerOffset = CGPointMake(- image.size.width/2, - image.size.height/2);
    }
    return self;
}
@end
