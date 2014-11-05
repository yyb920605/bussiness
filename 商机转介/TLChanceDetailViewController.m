//
//  TLChanceDetailViewController.m
//  商机转介
//
//  Created by mac on 14-4-22.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLChanceDetailViewController.h"

@interface TLChanceDetailViewController ()

@end

@implementation TLChanceDetailViewController

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
    [self.navigationItem setTitle:@"商户信息修改"];
    [self.businessName setText:[self.chance objectForKey:@"businessName"]];
    [self.person setText:[self.chance objectForKey:@"person"]];
    [self.phone setText:[self.chance objectForKey:@"phone"]];
    [self.address setText:[self.chance objectForKey:@"address"]];
    // Do any additional setup after loading the view.
}
-(IBAction)subbmit:(id)sender{
    
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"chanceAdd"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    [tooles showHUD:@"正在处理！请稍候！"];
    NSLog(@"processId==%@",[self.chance objectForKey:@"businessProcessId"]);
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:@"测试备注" forKey:@"comment"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:self.businessName.text forKey:@"name"];
    [request setPostValue:self.person.text forKey:@"person"];
    [request setPostValue:self.phone.text forKey:@"phone"];
    [request setPostValue:self.address.text forKey:@"addressDetail"];
    [request setPostValue:[self.chance objectForKey:@"businessProcessId"] forKey:@"processId"];
    [request setPostValue:@"BANKCARD" forKey:@"serviceType"];
    [request setPostValue:@"beizhu" forKey:@"comment"];

    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];}

-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *loginJson = [all objectForKey:@"loginJson"];
    NSLog(@"loginjson===%@",loginJson);
    NSString *result = [loginJson objectForKey:@"result"];
    if([result isEqualToString:@"success"]){
        [tooles MsgBox:@"提交成功！"];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
    }else{
        NSLog(@"result===%@",result);
        [tooles MsgBox:@"提交不成功，有错误！"];
    }
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    TLRecallTableViewController *recall =[storyboard instantiateViewControllerWithIdentifier:@"recall"];
    //    [recall setList:loginJson];
    //    [self.navigationController pushViewController:recall animated:YES];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
-(IBAction)textFieldDone:(id)sender{
    [sender resignFirstResponder];
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
