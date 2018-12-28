//
//  AddFollowUpLogCell.h
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/3.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFollowUpLogCell : UITableViewCell

@property (nonatomic ,strong) UITextField *contenLab;
- (void)setContent:(NSMutableDictionary *)content atRow:(NSInteger)row;

@end

