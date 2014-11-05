//
//  TLBankcardViewController.m
//  商机转介
//
//  Created by mac on 14-4-14.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLBankcardViewController.h"

@interface TLBankcardViewController ()

@end

@implementation TLBankcardViewController
@synthesize btnSelect;
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
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"getBankCard"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    [tooles showHUD:@"稍候！"];
    //self.btnSelect.layer.borderWidth = 0.5;
    //self.btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
    self.btnSelect.layer.cornerRadius = 10;
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
    request = nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    self.bankcard = [all objectForKey:@"loginJson"];
    NSDictionary *lloginJson = [all objectForKey:@"lloginJson"];
    if(self.bankcard!=nil){
        if([self.bankcard objectForKey:@"name"]!=nil&&![[self.bankcard objectForKey:@"name"] isKindOfClass:[NSNull class]]){
            self.name.text =[self.bankcard objectForKey:@"name"];
        }
        if([self.bankcard objectForKey:@"phone"]!=nil&&![[self.bankcard objectForKey:@"name"] isKindOfClass:[NSNull class]]){
            self.phone.text =[self.bankcard objectForKey:@"phone"];
        }
        if([self.bankcard objectForKey:@"bankName"]!=nil&&![[self.bankcard objectForKey:@"name"] isKindOfClass:[NSNull class]]){
            self.btnSelect.titleLabel.text =[self.bankcard objectForKey:@"bankName"];
        }
//        else{
//            [self.btnSelect setTitle:@"请选择开户银行" forState:UIControlStateNormal];
//        }
        if([self.bankcard objectForKey:@"account"]!=nil&&![[self.bankcard objectForKey:@"name"] isKindOfClass:[NSNull class]]){
            self.account.text =[self.bankcard objectForKey:@"account"];
        }
        self.bankcardid = [self.bankcard objectForKey:@"bankcardid"];
    }
    
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [myDelegate setBankDic:lloginJson];
    [self setBankList:[lloginJson allKeys]];

    //NSDictionary *lloginJson = [all objectForKey:@"lloginJson"];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}
- (IBAction)selectClicked:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithArray:self.bankList];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    //[dropDown release];
    dropDown = nil;
}
-(IBAction)submmit:(id)sender{
    if([self.name.text length]==0){
        [tooles MsgBox:@"姓名不能为空"];
        return;
    }
    if([self.phone.text length]==0){
        [tooles MsgBox:@"电话不能为空"];
        return;
    }
    if([btnSelect.titleLabel.text isEqualToString:@"请选择开户银行"]){
        [tooles MsgBox:@"请选择开户银行"];
        return;
    }
    if([self.account.text length]==0){
        [tooles MsgBox:@"银行卡号不能为空"];
        return;
    }
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"bankCardAdd"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    [tooles showHUD:@"正在绑定中！"];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:self.bankcardid forKey:@"bankcardid"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:self.name.text forKey:@"name"];
    [request setPostValue:self.phone.text forKey:@"phone"];
    [request setPostValue:[myDelegate.bankDic objectForKey:self.btnSelect.titleLabel.text] forKey:@"bank"];
    [request setPostValue:self.account.text forKey:@"account"];
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
    NSDictionary *loginJson = [all objectForKey:@"loginJson"];
    NSLog(@"loginJSon===%@",loginJson);
    NSString *result = [loginJson objectForKey:@"result"];
    if([result isEqualToString:@"success"]){
        [tooles MsgBox:@"提交成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [tooles MsgBox:@"绑定银行卡不成功"];
    }
}

- (void) GetErr1:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
