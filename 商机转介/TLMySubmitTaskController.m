//
//  TLMySubmitTaskController.m
//  TongLian
//
//  Created by mac on 13-10-30.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import "TLMySubmitTaskController.h"

//#define URL @"http://61.163.100.203:9999/control/mobile/taskSendList";
//#define URL @"http://10.88.1.59:8080/control/mobile/taskSendList";
//#define URL @"http://10.88.80.10:9000/control/mobile/taskSendList";


@interface TLMySubmitTaskController ()

@end

@implementation TLMySubmitTaskController
@synthesize balance;

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
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *phone = [NSString stringWithFormat:@"手机号:%@",myDelegate.loginName];
    [self.name setText:myDelegate.realname];
    [self.phone setText:phone];
	// Do any additional setup after loading the view.
}
-(IBAction)logout:(id)sender{
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"注销" message:@"确定注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil];
    [alert show];
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UIStoryboard *mainStoryboard = nil;
        if (iPhone5) {
            mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        } else {
            mainStoryboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil];
        }
    
        TLLoginViewController *viewcontroller = [mainStoryboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:viewcontroller animated:YES completion:nil];
    }
}
-(IBAction)changep:(id)sender{
    UIStoryboard *mainStoryboard = nil;
    mainStoryboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil];
    TLChangePswViewController *view = [mainStoryboard instantiateViewControllerWithIdentifier:@"changep"];
    [self.navigationController pushViewController:view animated:YES];
}
-(IBAction)search:(id)sender{
    NSString *urlstr = [NSString stringWithFormat:@"http://10.88.1.55:8080/Api/BusinessOpportunity/queryAccount.do"];
    NSURL *url = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:@"87" forKey:@"accountId"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
}

-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSString *responseCode = [all objectForKey:@"responseCode"];
    NSString *virAccBalance= [all objectForKey:@"virAccBalance"];
    self.balance.text = virAccBalance;
    NSLog(@"responseCode==%@,virAccBalance==%@",responseCode,virAccBalance);
    

}

- (void) GetErr:(ASIHTTPRequest *)request{
    [tooles removeHUD];
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
