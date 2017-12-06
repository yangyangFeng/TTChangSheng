//
//  CSNewWorking.h
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#ifndef CSNewWorking_h
#define CSNewWorking_h

//TODO: json日志 开关0-关  1-开
#define SWITCH_OPEN_LOG 1
//TODO: 是否是线上 0-测试  1-线上
#define SWITCH_ONLINE 0


//TODO: 请求数据 size
#define TT_PAGE_SIZE_INT 20
#define TT_PAGE_SIZE_STR @"20"

//TODO: ***切换服务地址***
#if SWITCH_ONLINE
//正事服务器线上地址http://mapi.qushuawang.com/api3/Home/
static NSString* baseUrl = @"https://api.changsheng888.net";
#else
//线下测试地址
static NSString* baseUrl = @"https://api.changsheng888.net";
//线下测试地址
//static NSString* baseUrl = @"http://api.jcjh.cn";
#endif
static NSString* webSocketUrl = @"wss://api.changsheng888.net:4764";
/**
 *  与后台约定,正确成功状态值
 */
static int successCode = 1000;
static NSInteger HTTP_TIME_OUT = 15;
typedef NS_ENUM(NSInteger, TTREQUEST_TYPE) {
    GET_TTREQUEST_TYPE = 1,
    POST_TTREQUEST_TYPE = 1 << 1,
    UpLoad_Image = 1 <<2,
    UpLoad_Voice = 1 <<3,
    UpLoad_Video = 1 <<4,
    UpLoad_Custome = 1 <<5,
};

typedef void (^TTSuccessBlock)(id responseObject);
typedef void (^TTFailureBlock)(NSError* error);
typedef void (^TTUploadProgressBlock)(CGFloat uploadProgress);

#import "CSHttpRequestManager.h"
#endif /* CSNewWorking_h */

//************************************************************************//
//TODO: 我的约单详情Mys/myinviteorderdetail+orderid
#define WEB_YUEDAN_DETAIL [NSString stringWithFormat:@"%@/Mys/myinviteorderdetail",baseUrl]//约我的单详情
//TODO: 约我的 详情Mys/myinviteorderdetail+orderid
#define WEB_INVITEME_DETAIL [NSString stringWithFormat:@"%@/Mys/invitemyorderdetail",baseUrl]
//TODO: 伴伴分享 memberid+babyid
#define WEB_BABYSHARE [NSString stringWithFormat:@"%@/ActiveShare/babydetailShare",baseUrl]
//TODO: 用户条款
#define WEB_USER_CLAUSE  [NSString stringWithFormat:@"%@/Webview/userclause",baseUrl] 

//TODO: 关于去耍
#define WEB_GUANYU_QUSHUWA [NSString stringWithFormat:@"%@/Webview/aboutqs",baseUrl]

//TODO: 商家入驻
#define WEB_SHANGJIARUZHU [NSString stringWithFormat:@"%@/Webview/shopprocess",baseUrl]

//TODO: 去耍币说明
#define WEB_QSB_DETAIL [NSString stringWithFormat:@"%@/Webview/currency_info",baseUrl]

//TODO: 我的约单列表 -> Mys/myinviteorder +memberid
#define WEB_YUEDANLIST_DETAIL [NSString stringWithFormat:@"%@/Mys/myinviteorder",baseUrl]
//TODO: 拌伴申请-> Mys/Login_Partner +memberid
#define WEB_BBSHENQING_DETAIL [NSString stringWithFormat:@"%@/Mys/Login_Partner",baseUrl]
//TODO: 拌伴资料修改-> Mys/Login_PartnerChange +babyid
#define WEB_BBSHENQING_DETAIL_EDIT [NSString stringWithFormat:@"%@/Mys/Login_PartnerChange",baseUrl]
//TODO: 拌伴收藏列表-> Mys/collectionBabyList +memberid+longitude+latitude
#define WEB_BBCOLLECTLIST_DETAIL [NSString stringWithFormat:@"%@/Mys/collectionBabyList",baseUrl]
//TODO: 拌伴点评-> Mys/reviewBabyList +memberid
#define WEB_BBCOMMONTLIST_DETAIL [NSString stringWithFormat:@"%@/Mys/reviewBabyList",baseUrl]
//TODO: 收入明细-> Mys/incomedetails +memberid
#define WEB_SHOURUMINGXI_DETAIL [NSString stringWithFormat:@"%@/Mys/babyincome",baseUrl]
//TODO: 提现记录-> Mys/withdrawalRecord +memberid
#define WEB_TIXIANJILU_DETAIL [NSString stringWithFormat:@"%@/Mys/withdrawalRecord",baseUrl]
//TODO: 约我的单-> Mys/invitemyorder +babyid + memberid
#define WEB_YUEWO_DETAIL [NSString stringWithFormat:@"%@/Mys/invitemyorder",baseUrl]
//TODO: 拌伴我的点评-> Mys/Reply +memberid + babyid
#define WEB_BBWODEDIANPING_DETAIL [NSString stringWithFormat:@"%@/Mys/Reply",baseUrl]
//TODO: 拌伴需知-> Mys/babyKnow
#define WEB_BBXUZHI_DETAIL [NSString stringWithFormat:@"%@/Mys/babyKnow",baseUrl]
//TODO: 伴伴审核失败->Mys/auditfail+babyid
#define WEB_BBAPPLYFAIL_DETAIL [NSString stringWithFormat:@"%@/Mys/auditfail",baseUrl]
//TODO: 伴伴审核中->Mys/auditing+babyid
#define WEB_BBAUDITING_DETAIL [NSString stringWithFormat:@"%@/Mys/auditing",baseUrl]
//TODO: 伴伴申请引导-> Mys/babyapply+memberid
#define WEB_BBAPPLY_DETAIL [NSString stringWithFormat:@"%@/Mys/babyapply",baseUrl]
//TODO: 伴伴申请须知-> Mys/babyapply+memberid
#define WEB_BBAPPLY_XUZHI [NSString stringWithFormat:@"%@/Mys/babyapplyknown",baseUrl]
//TODO: 我的卡卷
#define WEB_CARD [NSString stringWithFormat:@"%@/Web/index.html#/coupons/",baseUrl]

//@"http://mapi.qushuawang.com/api3/Home/Webview/currency_info"
#define WEB_GO_APPSTORE @"http://www.baidu.com"
#define WEB_SHARE_BASE_URL [NSString stringWithFormat:@"%@/Webview/barshare?",baseUrl]
//@"http://mapi.qushuawang.com/api3/Home/Webview/barshare?"
#define WEB_COMMIT_BASE_URL [NSString stringWithFormat:@"%@/Webview/commentlist??",baseUrl]
//@"http://mapi.qushuawang.com/api3/Home/Webview/commentlist?"//nightclubid=3&memberid=3
