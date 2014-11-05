//
//  TLLoginViewController.m
//  TongLian
//
//  Created by mac on 13-9-10.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import "TLLoginViewController.h"
#import "TLAppDelegate.h"
#import "TLBusinessController.h"
//#define URL @"http://61.163.100.203:9999/control/mobile/loginJson";
//#define URL @"http://10.88.1.59:8080/control/mobile/loginJson";
//#define URL @"http://10.88.80.10:9000/control/mobile/loginJson";

@interface TLLoginViewController ()

@end

@implementation TLLoginViewController
@synthesize userName,password,ServernameList;
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
//    if(iPhone5){
//        NSLog(@"iphone5");
//        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
//    }
//    else{
//        NSLog(@"iphone4");
//        [self.view setBounds:CGRectMake(0, 0, 320, 480)];
//    }
    //self.myScrollerView.scrollEnabled = YES;
    //[self.myScrollerView setContentSize:CGSizeMake(320,490)];

    [password setSecureTextEntry:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@/user.txt",documentDirectory,@"opportunity"];
    NSArray *list = [[NSArray alloc]initWithContentsOfFile:path];
    if([list count]!=0){
        [self.userName setText:[list objectAtIndex:0]];
        [self.password setText:[list objectAtIndex:1]];
    }
    //获取服务器列表
    //NSString *urlstr = @"http://10.88.1.59:8080/control/chance/getAddress";
    NSString *urlstr = @"http://61.163.100.203:5555/control/chance/getAddress";
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult1:)];
    [request setDidFailSelector:@selector(GetErr1:)];
    [request startAsynchronous];

	// Do any additional setup after loading the view.
}

-(void)GetResult1:(ASIHTTPRequest *)request{
    //接受字符串集
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *lloginJson = [all objectForKey:@"lloginJson"];
    //NSDictionary *loginJson = [all objectForKey:@"loginJson"];
    ServernameList = [lloginJson allKeys];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [myDelegate setServerDic:lloginJson];
    //TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *address = [myDelegate.ServerDic objectForKey:@"server"];
    if(address!=nil&&address.length!=0){
        [myDelegate setURL:address];
        //[myDelegate setURL:@"http://10.88.1.67:5080/control/chance"];
    }
}

- (void) GetErr1:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    //[dropDown release];
    dropDown = nil;
}

-(IBAction)login:(id)sender{
    if(userName.text.length==0||password.text.length==0){
        [tooles MsgBox:@"用户名或密码不能为空"];
        return;
    }
    //保存用户名密码到文件
    NSArray *list = [NSArray arrayWithObjects:userName.text,password.text, nil];
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
    
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [tooles showHUD:@"正在登录。。。。"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
     NSString *address = myDelegate.URL;
    if(address==nil){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"连接不到服务器😓" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    [myDelegate setURL:address];

    
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"login"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:userName.text forKey:@"userLoginId"];
    [request setPostValue:password.text forKey:@"password"];
    [request setPostValue:@"WVGA" forKey:@"imageType"];
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
    NSString *accountId = [loginJson objectForKey:@"accountId"];
    
    
    NSString *userType = [loginJson objectForKey:@"userType"];
    if(![loginTag isEqualToString:@"success"]){
        NSString *message = [loginJson objectForKey:@"reason"];
        [tooles MsgBox:message];
        return;
    }
    else{
        TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
        if(accountId != nil && ![accountId isKindOfClass:[NSNull class]]){
            myDelegate.accountId = accountId;
        }
        
        NSArray *advertiseAction = [all objectForKey:@"advertiseAction"];

        if(advertiseAction!=nil && [advertiseAction count]!=0){
            [myDelegate setPhotoList:advertiseAction];
        }
        myDelegate.loginName = self.userName.text;
        myDelegate.userType = userType;
        
        NSString *name = [loginJson objectForKey:@"name"];
        myDelegate.realname = name;
        
        UIStoryboard *storyboard=nil;
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
//        if (iPhone5) {
//            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
//        }
//        else{
//            storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
//        }
        UINavigationController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"navigation" ];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
-(IBAction)register_click:(id)sender{
    UIStoryboard *storyboard=nil;
    if (iPhone5) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }
    TLRegister *viewController = [storyboard instantiateViewControllerWithIdentifier:@"register" ];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(IBAction)findPsw:(id)sender{
    if(self.userName.text.length==0){
        [tooles MsgBox:@"请输入您的注册手机号码"];
        return;
    }
    UIStoryboard *storyboard=nil;
    if (iPhone5) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }

    TLFindPswViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"findPsw" ];
    [viewController setPhone:self.userName.text];
    [self presentViewController:viewController animated:YES completion:nil];

}
-(IBAction)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
