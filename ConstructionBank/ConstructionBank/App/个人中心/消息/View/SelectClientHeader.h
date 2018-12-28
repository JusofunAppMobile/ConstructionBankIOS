//
//  SelectClientHeader.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/4.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectClientHeaderDelegate <NSObject>

- (void)didClickSelectAllButton:(BOOL)selected;

@end

@interface SelectClientHeader : UIView

@property (nonatomic ,weak) id <SelectClientHeaderDelegate>delegate;

@end
