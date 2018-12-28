//
//  MyTextView.h
//  jusfounData
//
//  Created by clj on 15/7/15.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView

@property(copy,nonatomic)   NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;
@property(strong,nonatomic) UIFont * placeholderFont;

//更新高度的时候
@property(assign,nonatomic) float updateHeight;

@property(strong,nonatomic)  UILabel *PlaceholderLabel;


-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void(^)(MyTextView *))limit;

-(void)addTextViewBeginEvent:(void(^)(MyTextView *text))begin;
-(void)addTextViewEndEvent:(void(^)(MyTextView *text))End;
@end
