//
//  TLRegister.m
//  TongLian
//
//  Created by mac on 13-11-11.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import "TLRegister.h"

@interface TLRegister ()

@end

@implementation TLRegister

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
    self.scrollerView.scrollEnabled = YES;
    //[self.scrollerView setContentSize:CGSizeMake(320,570)];
    //[self.checkNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    //[self.psw setSecureTextEntry:YES];
    //[self.psw1 setSecureTextEntry:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//提交注册请求
-(IBAction)btn_click:(id)sender{

    if(self.name.text.length == 0){
        [tooles MsgBox:@"请输入注册手机号！"];
        return;
    }
    if(self.checkNum.text.length == 0){
        [tooles MsgBox:@"请输入验证码！"];
        return;
    }
    
    [self.name resignFirstResponder];
    [self.checkNum resignFirstResponder];
    [self.refree resignFirstResponder];
    [tooles showHUD:@"正在注册。。。"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"checkPhone"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:self.name.text forKey:@"phoneNum"];
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
    if([loginTag isEqualToString:@"success"]){
        UIStoryboard *storyboard=nil;
        if (iPhone5) {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
        }
        else{
            storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
        }

        TLRegisterConfirmViewController *registerconfirm = [storyboard instantiateViewControllerWithIdentifier:@"registerConfrim" ];
        [registerconfirm setRegisterPhone:self.name.text];
        if(self.refree !=nil &&self.refree.text.length!=0){
            [registerconfirm setRefree:self.refree.text];
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] init];
        [navigationController pushViewController:registerconfirm animated:YES];

        
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else{
        [tooles MsgBox:loginTag];
    }
 
}
- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
//验证码获取
-(IBAction)verify:(id)sender{
    if(self.name.text.length == 0){
        [tooles MsgBox:@"请输入注册手机号！"];
        return;
    }
    [self.checkNumButton setTitle:@"验证码发送中" forState:UIControlStateNormal];
    [self.checkNumButton setEnabled:NO];
    [self.checkNumButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    NSString *urlstr;
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    if(myDelegate.URL!=nil && myDelegate.URL.length!=0){
         urlstr= [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"registerUI"];
    }
    else{
        [tooles MsgBox:@"连接不到服务器！"];
        return;
    }
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:self.name.text forKey:@"phoneNum"];
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
    NSString *name = [loginJson objectForKey:@"name"];
    NSString *s = [NSString stringWithFormat:@"此手机号已被%@注册，请核实！",name];
    if([loginTag isEqualToString:@"success"]){
        //[tooles MsgBox:@"验证码已发送，请稍候！"];
        self.secondsCountDown = 60;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
    else{
        [tooles MsgBox:s];
    }
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
