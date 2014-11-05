//
//  TLBusinessController.m
//  TongLian
//
//  Created by mac on 13-9-11.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import "TLBusinessController.h"
//#define LIST @"http://61.163.100.203:9999/control/mobile/myBusinessList";
//#define LIST @"http://10.88.1.59:8080/control/mobile/myBusinessList";
//#define LIST @"http://10.88.80.10:9000/control/mobile/myBusinessList";

@interface TLBusinessController ()

@end

@implementation TLBusinessController
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
}

//商机发起
-(IBAction)button_click:(id)sender{
    //[self performSegueWithIdentifier:@"recall" sender:self];
}
//推荐商户数统计
-(IBAction)install:(id)sender{
    [tooles showHUD:@"稍等"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"notSubbmitList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
    request = nil;
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
    UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    TLAllBusinessTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"allBusiness" ];
    [viewController setBusinessList:[all objectForKey:@"loginJson"]];
    [self.navigationController pushViewController:viewController animated:YES];
    //NSDictionary *lloginJson = [all objectForKey:@"lloginJson"];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

//推荐人统计
-(IBAction)userRecall:(id)sender{
    //[self initCompanyList];
    //UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请选择快速录入！😰" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alertView show];
}
//推荐人信息
-(IBAction)foward:(id)sender{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"😳还是选择快速录入吧！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
