//
//  URLManager.h
//  框架
//
//  Created by WangZhipeng on 16/5/18.
//  Copyright © 2016年 WangZhipeng. All rights reserved.
//

#ifndef URLManager_h
#define URLManager_h

//线下
//#define HOSTURL   @"http://172.16.100.34:8888"

#define HOSTURL   @"http://118.190.78.107:8888"



//预上线
//#define HOSTURL @""

//线上
//#define HOSTURL @"http://118.190.78.107:8888"

#define GetCompanyDetail  [NSString stringWithFormat:@"%@%@",HOSTURL,@"/api/GetEntDetailStatic"]

//H5 交互规则
#define Md5Encryption  @"md5encryption://parameter"

//跟进记录列表
#define KGETFollowList @""HOSTURL"/api/app/followList"

#define KAddFollowLog  @""HOSTURL"/api/app/addFollow"

#define KGetMessageList @""HOSTURL"/api/app/MessageList"

#define KPushMessage    @""HOSTURL"/api/app/pushMessage"

#define KSearchMessageClient   @""HOSTURL"/api/app/searchMessage"

//推送消息—搜索我的正式客户
#define KSearchMyClient  @""HOSTURL"/api/app/searchMessage"

//登录
#define KLogin  @""HOSTURL"/api/user/applogin"

// 发送验证码
#define KSendCode  @""HOSTURL"/api/user/sendValidateCode"

// 发送邮箱验证码
#define KSendEmailCode  @""HOSTURL"/api/app/sendEmailCode"

// 所属机构
#define KGetOrganization  @""HOSTURL"/api/user/appsearchOrgList"

//注册
#define KRegiste  @""HOSTURL"/api/user/appreg"

//标记为目标客户
#define KCustomerMark @""HOSTURL"/api/app/customermark"

//地图显示
#define KGETMAPDATAS  @""HOSTURL"/api/app/GetStatisticsByTopLeftAndBottomRightList"

//地图搜索
#define KMapSearch @""HOSTURL"/api/app/SearchCompany"

//地图大头针点击
#define KGETMAPSELECTEDDATAS  @""HOSTURL"/api/app/GetGeoBoundingBoxList"

//列表显示
#define KGETCOMPANYLIST @""HOSTURL"/api/app/GetMapListByType"

//我的客户
#define KGETMYCUSTOMER  @""HOSTURL"/api/app/myCustomer"

//企业图谱
#define KGetEntAtlasData  @""HOSTURL"/api/EntAll/GetEntAtlasData"

//对外投资和分支机构
#define GetEntBranchOrInvesment  @""HOSTURL"/api/GetEntBranchOrInvesment"

//企业图谱查询企业或股东信息
#define GetEntAtlasEntDetail  @""HOSTURL"/api/EntAll/GetEntAtlasEntDetail"

//跟进日程
#define KGetFollowRecordByCalendar @""HOSTURL"/api/app/searchfollowListByCalendar"


//    分析统计
#define StatisticalAnalysis  @""HOSTURL"/api/app/statisticalAnalysis"

//选中某天的日程
#define KGetFollowRecordForDay @""HOSTURL"/api/app/searchfollowListByCalendarDetail"

//发送报告
#define KSendReport @""HOSTURL"/api/app/SendReport"

//搜地址
#define KSearchhCompanyByAddress @""HOSTURL"/api/app/SearchCompanyByAddress"


#endif /* URLManager_h */
