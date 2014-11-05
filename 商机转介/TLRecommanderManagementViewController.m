//
//  TLRecommanderManagementViewController.m
//  商机转介
//
//  Created by mac on 14-4-23.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLRecommanderManagementViewController.h"

@interface TLRecommanderManagementViewController ()

@end

@implementation TLRecommanderManagementViewController

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
    // Do any additional setup after loading the view.
}
-(IBAction)recommander:(id)sender{
    [tooles showHUD:@"稍等"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"refereeList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:@"0" forKey:@"page"];
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
    if (iPhone5) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }

    TLRecommanderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"recommander" ];
    NSArray *loginJson = [all objectForKey:@"loginJson"];
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
