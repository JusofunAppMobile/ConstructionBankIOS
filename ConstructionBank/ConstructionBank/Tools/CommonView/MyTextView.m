//
//  MyTextView.m
//  jusfounData
//
//  Created by clj on 15/7/15.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import "MyTextView.h"

@interface MyTextView()<UITextViewDelegate>

//最大长度设置
@property(assign,nonatomic) NSInteger maxTextLength;
@property(copy,nonatomic) id eventBlock;
@property(copy,nonatomic) id BeginBlock;
@property(copy,nonatomic) id EndBlock;

@end


@implementation MyTextView
- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    //UITextViewTextDidBeginEditingNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginNoti:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    //UITextViewTextDidEndEditingNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndNoti:) name:UITextViewTextDidEndEditingNotification object:self];
    
    float left=5,top=0,hegiht=10;
    
    self.placeholderColor = [UIColor lightGrayColor];
//    hegiht = [self textHeightWithWidth:];
    _PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                                , CGRectGetWidth(self.frame)-2*left, hegiht)];
    _PlaceholderLabel.font=self.placeholderFont?self.placeholderFont:self.font;
    _PlaceholderLabel.textColor=self.placeholderColor;
    _PlaceholderLabel.numberOfLines = 0;
    [self addSubview:_PlaceholderLabel];
    _PlaceholderLabel.text=self.placeholder;
    
    self.maxTextLength=1000;
    
}


//plactext显示需要用的尺寸
-(CGFloat)textHeightWithWidth:(CGFloat)width andPlacter:(NSString *)placeter
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, width, 0);
    label.text = placeter;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    
    return label.frame.size.height;
}


//禁用复制粘贴功能
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return NO;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    else
        _PlaceholderLabel.text=placeholder;
    
//    CGFloat height = [self textHeightWithWidth:CGRectGetWidth(self.frame)-2*5 andPlacter:placeholder];
//    _PlaceholderLabel.frame = CGRectMake(5, 4
//                                         , CGRectGetWidth(self.frame)-2*5, height);
    
    _PlaceholderLabel.frame = CGRectMake(5, -8,CGRectGetWidth(self.frame)-2*5 , 18);
    [_PlaceholderLabel sizeToFit];
    
    _placeholder=placeholder;
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _PlaceholderLabel.textColor=placeholderColor;
    _placeholderColor=placeholderColor;
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont{
    _PlaceholderLabel.font=placeholderFont;
    _placeholderFont=placeholderFont;
}
-(void)setText:(NSString *)tex{
    if (tex.length>0) {
        _PlaceholderLabel.hidden=YES;
    }
    [super setText:tex];
}

#pragma mark---一些通知
-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        _PlaceholderLabel.hidden=YES;
    }
    else{
        _PlaceholderLabel.hidden=NO;
    }
    
    
    if (_eventBlock && self.text.length > self.maxTextLength) {
        
        void (^limint)(MyTextView *text) =_eventBlock;
        
        limint(self);
    }
}


-(void)textViewBeginNoti:(NSNotification*)noti{
    
    if (_BeginBlock) {
        void(^begin)(MyTextView*text)=_BeginBlock;
        begin(self);
    }
}
-(void)textViewEndNoti:(NSNotification*)noti{
    
    if (_EndBlock) {
        void(^end)(MyTextView*text)=_EndBlock;
        end(self);
    }
}



#pragma mark----使用block 代理 delegate
-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(MyTextView *))limit{
    _maxTextLength=maxLength;
    
    if (limit) {
        _eventBlock=limit;
    }
}

-(void)addTextViewBeginEvent:(void (^)(MyTextView *))begin{
    
    _BeginBlock=begin;
}

-(void)addTextViewEndEvent:(void (^)(MyTextView *))End{
    _EndBlock=End;
}

-(void)setUpdateHeight:(float)updateHeight{
    
    CGRect frame=self.frame;
    frame.size.height=updateHeight;
    self.frame=frame;
    _updateHeight=updateHeight;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_PlaceholderLabel removeFromSuperview];
}

@end
