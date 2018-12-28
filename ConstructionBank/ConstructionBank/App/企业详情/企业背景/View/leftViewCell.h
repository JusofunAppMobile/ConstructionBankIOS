//
//  leftViewCell.h
//  jusfounData
//
//  Created by clj on 15/10/22.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leftViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *valueLabel;


-(void)updataFrameWithName:(NSString *)name andValue:(NSString *)value;
@end
