//
//  Constants.h
//  框架
//
//  Created by WangZhipeng on 16/5/18.
//  Copyright © 2016年 WangZhipeng. All rights reserved.
//




#ifndef Constants_h
#define Constants_h

// navigaitonBar标题大小
#define KNavigationTitleFontSize  17

//navigaitonBar背景颜色
#define KNavigationBarBackGroundColor [UIColor whiteColor]

//首页的导航杭栏背景颜色
#define KHomeNavigationBarBackGroundColor  [UIColor whiteColor]

//大号字体
#define KLargeFont [UIFont systemFontOfSize:18]

//普通字体
#define KNormalFont [UIFont systemFontOfSize:16]

//小字体
#define KSmallFont [UIFont systemFontOfSize:14]

//特小字体
#define KMinFont [UIFont systemFontOfSize:12]

//普通颜色
#define KNormalTextColor KHexRGB(0x333333)

//副标题颜色
#define KSubtitleTextColor KHexRGB(0x666666)

//
#define KlightGrayColor KHexRGB(0x999999)

#define KMinGrayColor KHexRGB(0xcccccc)

//分割线颜色
#define KSeparatorColor KHexRGB(0xe9e9e9)


#define KInClolor   KRGB(254, 115, 37)
#define KOutClolor  KHexRGB(0x1e9efb)
//企业详情一个格子的宽度
#define KDetailGridWidth KDeviceW/4.0


//登录成功
#define KLoginSuccess   @"loginSuccess"

//退出登录
#define KLoginOut   @"loginOut"

//推送消息
#define KPushMessageSuccessNoti @"PushMessageSuccessNoti"

//添加根据记录
#define KAddFollowUpRecordNoti @"KAddFollowUpRecordNoti"

//选取地址
#define KSelectAddressNoti @"KSelectAddressNoti"

//////百度地图  com.jusfoun.EnterpriseInquiry1
#define BaiDu_Appkey      @"ZDGjTGHV0mmAi1jxZCWBBmRHGnvuxnz9"


#define FOLLOWSTATES      @[@"已电话沟通",@"拜访中",@"已拜访",@"合作建立",@"正式合作"]

//地图列表事件通知
#define KANNOLISTCELLACTIONNOTI @"AnnoListCellActionNoti"
#define KANNOLISTCELLACTIONNOTIForSearch @"AnnoListCellActionNotiForSearch"

//推送消息
typedef NS_ENUM(NSInteger, PushMessageType) {
    PushMessageAloneType = 0, //单个公司
    PushMessagemoreType   =   1,//多个公司
};

//大头针列表类型
typedef enum : NSUInteger {
    AnnotationListTypeMap,
    AnnotationListTypeSearch,
} AnnotationListType;

//搜索类型
typedef enum : NSUInteger {
    SearchTypeName,
    SearchTypeAddress,
} SearchType;

// 1.web页面  2.企业图谱 3.对外投资 4.分支机构 5.带tab 切换 web页面（比如 风险信息- 法院信息 页） 6.中标 7.招聘 8.无形资产-专利 9. 无形资产-商标 10.税务 欠税公告 11.行政处罚 12.股权出质 13.招标
#define KCompanyDetailGridType @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"]

#define KUserLocationKey @"userLocation"


#endif /* Constants_h */
