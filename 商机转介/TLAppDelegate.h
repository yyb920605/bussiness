//
//  TLAppDelegate.h
//  TongLian
//
//  Created by Wang Xiaobo on 13-1-14.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCompany.h"
#import "Reachability.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "BMapKit.h"
//#import "TLLoginViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


@interface TLAppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>{
    NSMutableArray *companyList;
    TLCompany *company;
    NSString *loginName;
    NSString *URL;
}
@property (strong, nonatomic) BMKMapManager* mapManager;
@property (strong, nonatomic) Reachability *hostReach;
@property Boolean isReachable;
@property NSInteger flag;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) TLCompany *company;
@property (strong, nonatomic) NSString *loginName;
@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSString *userType;
//服务器配置
@property (strong, nonatomic) NSDictionary *ServerDic;
//银行
@property (strong, nonatomic) NSDictionary *bankDic;
//广告轮播 列表
@property (strong, nonatomic) NSArray *photoList;
//帐户ID
@property (nonatomic)NSString *accountId;
@property (nonatomic,strong) NSString *realname;



//商户回访
//@property (strong, nonatomic) NSMutableDictionary *returnVisitDic;
//@property (strong, nonatomic) NSMutableDictionary *RecallOtherDic;
@end

