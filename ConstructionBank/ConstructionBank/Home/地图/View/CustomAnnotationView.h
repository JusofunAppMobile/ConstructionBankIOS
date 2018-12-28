//
//  CustomAnnotationView.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/29.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>

@interface CustomAnnotationView : BMKAnnotationView
@property (nonatomic ,strong) UILabel *numLab;
@property (nonatomic ,strong) UIImageView *iconView;
@end
