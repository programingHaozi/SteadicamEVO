//
//  KEnumPublicDefine.h
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#ifndef KEnumPublicDefine_h
#define KEnumPublicDefine_h

// 返回js-sdk数据的错误码 - error
typedef enum {
    LBErrorCodeSuccess  = 0,    // 成功
    LBErrorCodeFail     = -1,   // 失败
    LBErrorCodeCancel   = 1,    // 取消
}LBErrorCode;

// 业务功能
typedef enum {
    LBJsCallOcFuncTypeUserInfo  = 0,    // 获取用户信息
    LBJsCallOcFuncTypeAppInfo   = 1,    // 获取app信息
    LBJsCallOcFuncTypeRedirect  = 2,    // 跳转native页面
    LBJsCallOcFuncTypeAlipay    = 3,    // 支付宝支付
    LBJsCallOcFuncTypeShareInfo = 4,    // 分享
    LBJsCallOcFuncTypeCheckOut  = 5,    // 收银台
    LBJsCallOcFuncTypeCarInfo   = 6,    // 车辆列表
    LBJsCallOcFuncTypeDeviceInfo    = 7,    // 设备信息
    LBJsCallOcFuncTypeCloseWebview  = 8,    // 关闭网页
}LBJsCallOcFuncType;

// redirect
#define LB_RET_BUSINESS_TEXT @"text"
// alipay
#define LB_RET_BUSINESS_USERID @"userId"
#define LB_RET_BUSINESS_ORDERID @"orderId"
#define LB_RET_BUSINESS_ORDERPRICE @"orderPrice"
// shareInfo
#define LB_RET_BUSINESS_URL @"url"
#define LB_RET_BUSINESS_TITLE @"title"
#define LB_RET_BUSINESS_CONTENT @"content"
#define LB_RET_BUSINESS_IMGURL @"imgUrl"

#endif
