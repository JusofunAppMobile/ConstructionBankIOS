//
//  CompanyMap.h
//  jusfounData
//
//  Created by clj on 15/10/21.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyDelegate <NSObject>

-(void)zhanKaiCompanyMap;

@end

@interface CompanyMap : UIView

@property (nonatomic,assign) id<CompanyDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame andDicInfo:(NSDictionary *)dic;

@end
