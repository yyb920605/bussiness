//
//  TLHomeViewController.m
//  商机转介
//
//  Created by mac on 14-5-5.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLHomeViewController.h"

@interface TLHomeViewController ()

@end

@implementation TLHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tongji.adjustsImageWhenHighlighted = NO;
    self.faqi.adjustsImageWhenHighlighted = NO;
    self.tuijianren.adjustsImageWhenHighlighted = NO;
    self.fenxiang.adjustsImageWhenHighlighted = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner1.png"] forBarMetrics:UIBarMetricsDefault];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    self.photoList = myDelegate.photoList;
    if(iPhone5){
        [self setupViews];
    }else
    {
      if(myDelegate.photoList!=nil && [myDelegate.photoList count]!=0){
          [self setupViews];
      }
      else{
          [tooles MsgBox:@"广告列表为空"];
      }
    }
    //[ShareSDK connectSMS];
    // Do any additional setup after loading the view.
}
- (void)setupViews
{
//    NSURL *url = [NSURL URLWithString:@"http://61.163.100.203:9999/photo/11.jpg"];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"title1" image:image tag:0];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *url = myDelegate.URL;
    NSArray *a = [url componentsSeparatedByString:@"/control"];
    url= [a objectAtIndex:0];
    
    NSDictionary *dic1 = [self.photoList objectAtIndex:0];
    //NSString *title1 = [dic1 objectForKey:@"advertiseTitle"];
    NSString *nurl1 = [NSString stringWithFormat:@"%@/%@",url,[dic1 objectForKey:@"photoUrl"]];
    nurl1 = [nurl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:nurl1];
    //NSLog(@"photourl==%@",nurl1);
    
    NSDictionary *dic2 = [self.photoList objectAtIndex:1];
    //NSString *title2 = [dic2 objectForKey:@"advertiseTitle"];
    NSString *nurl2 = [NSString stringWithFormat:@"%@/%@",url,[dic2 objectForKey:@"photoUrl"]];
    nurl2 = [nurl2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url2= [NSURL URLWithString:nurl2];
    //NSLog(@"photourl==%@",nurl2);
    
    NSDictionary *dic3 = [self.photoList objectAtIndex:2];
    //NSString *title3 = [dic3 objectForKey:@"advertiseTitle"];
    NSString *nurl3 = [NSString stringWithFormat:@"%@/%@",url,[dic3 objectForKey:@"photoUrl"]];
    nurl3 = [nurl3 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url3= [NSURL URLWithString:nurl3];
    //NSLog(@"photourl==%@",nurl3);
    
    NSDictionary *dic4 = [self.photoList objectAtIndex:3];
    //NSString *title4 = [dic4 objectForKey:@"advertiseTitle"];
    NSString *nurl4 = [NSString stringWithFormat:@"%@/%@",url,[dic4 objectForKey:@"photoUrl"]];
    nurl4 = [nurl4 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url4= [NSURL URLWithString:nurl4];
    //NSLog(@"photourl==%@",nurl4);


    
    
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@" " image:[UIImage imageWithData:[NSData dataWithContentsOfURL:url1]] tag:0];
    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@" " image:[UIImage imageWithData:[NSData dataWithContentsOfURL:url2]] tag:0];
    SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@" " image:[UIImage imageWithData:[NSData dataWithContentsOfURL:url3]] tag:0];
    SGFocusImageItem *item4 = [[SGFocusImageItem alloc] initWithTitle:@" " image:[UIImage imageWithData:[NSData dataWithContentsOfURL:url4]] tag:0];
    
    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 63, self.view.bounds.size.width, 120.0)
                                                                    delegate:self
                                                             focusImageItems:item1, item2, item3, item4, nil];

    
//    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"title1" image:[UIImage imageNamed:@"banner1"] tag:0];
//    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"title2" image:[UIImage imageNamed:@"banner2"] tag:1];
//    SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"title3" image:[UIImage imageNamed:@"banner3"] tag:2];
//    SGFocusImageItem *item4 = [[SGFocusImageItem alloc] initWithTitle:@"title4" image:[UIImage imageNamed:@"banner4"] tag:4];
//  SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 120.0)
//                                                                  delegate:self
//                                                             focusImageItems:item1, item2, item3, item4, nil];
    [self.view addSubview:imageFrame];
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%@ tapped", item.title);
}
- (void)didSelect:(int)num{
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSDictionary *photoSelect = [myDelegate.photoList objectAtIndex:num];
    UIStoryboard *storyboard=nil;
    storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    TLAdvertisementViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"advertisement"];
    //[viewcontroller setAdvertiseID: [photoSelect objectForKey:@"advertiseId"]];
    NSString *adURL = [myDelegate.URL substringToIndex:34];
    [viewcontroller setAdUrl:[NSString stringWithFormat:@"%@/advertiseUI?advertiseId=%@&imageType=%@",adURL,[photoSelect objectForKey:@"advertiseId"],@"WVGA"]];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
    
}

-(IBAction)commender:(id)sender{
    
    
    [tooles showHUD:@"稍等"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"refereeList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:@"1" forKey:@"page"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"暂时只有快速录入！😓" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alertView show];
}
-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    UIStoryboard *storyboard=nil;
   
    storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
 
    TLNewRecommander *viewController = [storyboard instantiateViewControllerWithIdentifier:@"newRecommander" ];
    NSArray *array = [all objectForKey:@"androidAction"];
    NSDictionary *map = [array objectAtIndex:0];
    NSArray *loginJson = [map objectForKey:@"content"];
    NSString *totalRecords = [map objectForKey:@"totalrecords"];
    //NSLog(@"%@",loginJson);
    [viewController setTotalRecords:[totalRecords integerValue]];
    viewController.recommanderList =[[NSMutableArray alloc] init];
    for(int i=0;i<[loginJson count];i++){
        [viewController.recommanderList addObject:[loginJson objectAtIndex:i]];
    }
    //[viewController.recommanderList initWithArray:[all objectForKey:@"loginJson"]];
    [self.navigationController pushViewController:viewController animated:YES];
    //NSDictionary *lloginJson = [all objectForKey:@"lloginJson"];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
-(IBAction)faqi:(id)sender{
    UIStoryboard *storyboard=nil;
    if (iPhone5) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }
    TLReaderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"faqi" ];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction)tongji:(id)sender{
    [tooles showHUD:@"稍等"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"myProcessList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:@"CHANCEINPUT" forKey:@"orderStatus"];
    [request setPostValue:@"1" forKey:@"page"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResultt:)];
    [request setDidFailSelector:@selector(GetErrt:)];
    [request startAsynchronous];
    request = nil;
}
-(void)GetResultt:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *map = [[all objectForKey:@"loginJson"] objectAtIndex:0];
    NSString *total = [map objectForKey:@"totalrecords"];
    
    UIStoryboard *storyboard=nil;
    storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    TLChanceListViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"chanceList" ];
    [viewController setBusinessList:[map objectForKey:@"content"]];
    [viewController setTotalRecords:[total integerValue]];
    [viewController setImageName:@"成排1.png"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) GetErrt:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

-(IBAction)benefit:(id)sender{
    [tooles showHUD:@"稍等"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"bsProfitList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:@"1" forKey:@"page"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult2:)];
    [request setDidFailSelector:@selector(GetErr2:)];
    [request startAsynchronous];
    request = nil;
    
    
}
-(IBAction)iwant:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"功能尚未开通" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(void)GetResult2:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *androidAction = [all objectForKey:@"androidAction"];
    NSDictionary *androidMap = [androidAction objectAtIndex:0];
    NSMutableArray *benefitList = [NSMutableArray arrayWithArray:[androidMap objectForKey:@"businessInfo"]];
    NSInteger totalRecords = [[androidMap objectForKey:@"totalrecords"] integerValue];
    NSString *totalBenifit = [androidMap objectForKey:@"totalProfit"];
    NSString *totalProfit = [androidMap objectForKey:@"totalProfit"];
    UIStoryboard *storyboard=nil;
    storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    //    if (iPhone5) {
    //        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    //    }
    //    else{
    //        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    //    }
    
    //TLBenefitTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"benefit" ];
    TLBenifitViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"mybenifit"];
    [viewController setTotalBenifit:totalBenifit];
    
    [viewController setBenefitList:benefitList];
    [viewController setTotalRecords:totalRecords];
    [viewController setTotalProfit:totalProfit];
    [self.navigationController pushViewController:viewController animated:YES];
    //NSDictionary *lloginJson = [all objectForKey:@"lloginJson"];
}

- (void) GetErr2:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

//分享到微信圈
-(IBAction)myShare:(id)sender{
    
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *adURL = [myDelegate.URL substringToIndex:34];
    NSString *myUrl = [NSString stringWithFormat:@"%@/shareUI?parentId=%@",adURL,myDelegate.loginName];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"互动助手120"  ofType:@"png"];
    
    //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"专业提升品质，联合创造价值!通联支付秉承此服务理念为大家提供了一个管理商机转介商机的平台！"
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:@"互动助手"
                                                      url:myUrl
                                              description:@"这是一条测试信息"
                                                mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法

    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:NSLocalizedString(@"互动助手", @"互动助手")
                                             url:myUrl
                                      thumbImage:[ShareSDK imageWithPath:imagePath]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];

    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:INHERIT_VALUE
                                            title:NSLocalizedString(@"[互动助手]专业提升品质，联合创造价值!通联支付秉承此服务理念为大家提供了一个管理商机转介商机的平台！", @"Hello 微信朋友圈!")
                                              url:myUrl
                                       thumbImage:[ShareSDK imageWithPath:imagePath]
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    //定制短信信息
    NSString *SMSContent = [NSString stringWithFormat:@"您好，互动助手注册地址为：http://61.163.100.203:5555/control/advertiseUI?parentId=%@&advertiseId=%@&imageType=%@［互动助手］",myDelegate.loginName,@"9",@"WVGA"];
    [publishContent addSMSUnitWithContent:SMSContent];

    //定制微信收藏信息
//    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
//                                     content:INHERIT_VALUE
//                                       title:NSLocalizedString(@"[互动助手]专业提升品质，联合创造价值!通联支付秉承此服务理念为大家提供了一个管理商机转介商机的平台！", @"Hello 微信收藏!")
//                                         url:myUrl
//                                  thumbImage:[ShareSDK imageWithPath:imagePath]
//                                       image:INHERIT_VALUE
//                                musicFileUrl:nil
//                                     extInfo:nil
//                                    fileData:nil
//                                emoticonData:nil];
    //定制新浪微博信息
    [publishContent addSinaWeiboUnitWithContent:@"[互动助手]专业提升品质，联合创造价值!通联支付秉承此服务理念为大家提供了一个管理商机转介商机的平台！详情见官网：http://61.163.100.203:5555/control/registerUI?parentId=18539287071" image:[ShareSDK imageWithPath:imagePath]];
    
    //弹出分享菜单
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          //SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                          nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    NSLog(@"描述：%@",[error errorDescription]);
                                    NSLog(@"错误码：%d",[error errorCode]);
                                }
                            }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
