//
//  TLAppDelegate.m
//  TongLian
//
//  Created by Wang Xiaobo on 13-1-14.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import "TLAppDelegate.h"

@implementation TLAppDelegate
@synthesize loginName,URL;

//-(void) setURL:(NSString *)mURL{
//    URL = mURL;
//}
//-(NSString *)URL{
//    //广东URL
//    //return @"http://121.8.157.114:8888/control/mobile";
//    //
//    //return @"http://61.163.100.203:9999/control/mobile";
//    return @"http://10.88.0.129:8888/control/mobile";
//    //return @"http://61.163.100.203:8888/control/mobile";
//    //return @"http://10.88.1.51:8080/control/mobile";
//    //return @"http://10.88.80.10:9000/control/mobile";
//
//}
-(void) setCompanyList:(NSMutableArray *)mcompany{
    companyList = mcompany;
}
-(NSMutableArray *) companyList{
    if(companyList == nil){
        companyList = [[NSMutableArray alloc] init];
    }
    return companyList;
}

-(void) setCompany:(TLCompany *)mcompany{
    company = mcompany;
}
-(TLCompany *) company{
    if(company == nil){ 
        company= [[TLCompany alloc] init];
    }
    return company;
}
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     
    
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
     **/
    
    
    [ShareSDK connectSinaWeiboWithAppKey:@"340456462"
                               appSecret:@"a308e292251006e3f584a4e764ccd4aa"
                             redirectUri:@"http://61.163.100.203:5555/control/registerUI?parentId=18539287071"];

    
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx4b36db936793d382" wechatCls:[WXApi class]];    //    [ShareSDK connectWeChatWithAppId:@" wxc467b1f584ded6c6" wechatCls:[WXApi class]];
//    [ShareSDK importWeChatClass:[WXApi class]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //自动更新
    [self GetUpdate];
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    //[ShareSDK registerApp:@"iosv1101"];
    [ShareSDK registerApp:@"1c9ceb96b1a4"];
    //初始化各分享接口SDk
    [self initializePlat];
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    //开始监听，会启动一个run loop
    [self.hostReach startNotifier];
    self.flag = 0;
    //BAIDU MAP SDK 初始化
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"8qSrH6tIWIiVIdEGnhHEOiKg" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    //iphone5和iphone5选择不同的storyboard
    UIStoryboard *mainStoryboard = nil;
    if (iPhone5) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    } else {
        mainStoryboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil];
    }
    // 2
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    

    // Add the navigation controller's view to the window and display.
    return YES;
}
//检查app是否为最新版本，750875946是app id
-(void)GetUpdate
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=875248883"];
    NSString *file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@",file);
    if(file.length>100){
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        NSRange sub = NSMakeRange(substr.location+substr.length, 3);
        NSString *version = [file substringWithRange:sub];
    
        if([nowVersion isEqualToString:version]==NO)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:
                             @"版本有更新:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            [alert show];
        }
    }
}
//不是最新版本，跳转app store更新,750875946是app id
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSString *nurl1 = @"https://itunes.apple.com/us/app/互动助手/id875248883?ls=1&mt=8";
        nurl1 = [nurl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:nurl1];
                                            
        [[UIApplication sharedApplication]openURL:url];
    }
}
//网络链接改变时会调用的方法
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    self.isReachable = YES;
    if(self.flag == 1){
        if(status == NotReachable)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:@"无法连接到网络！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = NO;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = YES;
        }
    }
    self.flag = 1;
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"terminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end
