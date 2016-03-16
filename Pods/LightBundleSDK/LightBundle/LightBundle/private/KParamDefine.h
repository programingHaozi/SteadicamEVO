//
//  KParamDefine.h
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#ifndef KParamDefine_h
#define KParamDefine_h

// js-sdk 基础功能 方法名
#define LB_NAME_CAMERA @"camera"            // 相机相册
#define LB_NAME_QRCODE @"qrcode"            // 二维码扫码
#define LB_NAME_QRCODEIMAGE @"qrcodeImage"  // 二维码图片识别
#define LB_NAME_BARCODE @"barcode"          // 条码扫码
#define LB_NAME_TEL @"tel"                  // 打电话
#define LB_NAME_EMAIL @"email"              // 发送邮件
#define LB_NAME_SMS @"sms"                  // 发送短信
#define LB_NAME_GEOLOCATION @"geolocation"  // 经纬度
#define LB_NAME_DIALOG @"dialog"            // 对话框
#define LB_NAME_TOAST @"toast"              // Toast框
#define LB_NAME_LOADING @"loading"          // Loading框
#define LB_NAME_DATE @"date"                // 选日期

// js-sdk 业务功能 方法名
#define LB_NAME_USERINFO @"userInfo"    // 获取用户信息(用户UID,用户名,电话,是否认证会员,用户token,用车辆信息)
#define LB_NAME_APPINFO @"appInfo"      // 获取app信息(appCode,版本号)
#define LB_NAME_REDIRECT @"redirect"    // 跳转到native页面
#define LB_NAME_ALIPAY @"alipay"        // 支付宝支付
#define LB_NAME_SHAREINFO @"shareInfo"  // 分享
#define LB_NAME_CHECKOUTCOUNTER @"checkoutcounter"  // 支付中心
#define LB_NAME_CARINFO @"carInfo"      // 获取爱车

// js-sdk 参数及返回值
#define LB_RET_callbackId @"callbackId"
#define LB_RET_NAME @"name"
#define LB_RET_PARAM @"param"
#define LB_RET_RESULT @"result"
#define LB_RET_TEXT @"text"
#define LB_RET_ERROR_CODE @"errorCode"
#define LB_RET_MSG @"msg"
#define LB_RET_OPEN @"open"
#define LB_RET_TEL @"tel"
// email
#define LB_RET_CC @"cc"
#define LB_RET_RECEIVER @"receiver"
#define LB_RET_TITLE @"title"
//dialog
#define LB_RET_BTNARRAY @"btnArray"

#endif
