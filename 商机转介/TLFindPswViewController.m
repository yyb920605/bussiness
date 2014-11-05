//
//  TLFindPswViewController.m
//  商机转介
//
//  Created by mac on 14-5-4.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLFindPswViewController.h"

@interface TLFindPswViewController ()

@end

@implementation TLFindPswViewController

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
    [self.psw setSecureTextEntry:YES];
    [self.psw1 setSecureTextEntry:YES];
    //self.scrollerView.scrollEnabled = YES;
    //[self.scrollerView setContentSize:CGSizeMake(320,570)];
    // Do any additional setup after loading the view.
}

//提交更改密码请求
-(IBAction)btn_click:(id)sender{
    
    if(self.psw.text.length == 0){
        [tooles MsgBox:@"请输入新密码！"];
        return;
    }
    if(self.psw1.text.length == 0){
        [tooles MsgBox:@"请再次输入新密码！"];
        return;
    }
    if(![self.psw.text isEqualToString:self.psw1.text]){
        [tooles MsgBox:@"两次输入的密码不一致！"];
        return;
    }
    if(self.checkNum.text.length == 0){
        [tooles MsgBox:@"请输入验证码！"];
        return;
    }
    
    [self.psw resignFirstResponder];
    [self.checkNum resignFirstResponder];
    [self.psw1 resignFirstResponder];
    [tooles showHUD:@"正在提交请求。。。"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"changePwd"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:self.phone forKey:@"userLoginId"];
    [request setPostValue:self.psw.text forKey:@"password"];
    [request setPostValue:self.checkNum.text forKey:@"checkNum"];
    //    if(self.psw1.text.length > 0){
    //        [request setPostValue:self.psw1.text forKey:@"referee"];
    //    }
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
}
//返回首页
-(IBAction)back_click:(id)sender{
    UIStoryboard *storyboard=nil;
    if (iPhone5) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }

    TLLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login" ];
    [self presentViewController:login animated:YES completion:nil];
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
    NSString *loginTag= [loginJson objectForKey:@"result"];
    NSString *reason = [loginJson objectForKey:@"reason"];
    if([loginTag isEqualToString:@"success"]){
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"修改密码成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [view show];
    }
    else{
        [tooles MsgBox:reason];
    }
    
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    TLLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login" ];
    //保存用户名密码到文件
    NSArray *list = [NSArray arrayWithObjects:self.phone,self.psw.text, nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@/user.txt",documentDirectory,@"opportunity"];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",documentDirectory,@"opportunity"] withIntermediateDirectories:YES attributes:nil error:&error]){
        if(![list writeToFile:path atomically:YES]){
            NSLog(@"NO");
        }
    }
    
    [self presentViewController:login animated:YES completion:nil];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
//验证码获取
-(IBAction)verify:(id)sender{
    NSString *urlstr;
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    if(myDelegate.URL!=nil && myDelegate.URL.length!=0){
        urlstr= [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"changePwdUI"];
    }
    else{
        [tooles MsgBox:@"连接不到服务器！"];
        return;
    }
    [self.checkNumButton setTitle:@"验证码发送中" forState:UIControlStateNormal];
    [self.checkNumButton setEnabled:NO];
    [self.checkNumButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:self.phone forKey:@"userLoginId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult1:)];
    [request setDidFailSelector:@selector(GetErr1:)];
    [request startAsynchronous];
    
}
-(void)GetResult1:(ASIHTTPRequest *)request{
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *loginJson = [all objectForKey:@"loginJson"];
    NSString *loginTag= [loginJson objectForKey:@"result"];
    //NSString *name = [loginJson objectForKey:@"name"];
    NSString *s = [NSString stringWithFormat:@"验证码发送失败！请重新获取！"];
    if([loginTag isEqualToString:@"success"]){
        self.secondsCountDown = 30;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

    }
    else{
        [tooles MsgBox:s];
    }
    //接受字符串集
    
}
-(void)timeFireMethod{
    self.secondsCountDown--;
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        [self.checkNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.checkNumButton setEnabled:YES];
        [self.checkNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void) GetErr1:(ASIHTTPRequest *)request{
    
    [tooles MsgBox:@"验证码发送失败！请重新获取！"];
}
-(IBAction)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}
@end
