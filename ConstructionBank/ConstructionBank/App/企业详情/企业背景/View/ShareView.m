//
//  ShareView.m
//  EnterpriseInquiry
//
//  Created by jusfoun on 15/11/24.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "ShareView.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKExtension/SSEShareHelper.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
//#import <ShareSDK/ShareSDK+Base.h>
@interface ShareView ()
{
    UIView *shareBackView;
}
@end

@implementation ShareView
{
    CGRect frame;
    UIView *backView ;
    UIColor *color;
}
//
//-(instancetype)init
//{
//    self = [super initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH)];
//    if(self)
//    {
//        backView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH)];
//        color= [UIColor blackColor];
//        backView.backgroundColor = [color colorWithAlphaComponent:0.3];
////        backView.alpha = 0.5;
//        [self addSubview:backView];
//
//
//        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
//        [backView addGestureRecognizer:tapGest];
//
//
//        shareBackView = [[UIView alloc]initWithFrame:KFrame(0, KDeviceH , KDeviceW, 160)];
//        shareBackView.backgroundColor = [UIColor whiteColor];
//
//        [backView addSubview:shareBackView];
//
//        float x = (KDeviceW - 50*3 )/4;
//
//        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        shareBtn.frame = KFrame(x, 25, 50, 50);
//        [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
//        shareBtn.tag = 2343;
////        [shareBtn setImage:[UIImage imageWithImage:@"朋友圈" scaledToSize:CGSizeMake(52, 52)]  forState:UIControlStateNormal];
//        [shareBtn setImage:[UIImage imageNamed:@"WXFriends_icon"] forState:UIControlStateNormal];
//        [shareBackView addSubview:shareBtn];
//        UILabel *shareLabel1 = [[UILabel alloc] init];
//        shareLabel1.frame = CGRectMake(x, CGRectGetMaxY(shareBtn.frame) + 10, 50, 15);
//        shareLabel1.text = @"微信";
//        shareLabel1.textAlignment = NSTextAlignmentCenter;
//        shareLabel1.textColor = [UIColor blackColor];
//        shareLabel1.font = KFont(12);
//        [shareBackView addSubview:shareLabel1];
//
//
//
//        UIButton *shareBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        shareBtn2.frame = KFrame(x*2 + 50, 25, 50, 50);
//        [shareBtn2 addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
//        shareBtn2.tag = 2344;
////        [shareBtn2 setImage:[UIImage imageWithImage:@"微信" scaledToSize:CGSizeMake(52, 52)] forState:UIControlStateNormal];
//        [shareBtn2 setImage:[UIImage imageNamed:@"WeChat_icon"] forState:UIControlStateNormal];
//        [shareBackView addSubview:shareBtn2];
//
//        UILabel *shareLabel2 = [[UILabel alloc] init];
//        shareLabel2.frame = CGRectMake(x*2 + 50, CGRectGetMaxY(shareBtn2.frame) + 10, 50, 15);
//        shareLabel2.text = @"朋友圈";
//        shareLabel2.textAlignment = NSTextAlignmentCenter;
//        shareLabel2.textColor = [UIColor blackColor];
//        shareLabel2.font = KFont(12);
//        [shareBackView addSubview:shareLabel2];
//
//
//
//        UIButton *shareBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        shareBtn3.frame = KFrame(x*3+50*2, 25, 50, 50);
//        [shareBtn3 addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
//        shareBtn3.tag = 2345;
////        [shareBtn3 setImage:[UIImage imageWithImage:@"新浪" scaledToSize:CGSizeMake(52, 52)] forState:UIControlStateNormal];
//        [shareBtn3 setImage:[UIImage imageNamed:@"Sina_icon"] forState:UIControlStateNormal];
//        [shareBackView addSubview:shareBtn3];
//
//        UILabel *shareLabel3 = [[UILabel alloc] init];
//        shareLabel3.frame = CGRectMake(x*3+50*2, CGRectGetMaxY(shareBtn3.frame) + 10, 50, 15);
//        shareLabel3.text = @"新浪";
//        shareLabel3.textAlignment = NSTextAlignmentCenter;
//        shareLabel3.textColor = [UIColor blackColor];
//        shareLabel3.font = KFont(12);
//        [shareBackView addSubview:shareLabel3];
//
//
//        UIView *lineView =[[ UIView alloc]initWithFrame:KFrame(0, CGRectGetMaxY(shareLabel3.frame) + 25, KDeviceW, 0.5)];
//        lineView.backgroundColor =KHexRGB(0xd9d9d9);
//        [shareBackView addSubview:lineView];
//
//
//
//        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeBtn.frame = KFrame(0, CGRectGetMaxY(lineView.frame) + 0.5 , KDeviceW, 49);
//        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
//        [closeBtn setTitleColor:KRGB(102, 102, 102) forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
//        [shareBackView addSubview:closeBtn];
//
//
//
//        frame = shareBackView.frame;
//        frame.size.height = CGRectGetMaxY(closeBtn.frame);
//        shareBackView.frame = frame;
//
//
//        //        [UIView animateWithDuration:0.5
//        //                              delay:0
//        //             usingSpringWithDamping:0.7
//        //              initialSpringVelocity:0.5
//        //                            options:UIViewAnimationOptionCurveLinear
//        //                         animations:^{
//        //
//        //
//        //                             shareBackView.frame = KFrame(0, KDeviceH - frame.size.height , KDeviceW, frame.size.height);
//        //
//        //                         } completion:^(BOOL finished) {
//        //
//        //                         }];
//
//
//        [UIView animateWithDuration:0.2 animations:^{
//            shareBackView.frame = KFrame(0, KDeviceH - frame.size.height , KDeviceW, frame.size.height);
//            backView.backgroundColor = [color colorWithAlphaComponent:0.5];
//        } completion:^(BOOL finished) {
//            //            [self removeFromSuperview];
//        }];
//
//
//
//    }
//
//    return self;
//}
//
//
//
//
//-(void)share:(UIButton *)sender
//{
//
//    //profile
//    //   __weak CompanyDetailController *theController = self;
//    __weak ShareView *selfView = self;
//
//    SSDKPlatformType type ;
//    if(sender.tag == 2343)
//    {
//        [MobClick event:@"Me90"];
//        [[BaiduMobStat defaultStat] logEvent:@"Me90" eventLabel:@"个人页－推荐－朋友圈点击数"];
//
//        type = SSDKPlatformSubTypeWechatSession;
//    }
//    else if (sender.tag == 2344)
//    {
//        [MobClick event:@"Me89"];
//        [[BaiduMobStat defaultStat] logEvent:@"Me89" eventLabel:@"个人页－推荐－微信点击数"];
//
//        type = SSDKPlatformSubTypeWechatTimeline;
//    }
//    else
//    {
//        [MobClick event:@"Me91"];
//        [[BaiduMobStat defaultStat] logEvent:@"Me91" eventLabel:@"个人页－推荐－新浪点击数"];
//
//        type = SSDKPlatformTypeSinaWeibo;
//    }
//    //创建分享参数
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//
//    NSArray* imageArray = @[[UIImage imageNamed:@"personal_logo"]];
//
//    if (imageArray) {
//        //
//        //
//        [shareParams SSDKSetupShareParamsByText:self.descStr
//                                         images:imageArray
//                                            url:[NSURL URLWithString:self.detailUrlStr]
//                                          title:@"企信宝 - 最权威企业信用查询工具"
//                                           type:SSDKContentTypeAuto];
//
//        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",self.descStr,[NSURL URLWithString:self.detailUrlStr]]
//                                                   title:@"企信宝 - 最权威企业信用查询工具"
//                                                   image:[UIImage imageNamed:@"personal_logo"]
//                                                     url:nil
//                                                latitude:0
//                                               longitude:0
//                                                objectID:nil
//                                                    type:SSDKContentTypeAuto];
//
//        //进行分享
//        [ShareSDK share:type
//             parameters:shareParams
//         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//             [self close];
//             switch (state) {
//                 case SSDKResponseStateSuccess:
//                 {
//
//                     [MBProgressHUD showHint:@"分享成功" toView:[UIApplication sharedApplication ].keyWindow];
//
//                     [selfView close];
//
//                     break;
//                 }
//                 case SSDKResponseStateFail:
//                 {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                         message:[NSString stringWithFormat:@"%@", error]
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
//                     break;
//                 }
//                 case SSDKResponseStateCancel:
//                 {
//                     [MBProgressHUD showHint:@"分享已取消" toView:[UIApplication sharedApplication ].keyWindow];
//                     break;
//                 }
//                 default:
//                     break;
//             }
//         }];
//    }
//}
//


-(void)close
{
    [UIView animateWithDuration:0.2 animations:^{
        shareBackView.frame = KFrame(0, KDeviceH , KDeviceW, frame.size.height);
        backView.backgroundColor = [color colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
