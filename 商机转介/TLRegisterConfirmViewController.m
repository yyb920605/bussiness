//
//  TLRegisterConfirmViewController.m
//  商机转介
//
//  Created by mac on 14-4-12.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLRegisterConfirmViewController.h"

@interface TLRegisterConfirmViewController ()

@end

@implementation TLRegisterConfirmViewController

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
    self.userType = @"MEMBER";
    
    //self.myScrollerView.scrollEnabled = YES;
    //[self.myScrollerView setContentSize:CGSizeMake(320,570)];
    //self.checkButton = [[ UICheckBoxButton alloc] initWithFrame: CGRectMake(20, 215, 160, 25)];
    //self.checkButton.label.text = @"我同意";
    //[self.view addSubview:self.checkButton];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)confirm:(id)sender{
    if(self.uname.text.length == 0){
        [tooles MsgBox:@"请输入姓名！"];
        return;
    }
    if(self.psw.text.length == 0){
        [tooles MsgBox:@"请输入密码！"];
        return;
    }if (![self.psw.text isEqualToString:self.psw1.text]) {
        [tooles MsgBox:@"两次输入密码不一致！"];
        return;
    }
//    if(self.checkButton.isChecked != YES){
//        [tooles MsgBox:@"请阅读通联支付协议！"];
//        return;
//    }
    [self.uname resignFirstResponder];
    [self.psw resignFirstResponder];
    [self.psw1 resignFirstResponder];
    [tooles showHUD:@"正在注册。。。"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"register"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:self.uname.text forKey:@"name"];
    [request setPostValue:self.psw.text forKey:@"password"];
    [request setPostValue:self.registerPhone forKey:@"userLoginId"];
    if(self.refree!=nil&&self.refree.length!=0){
        [request setPostValue:self.refree forKey:@"recommender"];
    }
    [request setPostValue:self.userType forKey:@"userType"];
    if(self.bankName!=nil&&self.bankName.length!=0){
        [request setPostValue:self.bankName forKey:@"bank"];
    }
    if(self.branch!=nil&&self.branch.length!=0){
        [request setPostValue:self.branch forKey:@"branch"];
    }
    if(self.subBranch!=nil&&self.subBranch.length!=0){
        [request setPostValue:self.subBranch forKey:@"subBranch"];
    }
    
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
    NSDictionary *loginJson = [all objectForKey:@"loginJson"];
    NSString *loginTag= [loginJson objectForKey:@"result"];
    NSString *reason = [loginJson objectForKey:@"reason"];
    if([loginTag isEqualToString:@"success"]){
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [view show];
    }
    else{
        [tooles MsgBox:reason];
    }
    
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIStoryboard *storyboard=nil;
    if (iPhone5) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }
    TLLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login" ];
    //保存用户名密码到文件
    NSArray *list = [NSArray arrayWithObjects:self.registerPhone,self.psw.text, nil];
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
-(IBAction)bank_click:(id)sender{
    [self.bank setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
    [self.person setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    [self.registerr setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    self.userType = @"BANKMEMBER";
    
    [tooles showHUD:@"正在加载银行列表。。。"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"bankList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult1:)];
    [request setDidFailSelector:@selector(GetErr1:)];
    [request startAsynchronous];

}
-(void)GetResult1:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *loginJson = [all objectForKey:@"androidAction"];
    NSDictionary *list1 = [loginJson objectAtIndex:0];
    NSArray *list = [list1 objectForKey:@"bankList"];
    
    UIStoryboard *storyboard=nil;

    storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    TLBankList *bankList = [storyboard instantiateViewControllerWithIdentifier:@"bankListt" ];
    [bankList setBankList:list];
    
    [self.navigationController pushViewController:bankList animated:YES];
    
}

- (void) GetErr1:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

-(IBAction)person_click:(id)sender{
    [self.bank setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    [self.person setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
    [self.registerr setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    self.userType = @"MEMBER";
    [self.bankchosed setText:@""];

}
-(IBAction)registerr_click:(id)sender{
    [self.bank setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    [self.person setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    [self.registerr setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
    self.userType = @"AGENTMEMBER";
    [self.bankchosed setText:@""];

}

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

-(IBAction)textFieldDone:(id)sender{
    [sender resignFirstResponder];
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
