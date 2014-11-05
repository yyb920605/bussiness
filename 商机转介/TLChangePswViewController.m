//
//  TLChangePswViewController.m
//  商机转介
//
//  Created by mac on 14-5-7.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLChangePswViewController.h"

@interface TLChangePswViewController ()

@end

@implementation TLChangePswViewController

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
    [self.oPsw setSecureTextEntry:YES];
    [self.nPsw setSecureTextEntry:YES];
    [self.nPsw1 setSecureTextEntry:YES];
    // Do any additional setup after loading the view.
}
-(IBAction)subbmit:(id)sender{
    
    if(self.oPsw.text.length==0){
        [tooles MsgBox:@"请输入初始密码！"];
        return;
    }
    if(self.nPsw.text.length == 0){
        [tooles MsgBox:@"请输入新密码！"];
        return;
    }
    if(self.nPsw1.text.length ==0){
        [tooles MsgBox:@"请再次输入新密码！"];
        return;
    }
    if(![self.nPsw1.text isEqualToString:self.nPsw.text]){
        [tooles MsgBox:@"两次输入的新密码不一致！"];
        return;
    }
    [tooles showHUD:@"请稍候！"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"savePwd"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:self.oPsw.text forKey:@"password"];
    [request setPostValue:self.nPsw.text forKey:@"newpassword"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request setTimeOutSeconds:20];
    [request setNumberOfTimesToRetryOnTimeout:2];
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
    NSDictionary *loginJson = [all objectForKey:@"loginJson"];
    NSLog(@"loginjson===%@",loginJson);
    NSString *result = [loginJson objectForKey:@"result"];
    NSString *reason = [loginJson objectForKey:@"reason"];
    if([result isEqualToString:@"success"]){
        [tooles MsgBox:@"修改密码成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"result===%@",result);
        [tooles MsgBox:reason];
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
